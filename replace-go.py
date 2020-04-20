import pandas as pd
import os

d1 = pd.read_table("key5.xls",usecols=[0,1],dtype="object")
print(d1.head())
print(d1.shape)
d2 = pd.read_table("gene_go.backgroud.xls",dtype="object",header=None)


dgo = pd.merge(d1,d2,left_on="Entry",right_on=0)


data1 = dgo.iloc[:,[0,3,4]].drop_duplicates(subset="combine", keep='first', inplace=False)


data1.to_csv("gene_go.backgroud.xls",sep="\t",index=False,header=False)
