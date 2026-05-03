import sqlite3
import pandas as pd
import os

# Define paths
script_dir = os.path.dirname(os.path.abspath(__file__))
csv_path = os.path.join(script_dir, '..', '01_data', 'processed', 'cleaned_transactions.csv')
db_path = os.path.join(script_dir, 'local_fintech.db')
sql_file = os.path.join(script_dir, 'analysis_queries.sql')

# 1. Load the cleaned data from Part 1
print(f"Loading data from {csv_path}...")
df = pd.read_csv(csv_path)

# 2. Create a local SQLite database and load the data into a table
print(f"Creating local SQLite database at {db_path}...")
conn = sqlite3.connect(db_path)
df.to_sql('cleaned_transactions', conn, if_exists='replace', index=False)
print("Table 'cleaned_transactions' created successfully!\n")

# 3. Read the queries from analysis_queries.sql
print(f"Reading SQL queries from {sql_file}...")
with open(sql_file, 'r') as f:
    sql_text = f.read()

# Split by semicolon to get individual queries
queries = sql_text.split(';')

# 4. Execute each query and print the results
for i, q in enumerate(queries):
    q = q.strip()
    if not q:
        continue
    
    print("=" * 50)
    print(f"Executing Query:\n{q}")
    print("-" * 50)
    
    try:
        # Run the query and fetch results into a pandas DataFrame for nice formatting
        result_df = pd.read_sql_query(q, conn)
        if result_df.empty:
            print("(No results returned)")
        else:
            print(result_df.to_string(index=False))
    except Exception as e:
        print(f"Error executing query: {e}")
    
    print("=" * 50 + "\n")

conn.close()
