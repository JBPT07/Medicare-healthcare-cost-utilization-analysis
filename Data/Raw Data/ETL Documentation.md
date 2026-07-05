# Medicare Cost & Utilization Project  
## ETL Documentation & Data Cleaning Log

---

# 1. Purpose of Data Cleaning

This document tracks all data cleaning, transformation, and feature engineering steps performed in **Power Query** across all datasets used in the Medicare Cost and Utilization Project, including:

- Beneficiary Summary Files (2008–2010)  
- Inpatient Claims  
- Outpatient Claims  

---

# 2. Data Cleaning Standards Applied Across All Datasets

The following standards were consistently applied across all datasets:

- Standardized column names for consistency across years  
- Unified data types across all datasets  
- Removal of duplicate records based on unique identifiers  
- Creation of analytical features (age groups, risk flags, year)  
- No records were deleted without documented justification  
- All transformations were documented for auditability and reproducibility  

---

# 3. Beneficiary Data Cleaning

## A. Data Ingestion

- Imported Beneficiary Summary files for years 2008, 2009, and 2010 into Power Query  
- No transformations were applied during the ingestion stage  

---

## B. Schema Standardization

Column names were standardized to ensure consistency across all datasets and enable append operations.

### Column Renaming Mapping

| Original Name           | Renamed To                |
|-------------------------|---------------------------|
| DESYNPUF_ID             | Beneficiary_ID            |
| BENE_BIRTH_DT           | Birthdate                 |
| BENE_DEATH_DT           | Deathdate                 |
| BENE_SEX_IDENT_CD       | Gender                    |
| BENE_RACE_CD            | Race                      |
| SP_STATE_CODE           | Beneficiary_State_CD      |
| BENE_ESRD_IND           | ESRD                      |
| SP_ALZHDMTA             | Alzheimer_Indicator       |
| SP_CHF                  | CHF_Indicator             |
| SP_CHRNKIDN             | CKD_Indicator             |
| SP_CNCR                 | Cancer_Indicator          |
| SP_COPD                 | COPD_Indicator            |
| SP_DEPRESSN             | Depression_Indicator      |
| SP_DIABETES             | Diabetes_Indicator        |
| SP_ISCHMCHT             | IHD_Indicator             |
| SP_OSTEOPRS             | Osteoporosis_Indicator    |
| SP_RA_OA                | Osteoarthritis_Indicator  |
| SP_STRKETIA             | TIA_Indicator             |
| MEDREIMB_IP             | Inpatient_Reimbursement   |
| MEDREIMB_OP             | Outpatient_Reimbursement  |

---

## Value Mapping Transformations

All mappings were applied based on official CMS DE-SynPUF documentation.

### Gender
- 1 = Male  
- 2 = Female  

### Race
- 1 = White  
- 2 = Black  
- 3 = Other  
- 4 = Asian  
- 5 = Hispanic  

### Chronic Conditions
- 0 = No condition  
- 1 = Has condition  

---

## C. Data Integration

Beneficiary datasets from 2008, 2009, and 2010 were appended into a unified dataset:

- Cleaned_Beneficiaries_All

A new column `Year` was added prior to append to preserve temporal context.

---

## D. Feature Engineering

The following features were created to support segmentation and cost/utilization analysis:

| Feature                | Description                                                  | Business Purpose                                 |
|------------------------|--------------------------------------------------------------|--------------------------------------------------|
| age_group              | Groups beneficiaries into Medicare-relevant age bands        | Analyze cost/utilization by age segment          |
| chronic_condition_count| Counts total chronic conditions per beneficiary              | Measure disease burden intensity                 |
| high_risk_flag         | Flags beneficiaries meeting high-risk criteria               | Identify high-cost / high-utilization patients   |

---

## E. Data Quality Checks

This phase validates accuracy, consistency, and analytical readiness of the dataset.

---

### 1. Duplicate Records
- No unexpected duplicates were identified using primary keys (Beneficiary_ID, Claim_ID where applicable)

---

### 2. Missing Values
- No critical missing values were found in key analytical fields  
- Non-critical nulls were retained when business-valid (e.g., Deathdate for living beneficiaries)

---

### 3. Data Types
- All variables were validated and confirmed to have correct data types for SQL and Power BI usage  

---

### 4. Value Consistency
- All categorical mappings were validated after transformation  
- No inconsistencies detected across years  

---

### 5. Feature Validation
- All engineered features (age_group, chronic_condition_count, high_risk_flag) were validated against business rules and confirmed correct  

---

## Data Quality Issues Identified

### 1. Data Issue: Negative Reimbursement Values

- Negative values were identified in:
  - Inpatient_Reimbursement  
  - Outpatient_Reimbursement  

**Treatment Applied:**
- Negative values were replaced with `0` to avoid distortion in cost and utilization metrics  
- A data quality flag was created to track adjusted records for future traceability  

---

### 2. Outlier Issue: Age Calculation

**Issue:**
- Initial age values exceeded plausible human limits due to incorrect calculation using current date instead of dataset observation year  

**Resolution:**
- Age was recalculated using the corresponding dataset year (2008–2010)  
- All implausible values were corrected  
- No remaining unrealistic age values after adjustment  

---

# Final Assessment

After completing all transformations and data quality validations:

- Dataset is consistent across all years  
- All key analytical fields are standardized  
- Feature engineering is validated  
- Known data issues have been resolved or documented  

## Conclusion

The Beneficiary dataset is **approved and ready for SQL analysis and Power BI dashboard development**.
