-- 06 Multimorbidity Analysis
-- CMS Medicare DE-SynPUF | SQLite dialect
-- Run queries individually in DB Browser for SQLite or another SQLite client.

-- ----------------------------------------------------------------------
-- Query 01: Multimorbidity
-- ----------------------------------------------------------------------
SELECT 

	b.Chronic_Condition_Count,

	sum(c.Claim_Payment_Amount) as total_cost,

	count(c.Claim_ID) as total_claims,

	count(DISTINCT b.Beneficiary_Year_ID) as total_beneficiaries,

	round(count(c.Claim_ID) * 1.0 / count(DISTINCT b.Beneficiary_Year_ID),2) as claims_per_Beneficiary,

	round(sum(c.Claim_Payment_Amount) * 1.0 / count(c.Claim_ID),2) as cost_per_claim

FROM Beneficiary_Table b

JOIN Claims_Table c

	ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

GROUP BY Chronic_Condition_Count;
