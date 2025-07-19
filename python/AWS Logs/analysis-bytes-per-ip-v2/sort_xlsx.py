import pandas as pd
import dask.dataframe as dd
import glob

input_files = glob.glob("analysis-*.xlsx")
for input_file in input_files:    
    # Read the CSV file into a Dask DataFrame
    print(f"Reading {input_file}")
    df = pd.read_excel(input_file)

    # sort on bytes
    print("Sorting ...")
    df_final = df.sort_values(by=['total_bytes'], ascending=False)

    # Output-file-name
    output_csv_path = 'analysis-sorted-' + input_file.split("-")[1].split(".")[0] + '.xlsx'

    # Save the updated DataFrame to a new CSV file
    print(f"Generating {output_csv_path}")
    df_final.to_excel(output_csv_path, index=False)

    print(f"Output CSV file saved: {output_csv_path}")
