-- 00 Data Quality Checks
-- CMS Medicare DE-SynPUF | SQLite dialect
-- Run queries individually in DB Browser for SQLite or another SQLite client.

-- ----------------------------------------------------------------------
-- Query 01: Claim_Count_Rows
-- ----------------------------------------------------------------------
SELECT Claim_Type, count(Claim_ID) as total_claims
FROM Claims_Table
GROUP BY Claim_Type;

-- ----------------------------------------------------------------------
-- Query 02: Beneficiary_Count_Rows
-- ----------------------------------------------------------------------
SELECT count(Beneficiary_ID) as total_Rows
FROM Beneficiary_Table;

-- ----------------------------------------------------------------------
-- Query 03: Beneficiary_Duplicates_Checks
-- ----------------------------------------------------------------------
SELECT Beneficiary_ID, count(Beneficiary_ID) as Total_Duplicates
FROM Beneficiary_Table
GROUP BY Beneficiary_Year_ID
HAVING Total_Duplicates > 1;

-- ----------------------------------------------------------------------
-- Query 04: Claim_Duplicates_Checks
-- ----------------------------------------------------------------------
SELECT Claim_ID, count(Claim_ID) as Total_Duplicates
FROM Claims_Table
GROUP BY Claim_ID
HAVING Total_Duplicates > 1;

-- ----------------------------------------------------------------------
-- Query 05: Claim_Null_Checks
-- ----------------------------------------------------------------------
SELECT Claim_ID
FROM Claims_Table
WHERE Claim_ID IS NULL;

-- ----------------------------------------------------------------------
-- Query 06: Beneficiary_Null_Check
-- ----------------------------------------------------------------------
SELECT Beneficiary_ID
FROM Beneficiary_Table
WHERE Beneficiary_ID IS NULL;

-- ----------------------------------------------------------------------
-- Query 07: Dates_Values_Checks
-- ----------------------------------------------------------------------
Select 
	MAX(Claim_Start_Date) as Latest_Date,
	MIN(Claim_Start_Date) as Earliest_Date
FROM Claims_Table;

-- ----------------------------------------------------------------------
-- Query 08: Beneficiary_W/O_Claims
-- ----------------------------------------------------------------------
SELECT c.Claim_ID, b.Beneficiary_ID
FROM Beneficiary_Table b
LEFT JOIN Claims_Table c
ON c.Beneficiary_ID = b.Beneficiary_ID
WHERE Claim_ID IS NULL
GROUP BY b.Beneficiary_ID;

-- ----------------------------------------------------------------------
-- Query 09: Claims_W/O_Beneficiaries
-- ----------------------------------------------------------------------
SELECT c.Claim_ID, b.Beneficiary_ID
FROM Claims_Table c
LEFT JOIN Beneficiary_Table b
ON b.Beneficiary_ID = c.Beneficiary_ID
WHERE b.Beneficiary_ID IS NULL;

-- ----------------------------------------------------------------------
-- Query 10: Negative_Payment_Amount*
-- ----------------------------------------------------------------------
SELECT 

	count(Claim_ID) as negative_claims,

	sum(Claim_Payment_Amount) as total_Negative_Amount,

	round(avg(Claim_Payment_Amount)) as avg_payment_Amount,

	min(Claim_Payment_Amount) as Most_Negative_Amount

FROM Claims_Table

WHERE Claim_Payment_Amount < 0;
