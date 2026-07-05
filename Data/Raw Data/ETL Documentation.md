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
- Removal of non-analytical columns to reduce dataset complexity and improve performance  
- Removal of non-cost-related fields not contributing to insurance expenditure analysis  
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

| Original Name            | Renamed To                  |
|-------------------------|----------------------------|
| DESYNPUF_ID             | Beneficiary_ID            |
| BENE_BIRTH_DT           | Birthdate                 |
| BENE_DEATH_DT           | Deathdate                 |
| BENE_SEX_IDENT_CD       | Gender                    |
| BENE_RACE_CD            | Race                      |
| SP_STATE_CODE           | Beneficiary_State_CD     |
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

## Column Selection (Feature Reduction)

During the data cleaning phase, several columns were removed based on data profiling results and business requirements.

The objective was to reduce noise, improve performance, and focus only on variables relevant to healthcare cost and utilization analysis.

### Columns Removed (Not Used in Analysis)

#### Physician-Level Identifiers (Excluded)
- AT_PHYSN_NPI  
- OP_PHYSN_NPI  
- OT_PHYSN_NPI  

These fields were excluded because physician-level attribution is outside the scope of this analysis.

---

### Cost Scope Filtering (Insurance Expenditure Focus)

In addition to non-analytical fields, any columns that did not represent **insurance cost or healthcare expenditure** were excluded from the analytical model.

This ensures that the dataset is strictly aligned with the project objective:  
**analysis of Medicare cost and utilization patterns.**

#### Fields excluded due to non-cost relevance:
- Administrative or reference-only identifiers not linked to billing
- Redundant metadata fields with no monetary or utilization impact
- Non-financial indicators outside reimbursement or claim payment structure

---

### Rationale for Removal

- Not used in joins or relational modeling  
- Not required for KPIs (cost per patient, utilization, reimbursement analysis)  
- Outside scope of insurance expenditure analysis  
- Improved performance in SQL and Power BI models  
- Reduced model complexity and memory usage  

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

| Feature                  | Description                                           | Business Purpose                          |
|-------------------------|-------------------------------------------------------|------------------------------------------|
| age_group              | Age segmentation of beneficiaries                     | Cost and utilization analysis            |
| chronic_condition_count| Number of chronic conditions per beneficiary          | Measure disease burden                   |
| high_risk_flag         | High-risk population indicator                        | Identify high-cost beneficiaries        |

---

## E. Data Quality Checks

---

### 1. Duplicate Records
- No unexpected duplicates found using primary identifiers  

---

### 2. Missing Values
- No critical missing values identified  
- Non-critical nulls retained where appropriate  

---

### 3. Data Types
- All fields validated for SQL and Power BI compatibility  

---

### 4. Value Consistency
- All categorical mappings validated after transformation  

---

### 5. Feature Validation
- All engineered features validated against business rules  

---

## Data Quality Issues Identified

---

### 1. Negative Reimbursement Values

**Issue:**
- Negative values found in:
  - Inpatient_Reimbursement  
  - Outpatient_Reimbursement  

**Resolution:**
- Negative values were replaced with 0  
- A data quality flag was created for traceability  

---

### 2. Age Outliers

**Issue:**
- Unrealistic age values due to incorrect calculation using current date  

**Resolution:**
- Age recalculated using dataset observation year (2008–2010)  
- All outliers corrected  

---

## Final Assessment

After completing cleaning and validation:

- Dataset is consistent across all years  
- Schema is standardized  
- Feature engineering is validated  
- Cost scope filtering is applied  
- Known data issues documented and resolved  

### Conclusion

The Beneficiary dataset is approved and ready for SQL analysis and Power BI dashboard development.
