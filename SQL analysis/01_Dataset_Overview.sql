-- 01 Dataset Overview
-- CMS Medicare DE-SynPUF | SQLite dialect
-- Run queries individually in DB Browser for SQLite or another SQLite client.

-- ----------------------------------------------------------------------
-- Query 01: Total_Beneficiaries*
-- ----------------------------------------------------------------------
SELECT count(DISTINCT Beneficiary_ID) Total_beneficiaries

FROM Beneficiary_Table;

-- ----------------------------------------------------------------------
-- Query 02: Total_Claims/Providers*
-- ----------------------------------------------------------------------
SELECT

	count(Claim_ID) as Total_Claims,

	sum(Claim_Payment_Amount) as Total_Cost,

	round(avg(Claim_Payment_Amount)) as Average_Cost,

	count(DISTINCT Provider_ID) as Total_Providers

FROM Claims_Table;
