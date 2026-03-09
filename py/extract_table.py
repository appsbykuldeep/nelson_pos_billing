import requests
from bs4 import BeautifulSoup
import pandas as pd


url = "https://www.bajajfinserv.in/insurance/rto"
res = requests.get("https://www.bajajfinserv.in/insurance/rto")

html_content  = res.text

soup = BeautifulSoup(html_content, 'lxml')

tables = soup.find_all('table')

dfs = []


state_codes = []

# for i, table in enumerate(tables):
#     df = pd.read_html(str(table))[0]
#     dfs.append(df)



# for i, df in enumerate(dfs):
#     print(f"Table {i+1}:")
#     print(df)
#     print("\n")


for i, table in enumerate(tables):
    df = pd.read_html(str(table))[0]
    dfs.append(df)
    
    # Save each table as a separate CSV file
    csv_filename = f"table_{i+1}.csv"
    df.to_csv(csv_filename, index=False)
    print(f"Saved table {i+1} as {csv_filename}")

# with open("rto.txt",'w+') as f:
#     f.write(res.text)

