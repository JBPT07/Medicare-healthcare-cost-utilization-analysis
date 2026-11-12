-- 04 Population Analysis
-- CMS Medicare DE-SynPUF | SQLite dialect
-- Run queries individually in DB Browser for SQLite or another SQLite client.

-- ----------------------------------------------------------------------
-- Query 01: Age Distribution*
-- ----------------------------------------------------------------------
SELECT 

	Age_Group,

	count(DISTINCT b.Beneficiary_ID) as total_Beneficiaries,

	round(count(DISTINCT b.Beneficiary_ID) * 100.0 / (SELECT COUNT(DISTINCT Beneficiary_ID) FROM Beneficiary_Table),2) as percent_Population,

	count(c.Claim_ID) as total_Claims, 

	sum(c.Claim_Payment_Amount) as Total_Cost,

	round(sum(Claim_Payment_Amount) * 100.0 / sum(sum(c.Claim_Payment_Amount)) over(),2) as cost_Percent

FROM Beneficiary_Table b

LEFT join Claims_Table c

	on c.Beneficiary_Year_ID = b.Beneficiary_Year_ID

GROUP BY Age_Group;

-- ----------------------------------------------------------------------
-- Query 02: Gender Distribution*
-- ----------------------------------------------------------------------
SELECT 

	Gender,

	count(DISTINCT b.Beneficiary_ID) as total_Beneficiaries,

	round(count(DISTINCT b.Beneficiary_ID) * 100.0 / (SELECT COUNT(DISTINCT Beneficiary_ID) FROM Beneficiary_Table),2) as percent_Population,

	count(c.Claim_ID) as total_Claims, 

	sum(c.Claim_Payment_Amount) as Total_Cost,

	round(sum(Claim_Payment_Amount) * 100.0 / sum(sum(c.Claim_Payment_Amount)) over(),2) as cost_Percent

FROM Beneficiary_Table b

LEFT join Claims_Table c

	on c.Beneficiary_Year_ID = b.Beneficiary_Year_ID

GROUP BY Gender;

-- ----------------------------------------------------------------------
-- Query 03: Race Distribution*
-- ----------------------------------------------------------------------
SELECT 

	Race,

	count(DISTINCT b.Beneficiary_ID) as total_Beneficiaries,

	round(count(DISTINCT b.Beneficiary_ID) * 100.0 / (SELECT COUNT(DISTINCT Beneficiary_ID) FROM Beneficiary_Table),2) as percent_Population,

	count(c.Claim_ID) as total_Claims, 

	sum(c.Claim_Payment_Amount) as Total_Cost,

	round(sum(Claim_Payment_Amount) * 100.0 / sum(sum(c.Claim_Payment_Amount)) over(),2) as cost_Percent

FROM Beneficiary_Table b

LEFT join Claims_Table c

	on c.Beneficiary_Year_ID = b.Beneficiary_Year_ID

GROUP BY Race;
