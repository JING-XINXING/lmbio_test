import pandas as pd
import re

df = pd.read_table("key5.xls",usecols=[0,1],dtype="object")



dc = pd.read_excel('sample_information.xlsx', sheet_name="比较组信息")
s_compare = dc.loc[:, "比较组"].tolist()
s_compare = [x for x in s_compare if str(x) != "nan"]
list_comparation = []
for i in s_compare:
    if "/" in i:
        compare0 = re.split("[/]", i)
        compare = compare0[0] + "_" + compare0[1]
        filename = compare0[0] + "-vs-" + compare0[1] + "-diff-protein" + ".xls"
        print(compare)
    else:
        compare = i

    data = pd.read_table(filename)
    db = pd.merge(df,data,left_on="Entry",right_on="id")
    print(db.columns)
    db = db.iloc[:,[0,3,4]]
    db.drop_duplicates(subset="combine", keep='first', inplace=True)
    db.to_csv(filename,sep="\t",index=False)
