import dask.dataframe as dd
import glob


ddf = dd.read_csv('*.csv')
    
# Group by 'dstaddr' and calculate the sum of 'bytes'
result = ddf.groupby('dstaddr').size().compute().reset_index()

result = result.rename(columns={0: 'count'})

# set output filename
output_file_path = 'master-analysis.csv'

# Export the results to a new CSV file
result.to_csv(output_file_path, index=False)

print(f"Results have been saved to {output_file_path}")