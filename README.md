# QuickPay FinTech Operations Case Study

## Student Details
**Student Name:** Sharanya Mohan
**Student ID:** bitsom_ftai_260183
**Public GitHub Repository Link:** https://github.com/sharanyamohanwork-web/module2_assignmentS

## Tools Used
- **Spreadsheet Software:** Excel / Google Sheets (Data Cleaning & Enrichment)
- **SQL / Database:** SQLite via Python (Business Analysis)
- **Programming Language:** Python (Pandas, SQLite3)
- **Package Manager:** uv
- **Visualization:** Looker Studio

## Short Run Instructions

### 1. Data Processing (Part 1)
- The raw transaction data was cleaned in Excel/Google sheets (`02_spreadsheet/spreadsheet_workbook.xlsx`).
- The final cleaned output is saved to `01_data/processed/cleaned_transactions.csv`.

### 2. SQL Analysis (Part 2)
To run the SQL business analysis queries locally, a Python script has been provided that automatically builds a local SQLite database from the cleaned CSV and executes the queries.
1. Open your terminal in the root of the repository.
2. Ensure you have `uv` installed.
3. Run the following command:
   ```bash
   uv run --with pandas python 03_sql/run_sql.py
   ```
4. The outputs of the SQL queries will be printed directly to your terminal.

### 3. Reconciliation Workflow (Part 3 & 4)
- Run the Jupyter Notebook located at `04_python/fintech_pipeline.ipynb` to execute the reconciliation logic and JSON normalization.

### 4. Dashboard (Part 5)
- The final visualizations are available via the public Looker Studio link found in `05_visualization/dashboard_link.txt`.
