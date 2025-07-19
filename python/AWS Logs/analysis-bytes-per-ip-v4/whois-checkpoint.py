import pandas as pd
from ipwhois import IPWhois
import os
import time
import signal
import sys

# File paths
excel_file_path = 'july-master.xlsx'  # Replace with your input Excel file path
output_file_path = 'july-master-whois.xlsx'  # Replace with your output Excel file path
checkpoint_file_path = 'checkpoint.txt'  # File to store the last processed row index

# Global variable to store the interruption flag
interrupted = False

# Signal handler to catch interruptions (Ctrl+C)
def signal_handler(sig, frame):
    global interrupted
    interrupted = True
    print("Interruption detected. Saving progress...")

signal.signal(signal.SIGINT, signal_handler)

# Function to get organisation name from IP address
def get_organisation(ip):
    try:
        obj = IPWhois(ip)
        print(f"Getting data for {ip}")
        res = obj.lookup_rdap()
        org = res.get('network', {}).get('name', 'N/A')
        return org
    except Exception as e:
        print(f"Error retrieving WHOIS data for IP {ip}: {e}")
        return None

# Function to load checkpoint
def load_checkpoint():
    if os.path.exists(checkpoint_file_path):
        with open(checkpoint_file_path, 'r') as file:
            return int(file.read().strip())
    return 0

# Function to save checkpoint
def save_checkpoint(index):
    with open(checkpoint_file_path, 'w') as file:
        file.write(str(index))

# Function to process the Excel file in batches
def process_excel_file():
    # Load the Excel file
    df = pd.read_excel(excel_file_path)

    # Load checkpoint
    start_index = load_checkpoint()

    # Process in batches
    batch_size = 3
    for start in range(start_index, len(df), batch_size):
        if interrupted:
            save_checkpoint(start)
            print("Progress saved. Exiting...")
            sys.exit()

        end = min(start + batch_size, len(df))
        batch_df = df.iloc[start:end].copy()
        
        # Get WHOIS organisation for each IP
        batch_df['organisation'] = batch_df['dstaddr'].apply(get_organisation)

        # Append to output file
        if not os.path.exists(output_file_path):
            batch_df.to_excel(output_file_path, index=False)
        else:
            with pd.ExcelWriter(output_file_path, mode="a", engine="openpyxl", if_sheet_exists="overlay") as writer:   
                batch_df.to_excel(writer, startrow=start+1, header=False, index=False, index_label=None)
 
            # batch_df.to_excel(output_file_path, index=False, mode="a", header=False)

        print(f"Processed rows {start} to {end}.")

        # Delay to avoid hitting rate limits
        time.sleep(1)

    # Remove checkpoint file on successful completion
    if os.path.exists(checkpoint_file_path):
        os.remove(checkpoint_file_path)

    print("Processing complete. All data has been saved.")

# Run the processing function
process_excel_file()
