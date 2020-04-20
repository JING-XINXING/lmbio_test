import os
f = open("gene_anno-kegg.backgroud.xls","r")
t = open("gene_anno-kegg.backgroud3.xls","w")

lines= f.readlines()
for i in lines:
    x = i.split("\t")
    x[1] = str(x[1]).split(".")[0]

    t.write("\t".join(x))

f.close()
t.close()

os.remove("gene_anno-kegg.backgroud.xls")
os.rename("gene_anno-kegg.backgroud3.xls","gene_anno-kegg.backgroud.xls")

