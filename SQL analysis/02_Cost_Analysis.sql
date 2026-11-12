-- 02 Cost Analysis
-- CMS Medicare DE-SynPUF | SQLite dialect
-- Run queries individually in DB Browser for SQLite or another SQLite client.

-- ----------------------------------------------------------------------
-- Query 01: Claim_Cost_Inpatient/Outpatient
-- ----------------------------------------------------------------------
--Outpatient and inpatient claims cost comparison

SELECT 
	Claim_Type, 
	count(Claim_ID) as Total_Claims, 
	SUM(Claim_Payment_Amount) as Total_Cost,
	Round(AVG(Claim_Payment_Amount)) as Average_Cost,
	sum(Claim_Payment_Amount) * 100 / SUM(SUM(Claim_Payment_Amount)) OVER() as Percentage_Cost
FROM Claims_Table
GROUP BY Claim_Type;

-- ----------------------------------------------------------------------
-- Query 02: Trend_By_Year
-- ----------------------------------------------------------------------
SELECT 
	strftime('%Y', Claim_Start_Date) as Year,
	sum(Claim_Payment_Amount) as Total_Cost,
	count(Claim_ID) as Total_Claims,
	round(avg(Claim_Payment_Amount)) as Average_Cost
FROM Claims_Table
GROUP BY Year;

-- ----------------------------------------------------------------------
-- Query 03: Top_Beneficiaries_Cost
-- ----------------------------------------------------------------------
SELECT 
	b.Beneficiary_ID, 
	count(c.Claim_ID) as total_Claims,
	sum(c.Claim_Payment_Amount) as total_Cost,
	round(avg(c.Claim_Payment_Amount)) as average_Cost,
	b.Age_Group,
	b.Chronic_Condition_Count
FROM Beneficiary_Table b
JOIN Claims_Table c
ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID
GROUP BY b.Beneficiary_Year_ID
ORDER BY total_Cost DESC
limit 20;

-- ----------------------------------------------------------------------
-- Query 04: TotalCost_Vs_TopBeneficiariesCost*
-- ----------------------------------------------------------------------
--The top 20 beneficiaries cost is less than 1% of the total cost

WITH Top_20 as(SELECT 
	b.Beneficiary_ID, 
	count(c.Claim_ID) as total_Claims,
	sum(c.Claim_Payment_Amount) as total_Cost,
	round(avg(c.Claim_Payment_Amount),2) as average_Cost,
	b.Age_Group,
	b.Chronic_Condition_Count
FROM Beneficiary_Table b
JOIN Claims_Table c
ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID
GROUP BY b.Beneficiary_Year_ID
ORDER BY total_Cost DESC
limit 20)

SELECT 
	sum(total_Cost) as Top_20_Cost,
	(SELECT sum(Claim_Payment_Amount) FROM Claims_Table) as Total_Cost, 
	round(sum(total_Cost) * 100 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Top_20_Percentage
From Top_20;

-- ----------------------------------------------------------------------
-- Query 05: Top_Providers_Cost
-- ----------------------------------------------------------------------
SELECT 
	Provider_ID,
	sum(Claim_Payment_Amount) as total_cost,
	count(Claim_ID) as total_Claims,
	round(avg(Claim_Payment_Amount)) as average_Cost
FROM Claims_Table
GROUP by Provider_ID
ORDER BY total_Cost DESC
limit 20;

-- ----------------------------------------------------------------------
-- Query 06: Concentration_Claims_Cost
-- ----------------------------------------------------------------------
SELECT
    CASE
        WHEN Claim_Payment_Amount < 1000 THEN '< $1K'
        WHEN Claim_Payment_Amount < 5000 THEN '$1K - $5K'
        WHEN Claim_Payment_Amount < 10000 THEN '$5K - $10K'
        WHEN Claim_Payment_Amount < 50000 THEN '$10K - $50K'
        ELSE '$50K+'
    END AS cost_range,
    COUNT(*) AS claim_count,
    SUM(Claim_Payment_Amount) AS total_cost,
	SUM(Claim_Payment_Amount) * 100 / SUM(SUM(Claim_Payment_Amount)) OVER() as percent,
	count(*) * 100 / sum(count(*)) over() as represents
FROM Claims_Table
GROUP BY cost_range
ORDER BY total_cost DESC;

-- ----------------------------------------------------------------------
-- Query 07: Concentration_Beneficiary_Cost
-- ----------------------------------------------------------------------
WITH beneficiary_cost AS (
    SELECT
        Beneficiary_ID,
        SUM(Claim_Payment_Amount) AS total_cost
    FROM Claims_Table
	GROUP BY Beneficiary_ID
),

ranked_beneficiaries AS (
    SELECT
        Beneficiary_ID,
        total_cost,
        ROW_NUMBER() OVER (ORDER BY total_cost DESC) AS ranking,
		COUNT(*) OVER () AS total_beneficiaries
    FROM beneficiary_cost
)

SELECT
    SUM(total_cost) AS cost_top_10_percent,
    round(SUM(total_cost) * 100.0 / (SELECT SUM(total_cost) FROM beneficiary_cost)) AS percent_of_total_cost
FROM ranked_beneficiaries
WHERE ranking <= total_beneficiaries * 0.1;
