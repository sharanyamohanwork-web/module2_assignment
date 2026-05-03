# Spreadsheet Answers

## Cleaning Steps
- Created a `clean_merchant_name` column to normalize the casing and spacing of merchant names.
- Created a `clean_status` column to convert statuses to lowercase and remove trailing/leading spaces.
- Created a `clean_risk_score` column to extract the numeric value from the risk score strings.
- Created a `clean_gateway_region` column to normalize the region names and fill in missing values.

## Standardization Rules
- **Merchant Name**: Used `PROPER` and `TRIM` to apply Title Case and remove extra spaces.
- **Status**: Used `LOWER` and `TRIM` to ensure all statuses are completely lowercase.
- **Risk Score**: Extracted digits from strings (e.g. "score:62", "risk-83") and converted them to numeric values.
- **Gateway Region**: Converted existing regions to uppercase and removed spaces.

## Lookup and Enrichment Logic
- **Missing Regions**: For blank regions, used `VLOOKUP` against `merchant_master.csv` using the clean merchant name to pull the `default_region`.
- **Currency Conversion**: Used `XLOOKUP` to match both the transaction date and currency against `exchange_rates.csv` to fetch the correct USD exchange rate, and multiplied it by the raw amount.
- **Merchant Details**: Used `VLOOKUP` and `INDEX/MATCH` to pull in Merchant ID, Account Manager, and Merchant Category from the master sheet.
- **Business Flags**: Calculated `high_value_flag` and `high_risk_flag` using nested IF/OR/AND statements based on the required thresholds and conditions.

## Final Answers
- **Total raw rows**: 30
- **Total cleaned rows**: 30
- **Invalid or missing rows handled**: 10
- **Top region by GMV**: APAC
- **Number of high value transactions**: 7
- **Number of high risk transactions**: 9
- **Top merchant by captured GMV**: Beta Stores

## Formula Samples
- **Clean Merchant Name**: `=PROPER(TRIM(C2))`
- **Clean Status**: `=LOWER(TRIM(H2))`
- **Clean Risk Score**: `=IF(ISBLANK(J2), "", VALUE(REGEXEXTRACT(J2, "\d+")))`
- **Clean/Enrich Gateway Region**: `=IF(TRIM(L2)="", VLOOKUP(C2, merchant_master!$B:$E, 4, FALSE), UPPER(TRIM(L2)))`
- **Amount USD (XLOOKUP method)**: `=E2 * XLOOKUP(B2&F2, exchange_rates!A:A&exchange_rates!B:B, exchange_rates!C:C)`
- **Amount USD (INDEX/MATCH method)**: `=E2 * INDEX(exchange_rates!$C:$C, MATCH(1, (exchange_rates!$A:$A=B2) * (exchange_rates!$B:$B=F2), 0))`
- **Merchant ID**: `=INDEX(merchant_master!$A:$A, MATCH(C2, merchant_master!$B:$B, 0))`
- **Account Manager**: `=VLOOKUP(C2, merchant_master!$B:$E, 2, FALSE)`
- **Merchant Category**: `=VLOOKUP(C2, merchant_master!$B:$E, 3, FALSE)`
- **High Value Flag**: `=IF(OR(AND(L2="APAC", G2>5000), AND(L2="EU", G2>6000), AND(L2="US", G2>7000)), 1, 0)`
- **High Risk Flag**: `=IF(OR(J2>=70, ISNUMBER(SEARCH("chargeback", H2))), 1, 0)`