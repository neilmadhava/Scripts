import dask.dataframe as dd
import glob


input_files = glob.glob("*.csv")

for input_file in input_files:    
    # Read the CSV file into a Dask DataFrame
    ddf = dd.read_csv(input_file)
        
    # Group by 'dstaddr' and calculate the sum of 'bytes'
    result = ddf.groupby('dstaddr').size().compute().reset_index()

    result = result.rename(columns={0: 'count'})

    # set output filename
    output_file_path = 'analysis-' + input_file.split("-")[1].split(".")[0] + '.csv'

    # Export the results to a new CSV file
    result.to_csv(output_file_path, index=False)

    print(f"Results have been saved to {output_file_path}")