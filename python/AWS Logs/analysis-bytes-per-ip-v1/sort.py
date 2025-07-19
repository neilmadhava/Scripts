import pandas as pd
import dask.dataframe as dd
import glob

input_files = glob.glob("analysis-*.csv")
for input_file in input_files:    
    # Read the CSV file into a Dask DataFrame
    ddf = dd.read_csv(input_file)

    # sort on bytes
    df_final = ddf.sort_values(by='total_bytes', ascending=False)

    # Output-file-name
    output_csv_path = 'analysis-sorted-' + input_file.split("-")[1].split(".")[0] + '.csv'

    # Save the updated DataFrame to a new CSV file
    df_final.compute().to_csv(output_csv_path, index=False)

    print(f"Output CSV file saved: {output_csv_path}")
