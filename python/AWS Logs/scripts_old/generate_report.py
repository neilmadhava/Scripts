import ipaddress
# import pandas as pd
import csv
import glob

# Initialise variable that will hold data to be written to excel file
write_data = []

log_files = ["july-14.log", "july-15.log"]
# Open the file in read mode
for log_file in log_files:
    print(f"Reading {log_file}")
    with open(log_file, 'r') as file:
        # Read each line in the file one by one
        for line in file:
            # Strip leading/trailing whitespace characters and print the line
            # print(line.strip().split(" "))
            data = line.strip().split(" ")
            action = data[12]
            dest_ip = data[4]
            try:
                # print(dest_ip)
                if(action != "REJECT" and dest_ip != "-"):
                    if(not ipaddress.ip_address(dest_ip).is_private):
                        write_data.append(data)
            except ValueError:
                continue

    # name of csv file
    filename = "july-" + log_file.split("-")[1].split(".")[0] + ".csv"

    print(f"\nGenerating file - {filename} ...")
    with open(filename, 'w') as csvfile:
        # creating a csv writer object
        csvwriter = csv.writer(csvfile)

        # writing the fields
        csvwriter.writerow(['version', 'account-id', 'interface-id', 'srcaddr', 'dstaddr', 'srcport', 'dstport', 'protocol', 'packets', 'bytes', 'start', 'end', 'action', 'log-status'])

        # writing the data rows
        csvwriter.writerows(write_data)
    
    print("Successfully generated " + filename)
    
    # df = pd.DataFrame(write_data, columns = ['version', 'account-id', 'interface-id', 'srcaddr', 'dstaddr', 'srcport', 'dstport', 'protocol', 'packets', 'bytes', 'start', 'end', 'action', 'log-status'])
    # df.to_excel("report-01.xlsx", index=False)