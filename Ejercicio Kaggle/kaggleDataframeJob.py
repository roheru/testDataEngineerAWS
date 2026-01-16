import pandas as pd
df = pd.read_csv("house-prices/train.csv", sep=",")

#print(df.columns)

for col in df.select_dtypes(include="number").columns:
    df[col].fillna(df[col].mean(), inplace=True)

#calcula el promedio de dos columnas llamadas MSSUBCLASS Y lotFrontage

df['AVG'] = (df['MSSubClass'] + df['LotFrontage']) / 2

print(df.head())
print(df.shape)

#En esta línea guarda como parquet
df.to_parquet("data_clean.parquet", engine='pyarrow', index=False)

