import pandas as pd

d1 = pd.read_table("key5.xls",usecols=[0,2],dtype="object")
print(d1.head())
print(d1.shape)
d2 = pd.read_table("anno-kegg_gene.backgroud.txt",dtype="object",header=None)
d3 = pd.read_table("kegg_gene.backgroud.txt",dtype="object",header=None)

danno = pd.merge(d1,d2,left_on="GeneID",right_on=0)
dkegg = pd.merge(d1,d3,left_on="GeneID",right_on=0)

data1 = danno.iloc[:,[0,1,4]].drop_duplicates(subset="combine", keep='first', inplace=False)
data2 = dkegg.iloc[:,[0,3,4]].drop_duplicates(subset="combine", keep='first', inplace=False)
#data1 = danno.iloc[:,[0,1,4]]
#data2 = dkegg.iloc[:,[0,3,4]]

print(44)
data1.to_csv("anno-kegg_gene.backgroud.xls",sep="\t",index=False,header=False)
data2.to_csv("kegg_gene.backgroud.xls",sep="\t",index=False,header=False)
