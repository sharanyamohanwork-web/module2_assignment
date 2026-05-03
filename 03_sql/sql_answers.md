# SQL Answers

## Q1
### Query
```sql
SELECT status_clean, COUNT(*) as txn_count
FROM cleaned_transactions
GROUP BY status_clean;
```
### Result Summary
The total transaction counts by status are:
- Captured: 19
- Failed (E05 Timeout): 7
- Chargeback: 4

## Q2
### Query
```sql
SELECT merchant_name_cleaned, SUM(amount_usd) as total_captured_gmv
FROM cleaned_transactions
WHERE status_clean = 'captured'
GROUP BY merchant_name_cleaned;
```
### Result Summary
Total captured GMV by merchant:
- Beta Stores: $33,431.00
- Alpha Mart: $29,984.50
- Delta Travels: $10,300.00
- City Pharma: $8,640.00

## Q3
### Query
```sql
SELECT merchant_name_cleaned, SUM(amount_usd) as total_captured_gmv
FROM cleaned_transactions
WHERE status_clean = 'captured'
GROUP BY merchant_name_cleaned
ORDER BY total_captured_gmv DESC
LIMIT 10;
```
### Result Summary
The top merchants by captured GMV (in descending order) are Beta Stores, Alpha Mart, Delta Travels, and City Pharma. (Only 4 merchants had captured transactions).

## Q4
### Query
```sql
SELECT transaction_date, SUM(amount_usd) as daily_gmv, COUNT(*) as successful_txn_count
FROM cleaned_transactions
WHERE status_clean = 'captured'
GROUP BY transaction_date
ORDER BY transaction_date;
```
### Result Summary
Daily successful performance:
- 01-03-2026: 5 txns ($26,382.00)
- 02-03-2026: 3 txns ($11,080.00)
- 03-03-2026: 4 txns ($16,031.50)
- 04-03-2026: 4 txns ($13,920.00)
- 05-03-2026: 1 txn ($6,136.00)
- 06-03-2026: 2 txns ($8,806.00)

## Q5
### Query
```sql
SELECT merchant_name_cleaned,
       SUM(CASE WHEN status_clean = 'chargeback' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) as chargeback_ratio
FROM cleaned_transactions
GROUP BY merchant_name_cleaned
HAVING SUM(CASE WHEN status_clean = 'chargeback' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) > 0.01;
```
### Result Summary
All four merchants with chargebacks had a ratio above 1%:
- Alpha Mart (~9.1%)
- Beta Stores (~9.1%)
- Delta Travels (25%)
- Eco Home (50%)

## Q6
### Query
```sql
SELECT gateway_region_clean, AVG(risk_score_clean) as avg_risk_score, COUNT(*) as txn_count
FROM cleaned_transactions
GROUP BY gateway_region_clean
HAVING AVG(risk_score_clean) > 50 AND COUNT(*) > 20;
```
### Result Summary
Only the APAC region meets this criteria with an average risk score of ~65.5 across 22 transactions.

## Q7
### Query
```sql
SELECT user_id, transaction_date, COUNT(*) as failed_chargeback_count
FROM cleaned_transactions
WHERE status_clean LIKE '%failed%' OR status_clean = 'chargeback'
GROUP BY user_id, transaction_date
HAVING COUNT(*) >= 3;
```
### Result Summary
User `U008` is the only one who meets this criteria, with 4 failed or chargeback transactions on 2026-03-05.

## Q8
### Query
```sql
SELECT merchant_name_cleaned,
       COUNT(*) as chargeback_count,
       COUNT(DISTINCT user_id) as unique_users,
       SUM(amount_usd) as total_chargeback_amount
FROM cleaned_transactions
WHERE status_clean = 'chargeback'
GROUP BY merchant_name_cleaned;
```
### Result Summary
- Alpha Mart: 1 chargeback, 1 unique user, $5,400.00
- Beta Stores: 1 chargeback, 1 unique user, $1,711.00
- Delta Travels: 1 chargeback, 1 unique user, $2,500.00
- Eco Home: 1 chargeback, 1 unique user, $6,649.00
