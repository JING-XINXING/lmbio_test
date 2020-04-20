import os
#os.chdir(r"G:\Pro_project\2019.07\0215\uniprot-mmu-filtered-organism__Mus+musculus+(Mouse)+[10090]_+AND+r--222.xlsx")
import pandas as pd


data = pd.read_csv("pre1.txt",sep="\t")

data["combine"] = data.loc[:,["Entry","genename"]].apply(lambda x: ":".join([str(i) if str(i) != "nan" else "" for i in x]),axis=1)
data["geneid1"]= data["geneid"].apply(lambda x: str(x).split(".")[0])
data=data.loc[:,["combine","Entry","geneid1","genename","Protein names"]]
data.columns=["combine","Entry","GeneID","Gene_Name","Product"]
data.to_csv("key5.xls",sep="\t",index=False)

#t = open("key5.xls","w")
#write("combine\tEntry\tGeneID\tGene_Name\tProduct\n")
#
# = open("pre2.txt","r")
#ine = f.readline()
#ine = f.readline()
#
#0 = pd.read_csv("pre1.txt",sep="\t")
# = dt0[dt0.iloc[:,2].notnull()]
#rint(dt.head())
#r i in range(0,dt.shape[0]):
##  print(dt.iloc[i,:])
#  if str(dt.iloc[i,3]) == "nan":
#      com = str(dt.iloc[i,0]) + ":" 
#      lg = dt.iloc[i,2]
#      lg = [x.strip() for x in lg if x != ""]
#      for g in lg:
#          t.write("{com}\t{x}\t{geneid}\t{name}\t{product}\n".format(com=com,x=dt.iloc[i,0],geneid=g,name="",product=dt.iloc[i,1]))
#  
#  if str(dt.iloc[i,3]) != "nan":
#      #com = str(dt.iloc[i,0]) + ":" + str(dt.iloc[i,3])
#      lg = dt.iloc[i,2]
# #     print(lg)
#      lg = [lg]
#      ln = dt.iloc[i,3].split(";")
#      ln = [x.strip() for x in ln if x != ""]
#      
#      if len(ln) > 1:
#          for k,j in zip(lg,ln):    # 当多个基因名对应到多个基因id时
#              com = str(dt.iloc[i,0]) + ":" + str(j)
#              t.write("{com}\t{x}\t{geneid}\t{name}\t{product}\n".format(com=com,x=dt.iloc[i,0],geneid=k,name=j,product=dt.iloc[i,1]))
#      if len(ln) == 1:   # 当一个基因名对应多个id时
#          com = str(dt.iloc[i,0]) + ":" + str(ln[0])
#          for y in lg:
#              t.write("{com}\t{x}\t{geneid}\t{name}\t{product}\n".format(com=com,x=dt.iloc[i,0],geneid=y,name=ln[0],product=dt.iloc[i,1]))
#  pass
#
#
#
#
# = dt0[dt0.iloc[:,2].isnull()]
#rint(dt.head())
#r i in range(0,dt.shape[0]):
##  print(dt.iloc[i,:])
#  if str(dt.iloc[i,3]) == "nan":
#      com = str(dt.iloc[i,0]) + ":"
#      lg = [" "]
#      lg = [x.strip() for x in lg if x != ""]
#      for g in lg:
#          t.write("{com}\t{x}\t{geneid}\t{name}\t{product}\n".format(com=com,x=dt.iloc[i,0],geneid=g,name="",product=dt.iloc[i,1]))
#
#  if str(dt.iloc[i,3]) != "nan":
#      #com = str(dt.iloc[i,0]) + ":" + str(dt.iloc[i,3])
#     # lg = dt.iloc[i,2].split(";")
# #     print(lg)
#      lg = [" "]
#      ln = dt.iloc[i,3].split(";")
#      ln = [x.strip() for x in ln if x != ""]
#
#      if len(ln) > 1:
#          for k,j in zip(lg,ln):    # 当多个基因名对应到多个基因id时
#              com = str(dt.iloc[i,0]) + ":" + str(j)
#              t.write("{com}\t{x}\t{geneid}\t{name}\t{product}\n".format(com=com,x=dt.iloc[i,0],geneid=k,name=j,product=dt.iloc[i,1]))
#      if len(ln) == 1:   # 当一个基因名对应多个id时
#          com = str(dt.iloc[i,0]) + ":" + str(ln[0])
#          for y in lg:
#              t.write("{com}\t{x}\t{geneid}\t{name}\t{product}\n".format(com=com,x=dt.iloc[i,0],geneid=y,name=ln[0],product=dt.iloc[i,1]))
#  pass
#
#
#
#
#
#
#
#
#
#
#t.close()
