import dask.dataframe as dd
import glob

ddf = dd.read_csv('*.csv')

# Group by 'dstaddr' and calculate the sum of 'bytes'
result = ddf.groupby('dstaddr')['bytes'].sum().compute().reset_index()

# set output filename
output_file_path = 'analysis.csv'

# Export the results to a new CSV file
result.to_csv(output_file_path, index=False)

print(f"Results have been saved to {output_file_path}")