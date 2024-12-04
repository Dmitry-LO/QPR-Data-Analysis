import pandas as pd
import numpy as np

# File path
file_path = '2022-09-01 415MHz RvsB 3.50K.txt'

# Load the file into a DataFrame
df = pd.read_csv(
    file_path,
    sep='\t',  # Change to ' ' for space-separated files
    header=0,  # Assumes first row contains column names
    na_values=['NaN', 'null', 'N/A'],  # Handle missing values
    parse_dates=['Date'],  # Replace 'date_column' with actual date column name
    dtype={
        'float_column': float,  # Replace with actual column names
        'int_column': int,
        'exponential_column': float,
    }
)

# Inspect the data
print(df.info())
#print(df.head())

