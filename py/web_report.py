import requests as req
import pandas as pd

data = []


def generate_markdown_table(headers, rows):
    # Calculate the width of each column
    column_widths = [
        max(len(str(cell)) for cell in column) for column in zip(headers, *rows)
    ]

    # Create the Markdown header row with dynamic widths
    header_row = "| " + " | ".join(f"{header:<{column_widths[i]}}" for i, header in enumerate(headers)) + " |\n"
    separator_row = "| " + " | ".join("-" * column_widths[i] for i in range(len(headers))) + " |\n"

    # Initialize table with headers and separator
    markdown_table = header_row + separator_row

    # Add each row of data with dynamic widths
    for row in rows:
        markdown_table += "| " + " | ".join(f"{str(cell):<{column_widths[i]}}" for i, cell in enumerate(row)) + " |\n"
    
    print(markdown_table)
    return markdown_table


res = req.post("https://ganpatitechnologies.com/vParking/api/webrep_stand.php",headers={"token" : "shopqrapirequest" })
if(res.status_code == 200):
    result = res.json()
    if result.get("ResultStatus") == True:
        data = result.get("ResultData",[])



df = pd.DataFrame(data)
# df

df.to_csv('./others/py/report.csv')


# def getTabularDataFromJson(dictList):
#     headers = []
#     rows = []
#     for indx,row in enumerate(dictList):
#         if indx == 0:
#             headers = row.keys()
        
#         new_row = []
#         for k in headers:
#             new_row.append(row.get(k,None))
#         rows.append(new_row)
#     return headers,rows
            


# generate_markdown_table(headers,rows)




