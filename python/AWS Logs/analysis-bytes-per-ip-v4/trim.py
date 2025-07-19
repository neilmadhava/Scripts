import pandas as pd
import ipaddress
import glob

# Load CIDR networks from the text file
def load_cidr_networks(file_path):
    with open(file_path, 'r') as file:
        cidr_networks = [ipaddress.ip_network(line.strip()) for line in file if line.strip()]
    return cidr_networks

# Check if an IP address belongs to any of the CIDR networks
def is_ip_in_networks(ip, networks):
    ip_obj = ipaddress.ip_address(ip)
    return any(ip_obj in network for network in networks)

# Load the Excel file into a DataFrame
def filter_excel_file(excel_file, cidr_file, output_file):
    # Load CIDR networks
    cidr_networks = load_cidr_networks(cidr_file)

    # Read the Excel file
    df = pd.read_excel(excel_file)

    # Filter out rows where 'dstaddr' is in any of the CIDR networks
    filtered_df = df[~df['dstaddr'].apply(lambda x: is_ip_in_networks(x, cidr_networks))]

    # Write the filtered DataFrame to a new Excel file
    filtered_df.to_excel(output_file, index=False)

# File paths
excel_file_paths = glob.glob("*.xlsx")
cidr_file_path = 'networks.txt'  # Replace with your CIDR networks file path


for excel_file_path in excel_file_paths:
    # Run the filtering
    output_file_path = excel_file_path + '-filtered.xlsx'  # Replace with desired output file path
    filter_excel_file(excel_file_path, cidr_file_path, output_file_path)
    print(f"Filtered Excel file saved as '{output_file_path}'.")
