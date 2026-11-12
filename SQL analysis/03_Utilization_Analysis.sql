-- 03 Utilization Analysis
-- CMS Medicare DE-SynPUF | SQLite dialect
-- Run queries individually in DB Browser for SQLite or another SQLite client.

-- ----------------------------------------------------------------------
-- Query 01: Overall Healthcare utilization
-- ----------------------------------------------------------------------
SELECT
	count(*) as total_Claims,
	count(DISTINCT Beneficiary_ID) as total_Beneficiaries_with_Claims,
	round(count(*) * 1.0 / count(DISTINCT Beneficiary_ID), 2) as avg_Claims_per_beneficiary
FROM Claims_Table;

-- ----------------------------------------------------------------------
-- Query 02: Utilization by claim type
-- ----------------------------------------------------------------------
SELECT
	Claim_Type,
	count(*) as total_Claims,
	count(DISTINCT Beneficiary_ID) as total_Beneficiaries_with_Claims,
	round(count(*) * 1.0 / count(DISTINCT Beneficiary_ID), 2) as avg_Claims_per_beneficiary,
	round(count(*) * 100.0 / sum(count(*)) OVER (), 2) as Percent_of_utilization
FROM Claims_Table
GROUP BY Claim_Type;

-- ----------------------------------------------------------------------
-- Query 03: Trend by year
-- ----------------------------------------------------------------------
SELECT
	strftime("%Y",Claim_Start_Date) as claim_Year,
	count(*) as total_Claims,
	count(DISTINCT Beneficiary_ID) as total_Beneficiaries_with_Claims,
	round(count(*) * 1.0 / count(DISTINCT Beneficiary_ID), 2) as avg_Claims_per_beneficiary
FROM Claims_Table
GROUP BY claim_Year;

-- ----------------------------------------------------------------------
-- Query 04: Beneficiary Utilization Distribution
-- ----------------------------------------------------------------------
WITH Beneficiary_Utilization as (
	SELECT 
		Beneficiary_ID,
		count(*) AS total_claims
	FROM Claims_Table
	GROUP BY Beneficiary_ID
	ORDER BY total_claims DESC)
	
SELECT 
	total_claims,
	count(*) as Beneficiary_Per_TotalClaims
FROM Beneficiary_Utilization
GROUP BY total_claims
ORDER BY Beneficiary_Per_TotalClaims DESC;

-- ----------------------------------------------------------------------
-- Query 05: High-Utilization Beneficiaries*
-- ----------------------------------------------------------------------
WITH beneficiary_utilization AS (
    SELECT
        Beneficiary_ID,
        COUNT(*) AS total_claims
    FROM Claims_Table
    GROUP BY Beneficiary_ID
),

ranked_beneficiaries AS (
    SELECT
        Beneficiary_ID,
        total_claims,
        ROW_NUMBER() OVER (
            ORDER BY total_claims DESC
        ) AS beneficiary_rank
    FROM beneficiary_utilization
)

SELECT
    COUNT(*) AS top_10_percent_beneficiaries,
    SUM(total_claims) AS claims_generated_by_top_10_percent,
    ROUND(
        SUM(total_claims) * 100.0 /
        (SELECT COUNT(*) FROM Claims_Table),
        2
    ) AS percent_of_total_claims
FROM ranked_beneficiaries
WHERE beneficiary_rank <= (SELECT count(DISTINCT Beneficiary_ID) * 0.1  from Claims_Table);
