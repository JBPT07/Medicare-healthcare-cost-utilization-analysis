-- 05 Chronic Condition Analysis
-- CMS Medicare DE-SynPUF | SQLite dialect
-- Run queries individually in DB Browser for SQLite or another SQLite client.

-- ----------------------------------------------------------------------
-- Query 01: Chronic Condition Prevalence
-- ----------------------------------------------------------------------
WITH beneficiary_conditions AS (
    SELECT
        Beneficiary_ID,
        MAX(ESRD_Indicator) AS ESRD,
        MAX(Alzheimer_Indicator) AS Alzheimer,
        MAX(CHF_Indicator) AS CHF,
        MAX(CKD_Indicator) AS CKD,
        MAX(Cancer_Indicator) AS Cancer,
        MAX(COPD_Indicator) AS COPD,
        MAX(Depression_Indicator) AS Depression,
        MAX(Diabetes_Indicator) AS Diabetes,
        MAX(IHD_Indicator) AS IHD,
        MAX(Osteoporosis_Indicator) AS Osteoporosis,
        MAX(Osteoarthritis_Indicator) AS Osteoarthritis,
        MAX(TIA_Indicator) AS TIA
    FROM Beneficiary_Table
    GROUP BY Beneficiary_ID
),

condition_counts AS (
    SELECT 'ESRD' AS Chronic_Condition, SUM(ESRD) AS beneficiaries
    FROM beneficiary_conditions

	UNION ALL

    SELECT 'Alzheimer', SUM(Alzheimer)
    FROM beneficiary_conditions

    UNION ALL

    SELECT 'CHF', SUM(CHF)
    FROM beneficiary_conditions

    UNION ALL

    SELECT 'CKD', SUM(CKD)
    FROM beneficiary_conditions

    UNION ALL

    SELECT 'Cancer', SUM(Cancer)
    FROM beneficiary_conditions

    UNION ALL

    SELECT 'COPD', SUM(COPD)
    FROM beneficiary_conditions

    UNION ALL

    SELECT 'Depression', SUM(Depression)
    FROM beneficiary_conditions

    UNION ALL

    SELECT 'Diabetes', SUM(Diabetes)
    FROM beneficiary_conditions

    UNION ALL

    SELECT 'IHD', SUM(IHD)
    FROM beneficiary_conditions

    UNION ALL

    SELECT 'Osteoporosis', SUM(Osteoporosis)
    FROM beneficiary_conditions

    UNION ALL

    SELECT 'Osteoarthritis', SUM(Osteoarthritis)
    FROM beneficiary_conditions

    UNION ALL

    SELECT 'TIA', SUM(TIA)
    FROM beneficiary_conditions
)

SELECT
    Chronic_Condition,
    beneficiaries,
    ROUND(beneficiaries * 100.0 / (SELECT COUNT(*) FROM beneficiary_conditions),2) AS prevalence
FROM condition_counts
ORDER BY beneficiaries DESC;

-- ----------------------------------------------------------------------
-- Query 02: Utilization by Chronic Condition
-- ----------------------------------------------------------------------
WITH beneficiary_conditions AS (

    SELECT

        Beneficiary_ID,

        MAX(ESRD_Indicator) AS ESRD,

        MAX(Alzheimer_Indicator) AS Alzheimer,

        MAX(CHF_Indicator) AS CHF,

        MAX(CKD_Indicator) AS CKD,

        MAX(Cancer_Indicator) AS Cancer,

        MAX(COPD_Indicator) AS COPD,

        MAX(Depression_Indicator) AS Depression,

        MAX(Diabetes_Indicator) AS Diabetes,

        MAX(IHD_Indicator) AS IHD,

        MAX(Osteoporosis_Indicator) AS Osteoporosis,

        MAX(Osteoarthritis_Indicator) AS Osteoarthritis,

        MAX(TIA_Indicator) AS TIA

    FROM Beneficiary_Table

    GROUP BY Beneficiary_ID

)



SELECT

    'ESRD' AS Chronic_Condition,

    (SELECT SUM(ESRD) FROM beneficiary_conditions) AS Total_beneficiaries,

	SUM(Claim_Payment_Amount) as total_Cost,

	round(SUM(Claim_Payment_Amount) * 100.0 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Cost_Percent,

    COUNT(c.Claim_ID) AS total_claims,

	ROUND(COUNT(c.Claim_ID) * 1.0 / (SELECT SUM(ESRD) FROM beneficiary_conditions),2) as claims_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / (SELECT SUM(ESRD) FROM beneficiary_conditions),2) as cost_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / COUNT(c.Claim_ID),2) as cost_per_claim,

    ROUND(COUNT(c.Claim_ID) * 100.0 / (SELECT COUNT(*) FROM Claims_Table),2) AS Claims_Condition_percent

FROM Claims_Table c

JOIN Beneficiary_Table b

    ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

WHERE b.ESRD_Indicator = 1



UNION ALL



SELECT

    'Alzheimer',

    (SELECT SUM(Alzheimer) FROM beneficiary_conditions),

	SUM(Claim_Payment_Amount) as total_Cost,

	round(SUM(Claim_Payment_Amount) * 100.0 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Cost_Percent,

    COUNT(c.Claim_ID),

	ROUND(COUNT(c.Claim_ID) * 1.0 / (SELECT SUM(Alzheimer) FROM beneficiary_conditions),2) as claims_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / (SELECT SUM(Alzheimer) FROM beneficiary_conditions),2) as cost_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / COUNT(c.Claim_ID),2) as cost_per_claim,

    ROUND(

        COUNT(c.Claim_ID) * 100.0 /

        (SELECT COUNT(*) FROM Claims_Table),2)

FROM Claims_Table c

JOIN Beneficiary_Table b

    ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

WHERE b.Alzheimer_Indicator = 1



UNION ALL



SELECT

    'CHF',

    (SELECT SUM(CHF) FROM beneficiary_conditions),

	SUM(Claim_Payment_Amount) as total_Cost,

	round(SUM(Claim_Payment_Amount) * 100.0 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Cost_Percent,

    COUNT(c.Claim_ID),

	ROUND(COUNT(c.Claim_ID) * 1.0 / (SELECT SUM(CHF) FROM beneficiary_conditions),2) as claims_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / (SELECT SUM(CHF) FROM beneficiary_conditions),2) as cost_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / COUNT(c.Claim_ID),2) as cost_per_claim,

    ROUND(

        COUNT(c.Claim_ID) * 100.0 /

        (SELECT COUNT(*) FROM Claims_Table),2)

FROM Claims_Table c

JOIN Beneficiary_Table b

    ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

WHERE b.CHF_Indicator = 1



UNION ALL



SELECT

    'CKD',

    (SELECT SUM(CKD) FROM beneficiary_conditions),

	SUM(Claim_Payment_Amount) as total_Cost,

	round(SUM(Claim_Payment_Amount) * 100.0 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Cost_Percent,

    COUNT(c.Claim_ID),

	ROUND(COUNT(c.Claim_ID) * 1.0 / (SELECT SUM(CKD) FROM beneficiary_conditions),2) as claims_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / (SELECT SUM(CKD) FROM beneficiary_conditions),2) as cost_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / COUNT(c.Claim_ID),2) as cost_per_claim,

    ROUND(

        COUNT(c.Claim_ID) * 100.0 /

        (SELECT COUNT(*) FROM Claims_Table),

        2

    )

FROM Claims_Table c

JOIN Beneficiary_Table b

    ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

WHERE b.CKD_Indicator = 1



UNION ALL



SELECT

    'Cancer',

    (SELECT SUM(Cancer) FROM beneficiary_conditions),

	SUM(Claim_Payment_Amount) as total_Cost,

	round(SUM(Claim_Payment_Amount) * 100.0 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Cost_Percent,

    COUNT(c.Claim_ID),

	ROUND(COUNT(c.Claim_ID) * 1.0 / (SELECT SUM(Cancer) FROM beneficiary_conditions),2) as claims_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / (SELECT SUM(Cancer) FROM beneficiary_conditions),2) as cost_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / COUNT(c.Claim_ID),2) as cost_per_claim,

    ROUND(

        COUNT(c.Claim_ID) * 100.0 /

        (SELECT COUNT(*) FROM Claims_Table),

        2

    )

FROM Claims_Table c

JOIN Beneficiary_Table b

    ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

WHERE b.Cancer_Indicator = 1



UNION ALL



SELECT

    'COPD',

    (SELECT SUM(COPD) FROM beneficiary_conditions),

	SUM(Claim_Payment_Amount) as total_Cost,

	round(SUM(Claim_Payment_Amount) * 100.0 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Cost_Percent,

    COUNT(c.Claim_ID),

	ROUND(COUNT(c.Claim_ID) * 1.0 / (SELECT SUM(COPD) FROM beneficiary_conditions),2) as claims_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / (SELECT SUM(COPD) FROM beneficiary_conditions),2) as cost_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / COUNT(c.Claim_ID),2) as cost_per_claim,

    ROUND(

        COUNT(c.Claim_ID) * 100.0 /

        (SELECT COUNT(*) FROM Claims_Table),

        2

    )

FROM Claims_Table c

JOIN Beneficiary_Table b

    ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

WHERE b.COPD_Indicator = 1



UNION ALL



SELECT

    'Depression',

    (SELECT SUM(Depression) FROM beneficiary_conditions),

	SUM(Claim_Payment_Amount) as total_Cost,

	round(SUM(Claim_Payment_Amount) * 100.0 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Cost_Percent,

    COUNT(c.Claim_ID),

	ROUND(COUNT(c.Claim_ID) * 1.0 / (SELECT SUM(Depression) FROM beneficiary_conditions),2) as claims_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / (SELECT SUM(Depression) FROM beneficiary_conditions),2) as cost_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / COUNT(c.Claim_ID),2) as cost_per_claim,

    ROUND(

        COUNT(c.Claim_ID) * 100.0 /

        (SELECT COUNT(*) FROM Claims_Table),

        2

    )

FROM Claims_Table c

JOIN Beneficiary_Table b

    ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

WHERE b.Depression_Indicator = 1



UNION ALL



SELECT

    'Diabetes',

    (SELECT SUM(Diabetes) FROM beneficiary_conditions),

	SUM(Claim_Payment_Amount) as total_Cost,

	round(SUM(Claim_Payment_Amount) * 100.0 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Cost_Percent,

    COUNT(c.Claim_ID),

	ROUND(COUNT(c.Claim_ID) * 1.0 / (SELECT SUM(Diabetes) FROM beneficiary_conditions),2) as claims_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / (SELECT SUM(Diabetes) FROM beneficiary_conditions),2) as cost_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / COUNT(c.Claim_ID),2) as cost_per_claim,

    ROUND(

        COUNT(c.Claim_ID) * 100.0 /

        (SELECT COUNT(*) FROM Claims_Table),

        2

    )

FROM Claims_Table c

JOIN Beneficiary_Table b

    ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

WHERE b.Diabetes_Indicator = 1



UNION ALL



SELECT

    'IHD',

    (SELECT SUM(IHD) FROM beneficiary_conditions),

	SUM(Claim_Payment_Amount) as total_Cost,

	round(SUM(Claim_Payment_Amount) * 100.0 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Cost_Percent,

    COUNT(c.Claim_ID),

	ROUND(COUNT(c.Claim_ID) * 1.0 / (SELECT SUM(IHD) FROM beneficiary_conditions),2) as claims_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / (SELECT SUM(IHD) FROM beneficiary_conditions),2) as cost_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / COUNT(c.Claim_ID),2) as cost_per_claim,

    ROUND(

        COUNT(c.Claim_ID) * 100.0 /

        (SELECT COUNT(*) FROM Claims_Table),

        2

    )

FROM Claims_Table c

JOIN Beneficiary_Table b

    ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

WHERE b.IHD_Indicator = 1



UNION ALL



SELECT

    'Osteoporosis',

    (SELECT SUM(Osteoporosis) FROM beneficiary_conditions),

	SUM(Claim_Payment_Amount) as total_Cost,

	round(SUM(Claim_Payment_Amount) * 100.0 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Cost_Percent,

    COUNT(c.Claim_ID),

	ROUND(COUNT(c.Claim_ID) * 1.0 / (SELECT SUM(Osteoporosis) FROM beneficiary_conditions),2) as claims_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / (SELECT SUM(Osteoporosis) FROM beneficiary_conditions),2) as cost_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / COUNT(c.Claim_ID),2) as cost_per_claim,

    ROUND(

        COUNT(c.Claim_ID) * 100.0 /

        (SELECT COUNT(*) FROM Claims_Table),

        2

    )

FROM Claims_Table c

JOIN Beneficiary_Table b

    ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

WHERE b.Osteoporosis_Indicator = 1



UNION ALL



SELECT

    'Osteoarthritis',

    (SELECT SUM(Osteoarthritis) FROM beneficiary_conditions),

	SUM(Claim_Payment_Amount) as total_Cost,

	round(SUM(Claim_Payment_Amount) * 100.0 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Cost_Percent,

    COUNT(c.Claim_ID),

	ROUND(COUNT(c.Claim_ID) * 1.0 / (SELECT SUM(Osteoarthritis) FROM beneficiary_conditions),2) as claims_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / (SELECT SUM(Osteoarthritis) FROM beneficiary_conditions),2) as cost_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / COUNT(c.Claim_ID),2) as cost_per_claim,

    ROUND(

        COUNT(c.Claim_ID) * 100.0 /

        (SELECT COUNT(*) FROM Claims_Table),

        2

    )

FROM Claims_Table c

JOIN Beneficiary_Table b

    ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

WHERE b.Osteoarthritis_Indicator = 1



UNION ALL



SELECT

    'TIA',

    (SELECT SUM(TIA) FROM beneficiary_conditions),

	SUM(Claim_Payment_Amount) as total_Cost,

	round(SUM(Claim_Payment_Amount) * 100.0 / (SELECT sum(Claim_Payment_Amount) FROM Claims_Table),2) as Cost_Percent,

    COUNT(c.Claim_ID),

	ROUND(COUNT(c.Claim_ID) * 1.0 / (SELECT SUM(TIA) FROM beneficiary_conditions),2) as claims_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / (SELECT SUM(TIA) FROM beneficiary_conditions),2) as cost_per_beneficiary,

	ROUND(SUM(Claim_Payment_Amount) * 1.0 / COUNT(c.Claim_ID),2) as cost_per_claim,

    ROUND(

        COUNT(c.Claim_ID) * 100.0 /

        (SELECT COUNT(*) FROM Claims_Table),

        2

    )

FROM Claims_Table c

JOIN Beneficiary_Table b

    ON b.Beneficiary_Year_ID = c.Beneficiary_Year_ID

WHERE b.TIA_Indicator = 1



ORDER BY total_Cost DESC;
