import pandas as pd
import re
import os

def loading_information():
    # 读取比较组， 返回上传文件列表
    dc = pd.read_excel('sample_information.xlsx', sheet_name="比较组信息")
    s_compare = dc.loc[:, "比较组"].tolist()
    s_compare = [x for x in s_compare if str(x) != "nan"]
    list_comparation = []
    print(s_compare)
    for i in s_compare:
        if "/" in i:
            compare0 = re.split("[/]", i)
            compare = compare0[0] + "_" + compare0[1]
            filename =  compare0[0] + "-vs-" + compare0[1] + "-diff-protein" + ".xls"
            print(compare)
        else:
            compare = i

        if "差异蛋白筛选结果.xlsx" in os.listdir():
            df = pd.read_excel("差异蛋白筛选结果.xlsx", sheet_name=compare)

        if "差异位点筛选结果.xlsx" in os.listdir():
            df = pd.read_excel("差异位点筛选结果.xlsx", sheet_name=compare)

        if "Accession" in df.columns:
            df2 = df.loc[:, ["Accession", "FC"]]
            print(df2.head())
            df2 = df2.values.tolist()
        elif "Majority protein IDs" in df.columns:
            df2 = df.loc[:, ["Majority protein IDs", "FC"]].copy()

            def fun(x):
                m = x.split("|")[1]
                print(m)
                return m

            df2["Accession"] = df2.loc[:,"Majority protein IDs"].apply(fun)
            df2 = df2.loc[:, ["Accession", "FC"]].copy()
            df2 = df2.values.tolist()
            print(df2)

        elif "ProteinAccessions" in df.columns:
            df2 = df.loc[:, ["ProteinAccessions", "FC"]]
            df2 = df2.values.tolist()

        elif "Protein" in df.columns:
            df["Accession"] = df["Protein"].apply(lambda x: x.split("|")[1])
            df2 = df.loc[:, ["Accession", "FC"]]
            print(df2.head())
            df2 = df2.values.tolist()

        elif "FC" not in df.columns:
            df["FC"] = 1.2
            df2 = df.loc[:, ["Accession", "FC"]]
            df2 = df2.values.tolist()

        #filename = compare + ".txt"
        list_comparation.append(filename)

        with open(filename, "w") as f:
            f.write("id" + "\t" + "FC" + "\t" + "up_down")
            f.write("\n")
            for line in df2:
                if float(line[1]) > 1:
                    f.write(str(line[0])+ "\t" + str(line[1]) + "\t" + "Up")
                    f.write("\n")
                if float(line[1]) < 1:
                    f.write(str(line[0])+ "\t" + str(line[1]) + "\t" + "Down")
                    f.write("\n")
    return list_comparation

loading_information()
