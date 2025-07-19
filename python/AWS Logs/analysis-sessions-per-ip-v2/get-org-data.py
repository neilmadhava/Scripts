import pandas as pd
from ipwhois import IPWhois
import dask.dataframe as dd

# Function to perform IP geolocation lookup and return organization
def get_organization(ip_address):
    try:
        results = IPWhois(ip_address).lookup_rdap()
        print(f"Getting data for {ip_address}")
        return results['network']['name'] if 'network' in results else 'Unknown'
    except Exception as e:
        print(f"Error: {e}")
        return 'Unknown'

# Input CSV file path and output CSV file path
input_csv_path = 'master-analysis-july.csv'
output_csv_path = 'master-analysis-july-sorted.csv'

# Read CSV into a pandas DataFrame
ddf = dd.read_csv(input_csv_path)
ddf_sorted = ddf.nlargest(50, 'count')
df_top_50 = ddf_sorted.compute()

# get whois data for top 20 rows
df_top_50['organization'] = df_top_50['dstaddr'].apply(get_organization)

# merge with the rest of the data
df_merged = dd.merge(ddf, df_top_50[['dstaddr', 'organization']], on='dstaddr', how='left')

# sort based on count
df_final = df_merged.compute().sort_values(by='count', ascending=False)

# Save the updated DataFrame to a new CSV file
df_final.to_csv(output_csv_path, index=False)

print(f"Output CSV file saved: {output_csv_path}")
