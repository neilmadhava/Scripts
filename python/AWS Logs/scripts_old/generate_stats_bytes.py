import dask.dataframe as dd
import glob


# Replace 'network_log.csv' with the path to your input CSV file
input_files = glob.glob("*.csv")

for input_file in input_files:    
    # Read the CSV file into a Dask DataFrame
    ddf = dd.read_csv(input_file)

    print(f"Reading {input_file} ...")
    # Group by 'dstip' and calculate the sum of 'bytes'
    result = ddf.groupby('dstaddr')['bytes'].sum().compute()

    # Convert the result to a DataFrame and reset index
    result_df = result.reset_index()
    result_df.columns = ['dstaddr', 'total_bytes']

    # set output filename
    output_file_path = 'analysis' + input_file.split("-")[1].split(".")[0] + '.csv'

    # Export the results to a new CSV file
    result_df.to_csv(output_file_path, index=False)

    print(f"Results have been saved to {output_file_path}")