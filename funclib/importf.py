import pandas as pd
import numpy as np

# File path
file_path = '2022-09-01 415MHz RvsB 3.50K.txt'

# Load the file into a DataFrame
nfile = pd.read_csv(
    file_path,
    sep="\t", 
    header=0,
    na_values="NaN",
    date_format="%y/%m/%d",
    parse_dates=["Date"]
)

# Inspect the data
#print(nfile.info())
a=nfile.head(8)
print(type(a))
#print(df.head())

