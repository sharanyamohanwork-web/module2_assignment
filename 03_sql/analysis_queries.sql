-- Q1
SELECT status_clean, COUNT(*) as txn_count
FROM cleaned_transactions
GROUP BY status_clean;

-- Q2
SELECT merchant_name_cleaned, SUM(amount_usd) as total_captured_gmv
FROM cleaned_transactions
WHERE status_clean = 'captured'
GROUP BY merchant_name_cleaned;

-- Q3
SELECT merchant_name_cleaned, SUM(amount_usd) as total_captured_gmv
FROM cleaned_transactions
WHERE status_clean = 'captured'
GROUP BY merchant_name_cleaned
ORDER BY total_captured_gmv DESC
LIMIT 10;

-- Q4
SELECT transaction_date, SUM(amount_usd) as daily_gmv, COUNT(*) as successful_txn_count
FROM cleaned_transactions
WHERE status_clean = 'captured'
GROUP BY transaction_date
ORDER BY transaction_date;

-- Q5
SELECT merchant_name_cleaned,
       SUM(CASE WHEN status_clean = 'chargeback' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) as chargeback_ratio
FROM cleaned_transactions
GROUP BY merchant_name_cleaned
HAVING SUM(CASE WHEN status_clean = 'chargeback' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) > 0.01;

-- Q6
SELECT gateway_region_clean, AVG(risk_score_clean) as avg_risk_score, COUNT(*) as txn_count
FROM cleaned_transactions
GROUP BY gateway_region_clean
HAVING AVG(risk_score_clean) > 50 AND COUNT(*) > 20;

-- Q7
SELECT user_id, transaction_date, COUNT(*) as failed_chargeback_count
FROM cleaned_transactions
WHERE status_clean LIKE '%failed%' OR status_clean = 'chargeback'
GROUP BY user_id, transaction_date
HAVING COUNT(*) >= 3;

-- Q8
SELECT merchant_name_cleaned,
       COUNT(*) as chargeback_count,
       COUNT(DISTINCT user_id) as unique_users,
       SUM(amount_usd) as total_chargeback_amount
FROM cleaned_transactions
WHERE status_clean = 'chargeback'
GROUP BY merchant_name_cleaned;
