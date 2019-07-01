# Databricks notebook source
print ('Hello World!')

# COMMAND ----------

# MAGIC %md
# MAGIC # Header 1
# MAGIC Here is some description about **below** code.
# MAGIC ## Header 2
# MAGIC ### Header 3
# MAGIC #### Header 4
# MAGIC ##### Header 5
# MAGIC ###### Header 6
# MAGIC You can put an image too: <img src="https://sqlplayer.net/wp-content/uploads/2017/07/SQL_Player_Logo_h120.png" />
# MAGIC 
# MAGIC More about MarkDown - read [this page](https://guides.github.com/features/mastering-markdown/).

# COMMAND ----------

import pandas as pd
url = 'https://www.stats.govt.nz/assets/Uploads/Business-price-indexes/Business-price-indexes-March-2019-quarter/Download-data/business-price-indexes-march-2019-quarter-csv.csv'
data = pd.read_csv(url)

# COMMAND ----------

data

# COMMAND ----------

type(data)

# COMMAND ----------

print(data)

# COMMAND ----------

df = data
export_excel = df.to_excel (r'/dbfs/tmp/export_dataframe.xlsx', index = None, header=True) #Don't forget to add '.xlsx' at the end of the path

