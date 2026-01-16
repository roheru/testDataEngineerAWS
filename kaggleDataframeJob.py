import pandas as pd
df = pd.read_csv("house-prices/train.csv", sep=",")

#print(df.columns)

df['AVG'] = (df['MSSubClass'] + df['LotFrontage']) / 2

print(df.head())
print(df.shape)

df.to_parquet("data_clean.parquet", engine='pyarrow', index=False)