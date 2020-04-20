import pandas as pd
import numpy as np
import os

if "差异蛋白筛选结果.xlsx" in os.listdir():
    file = pd.ExcelFile("差异蛋白筛选结果.xlsx")
    sheets = file.sheet_names
    print(sheets)
    sheet = [x for x in sheets if "可信" in x and "分组" not in x]
    d = pd.read_excel(file,sheet[0],index_col=0)

if "差异位点筛选结果.xlsx" in os.listdir():
    file = pd.ExcelFile("差异位点筛选结果.xlsx")
    sheets = file.sheet_names
    print(sheets)
    sheet = [x for x in sheets if "可信" in x and "分组" not in x]
    d = pd.read_excel(file,sheet[0])
    d["Accession"] = d["Protein"].apply(lambda x: x.split("|")[1])
    d = d.set_index("Accession")



data = pd.read_csv("pre1.txt",index_col=0,sep="\t")
index_project = [x for x in data.index if x in d.index]

data_key = data.loc[index_project,:]
#data_key = data_key.reset_index()
#data_key2 = data_key.loc[:,["combine","Entry","GeneID","Gene_Name","Product"]] 
data_key.to_csv("pre2.txt",sep="\t")


#key5 = pd.read_csv("key5.xls",sep="\t",index_col=1)
#k = key5.loc[d.index,"combine"].values
#k = [x for x in k if str(x) != "nan"]
#dkegg = pd.read_csv("kegg_gene.backgroud.xls",header=None,sep="\t",index_col=0)
#dkegg.loc[k,:].dropna(how="all").to_csv("gene_kegg.backgroud.xls",sep="\t",header=False)

#danno = pd.read_csv("anno-kegg_gene.backgroud.xls",header=None,sep="\t",index_col=0)
#danno.loc[k,:].dropna(how="all").to_csv("gene_anno-kegg.backgroud.xls",sep="\t",header=False)

#dgo = pd.read_csv("gene_go.backgroud.xls",header=None,sep="\t",index_col=0)
#dgo.loc[k,:].dropna(how="all").to_csv("gene_go.backgroud.xls",sep="\t",header=False)
