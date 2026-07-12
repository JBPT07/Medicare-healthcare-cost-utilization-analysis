# ETL Documentation & Data Cleaning Log

---

# 1. Purpose

This document records all data cleaning, transformation, integration, and feature engineering steps performed in **Power Query** across the datasets used in the Medicare Cost and Utilization Project.

The documented datasets include:

- Beneficiary Summary Files (2008–2010)
- Inpatient Claims Files
- Outpatient Claims Files

---

# 2. Data Cleaning Standards

The following standards were consistently applied throughout the ETL process:

- Standardized column names across all datasets
- Unified data types to ensure consistency
- Removed duplicate records only when justified
- Created analytical features required for downstream analysis
- Preserved all valid business records
- Documented every transformation to ensure reproducibility and auditability

---

# 3. Beneficiary Data Cleaning

## A. Data Ingestion

- Imported the Beneficiary Summary files for 2008, 2009, and 2010 into Power Query.
- No transformations were applied during the ingestion stage.

---

## B. Schema Standardization

Column names were standardized to improve readability, maintain consistency across years, and simplify downstream analysis.

### Column Renaming Mapping

| Original Name | Renamed To |
|---------------|------------|
| DESYNPUF_ID | Beneficiary_ID |
| BENE_BIRTH_DT | Birthdate |
| BENE_DEATH_DT | Deathdate |
| BENE_SEX_IDENT_CD | Gender |
| BENE_RACE_CD | Race |
| SP_STATE_CODE | Beneficiary_State_CD |
| BENE_ESRD_IND | ESRD |
| SP_ALZHDMTA | Alzheimer_Indicator |
| SP_CHF | CHF_Indicator |
| SP_CHRNKIDN | CKD_Indicator |
| SP_CNCR | Cancer_Indicator |
| SP_COPD | COPD_Indicator |
| SP_DEPRESSN | Depression_Indicator |
| SP_DIABETES | Diabetes_Indicator |
| SP_ISCHMCHT | IHD_Indicator |
| SP_OSTEOPRS | Osteoporosis_Indicator |
| SP_RA_OA | Osteoarthritis_Indicator |
| SP_STRKETIA | TIA_Indicator |
| MEDREIMB_IP | Inpatient_Reimbursement |
| MEDREIMB_OP | Outpatient_Reimbursement |

---

## Value Mapping

All value mappings were performed according to the official CMS DE-SynPUF documentation.

### Gender

- 1 → Male
- 2 → Female

### Race

- 1 → White
- 2 → Black
- 3 → Other
- 4 → Asian
- 5 → Hispanic

### Chronic Conditions

All chronic condition indicators were converted into binary values:

- 0 → No
- 1 → Yes

---

## C. Data Integration

The Beneficiary Summary datasets for 2008, 2009, and 2010 were appended into a single consolidated table.

**Output table**

- `beneficiaries_clean`

A new column named `Beneficiary_Year` was created before the append operation to preserve the reporting year of each record.

---

## D. Feature Engineering

The following analytical features were created to support cost and utilization analysis.

| Feature | Description | Business Purpose |
|---------|-------------|------------------|
| age_group | Groups beneficiaries into Medicare-relevant age categories | Analyze cost and utilization by age segment |
| chronic_condition_count | Counts the number of chronic conditions per beneficiary | Measure disease burden |
| high_risk_flag | Flags beneficiaries meeting predefined high-risk criteria | Identify potentially high-cost beneficiaries |

---

## E. Data Quality Checks

The following validation procedures were performed to ensure data quality and analytical readiness.

### 1. Duplicate Records

- No unexpected duplicate beneficiaries were identified.
- The composite key (`Beneficiary_ID` + `Beneficiary_Year`) was validated after the append operation.

---

### 2. Missing Values

- No critical missing values were identified in the key analytical fields.
- Business-valid null values (for example, `Deathdate` for living beneficiaries) were retained.

---

### 3. Data Types

- Date fields were converted to the Date data type.
- Numeric reimbursement fields were converted to Decimal Number.
- Identifier fields were retained as Text.

---

### 4. Value Consistency

- All categorical mappings were validated after transformation.
- No inconsistencies were identified across the three reporting years.

---

### 5. Feature Validation

All engineered features were validated against the expected business rules.

The following features were successfully verified:

- `age_group`
- `chronic_condition_count`
- `high_risk_flag`

---

## Data Quality Issues Identified

### 1. Negative Reimbursement Values

Negative reimbursement amounts were identified in the following fields:

- `Inpatient_Reimbursement`
- `Outpatient_Reimbursement`

**Treatment Applied**

- Negative reimbursement values were replaced with `0` to prevent distortion of beneficiary-level reimbursement metrics.
- A data quality flag was created to identify all adjusted records.

---

### 2. Age Calculation

**Issue**

Initial age calculations produced implausible values because age was calculated using the current date instead of the dataset observation year.

**Resolution**

- Age was recalculated using the corresponding reporting year (2008–2010).
- All unrealistic values were corrected.
- No implausible ages remained after validation.

---

## Final Assessment

After completing all transformations and validation procedures:

- Data is consistent across all reporting years.
- Analytical fields are standardized.
- Feature engineering has been validated.
- Known data quality issues have been resolved or documented.

---

## Conclusion

The Beneficiary dataset is approved and ready for SQL analysis and Power BI dashboard development.

---

# 4. Claims Data Cleaning

## A. Data Ingestion

- Imported the Inpatient and Outpatient Claims files for 2008–2010 into Power Query.
- No transformations were applied during the ingestion stage.

---

## B. Schema Standardization

The following schema transformations were applied:

- Standardized column names.
- Converted date fields to the Date data type.
- Converted payment fields to the Decimal Number data type.

### Column Renaming Mapping

| Original Name | Renamed To |
|---------------|------------|
| DESYNPUF_ID | Beneficiary_ID |
| CLM_ID | Claim_ID |
| PRVDR_NUM | Provider_ID |
| CLM_FROM_DT | Claim_Start_Date |
| CLM_THRU_DT | Claim_End_Date |
| CLM_ADMSN_DT | Admission_Date |
| NCH_BENE_DSCHRG_DT | Discharge_Date |
| CLM_PMT_AMT | Claim_Payment_Amount |

---

## C. Data Integration

The cleaned Inpatient and Outpatient Claims datasets were appended into a single consolidated table.

**Output table**

- `claims_all_clean`

Before the append operation:

- A `Claim_Year` column was created to preserve the reporting year.
- A `Claim_Type` column was added to distinguish Inpatient and Outpatient claims.

Because outpatient claims do not contain admission or discharge information, the `Admission_Date` and `Discharge_Date` fields remain null for outpatient records.

---

## D. Feature Engineering

No additional engineered features were created during the claims cleaning phase.

The existing claim-level variables provide sufficient information for the planned SQL analysis. Additional analytical metrics, such as high-cost claims and utilization categories, will be derived during the analysis stage.

---

## E. Data Quality Checks

### 1. Duplicate Records

Duplicate `Claim_ID` values were identified during data profiling.

Only exact duplicate records were removed. Duplicate Claim IDs representing legitimate claim structures were retained for further analysis.

---

### 2. Missing Values

- Claims with missing `Claim_Start_Date` values were removed because a valid service date is required for time-based analysis.
- No other critical missing values were identified.

---

### 3. Data Types

- Date fields were converted to the Date data type.
- Payment fields were converted to the Decimal Number data type.
- Identifier fields were retained as Text.

---

## Data Quality Issues Identified

### 1. Negative Claim Payment Amounts

Approximately **2.6%** of claims contained negative payment amounts.

These records were retained because negative payment amounts in healthcare claims may represent legitimate financial transactions, including:

- Claim adjustments
- Payment reversals
- Payment recoveries
- Other accounting corrections

No records were removed solely because of negative payment values.

---

### 2. High Claim Payment Concentration

The maximum observed claim payment amount was approximately **$57,000**.

A noticeable concentration of claims shared this maximum payment amount. Because the dataset is based on CMS DE-SynPUF synthetic data, these observations were retained, as they are likely a characteristic of the synthetic data generation process rather than a data quality issue.

---

## Final Assessment

After completing all cleaning, integration, and validation procedures:

- Data types are standardized across all claims datasets.
- Required analytical fields have been validated.
- Legitimate business records have been preserved.
- Known data quality issues have been documented.
- The consolidated claims dataset is ready for SQL analysis and Power BI dashboard development.

---

## Conclusion

The Claims dataset is approved and ready for SQL analysis and Power BI dashboard development.
