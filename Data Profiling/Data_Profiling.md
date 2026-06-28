# Data Profiling

This project uses CMS Medicare DE-SynPUF data to analyze beneficiary populations and chronic conditions driving healthcare cost and utilization.

---

## Purpose

The purpose of data profiling is to understand the structure, quality, and business meaning of each dataset before performing cleaning, analysis, and visualization. No action was taken over the files during the data profiling.

---

## What This Section Will Include

* Dataset overview
* Number of rows and columns
* Column descriptions
* Data types
* Missing value checks
* Duplicate checks
* Primary key and foreign key candidates
* Date field review
* Cost field review
* Chronic condition field review
* Initial data quality observations

---

## Datasets to Review

* Beneficiary Summary files
* Inpatient Claims files
* Outpatient Claims files

---

## Row Granularity

Each row represents one synthetic Medicare beneficiary for a specific year in the Beneficiary Summary files.

In the inpatient and outpatient claims files, each row represents a claim record as provided by the synthetic CMS dataset.

Because repeated claim IDs were identified, additional validation is required to determine whether each row represents a unique claim, an exact duplicate, or another claim-level structure.

---

## Primary Key Review

The main beneficiary identifier is `DESYNPUF_ID`. This field should be unique within each Beneficiary Summary file. After appending the 2008, 2009, and 2010 files, the recommended unique key is a combination of `DESYNPUF_ID` and year.

`CLM_ID` is expected to identify individual claims. However, duplicated claim IDs were identified, indicating that further validation is required to determine whether these represent exact duplicates, multi-line claims, or another valid claim structure.

---

## Dataset Summary

| File                          | Repeated Key Values Found | Row Count | Column Count |
| ----------------------------- | ------------------------- | --------- | ------------ |
| Beneficiary summary 2008 file | No duplicates found       | 116353    | 32           |
| Beneficiary summary 2009 file | No duplicates found       | 114539    | 32           |
| Beneficiary summary 2010 file | No duplicates found       | 112755    | 32           |
| Inpatient Claims file         | 68 values found           | 66774     | 81           |
| Outpatient Claims file        | 10975 values found        | 790791    | 76           |

---

## Key Column Groups

### Identifiers Columns

| Table                                 | Column       | Description             | Notes                                                                 |
| ------------------------------------- | ------------ | ----------------------- | --------------------------------------------------------------------- |
| Beneficiary summary files             | DESYNPUF_ID  | Beneficiary ID          | Used to join beneficiary records with inpatient and outpatient claims |
| Inpatient and outpatient claims files | CLM_ID       | Claim ID                | Identifies a claim and supports claim counting and duplicate review   |
| Inpatient and outpatient claims files | PRVDR_NUM    | Provider Number         | Identifies facility where care was provided                           |
| Inpatient and outpatient claims files | AT_PHYSN_NPI | Attending Physician NPI | Main doctor in charge (not used in this project)                      |
| Inpatient and outpatient claims files | OP_PHYSN_NPI | Operating Physician NPI | Procedure-performing doctor (not used in this project)                |
| Inpatient and outpatient claims files | OT_PHYSN_NPI | Other Physician NPI     | Secondary consulting doctor (not used in this project)                |

---

### Demographic Columns

| Table               | Column            | Description | Notes                 |
| ------------------- | ----------------- | ----------- | --------------------- |
| Beneficiary Summary | BENE_BIRTH_DT     | Birth date  | Used to calculate age |
| Beneficiary Summary | BENE_DEATH_DT     | Death date  |                       |
| Beneficiary Summary | BENE_SEX_IDENT_CD | Sex code    | Needs mapping         |
| Beneficiary Summary | BENE_RACE_CD      | Race code   | Needs mapping         |
| Beneficiary Summary | SP_STATE_CODE     | State code  | Needs mapping         |

---

### Date Fields

| Table            | Column             | Description    | Notes                  |
| ---------------- | ------------------ | -------------- | ---------------------- |
| Inpatient claims | CLM_FROM_DT        | Start date     | Billing start date     |
| Inpatient claims | CLM_THRU_DT        | End date       | Billing end date       |
| Inpatient claims | CLM_ADMSN_DT       | Admission date | Admission tracking     |
| Inpatient claims | NCH_BENE_DSCHRG_DT | Discharge date | Patient discharge date |

---

### Chronic Conditions

| Condition                 | Column        | Values Found | Notes         |
| ------------------------- | ------------- | ------------ | ------------- |
| ESRD                      | BENE_ESRD_IND | 0, Y         | Needs mapping |
| Alzheimer                 | SP_ALZHDMTA   | 1, 2         | Needs mapping |
| Heart Failure             | SP_CHF        | 1, 2         | Needs mapping |
| Chronic Kidney            | SP_CHRNKIDN   | 1, 2         | Needs mapping |
| Cancer                    | SP_CNCR       | 1, 2         | Needs mapping |
| COPD                      | SP_COPD       | 1, 2         | Needs mapping |
| Depression                | SP_DEPRESSN   | 1, 2         | Needs mapping |
| Diabetes                  | SP_DIABETES   | 1, 2         | Needs mapping |
| Ischemic Heart Disease    | SP_ISCHMCHT   | 1, 2         | Needs mapping |
| Osteoporosis              | SP_OSTEOPRS   | 1, 2         | Needs mapping |
| Rheumatoid/Osteoarthritis | SP_RA_OA      | 1, 2         | Needs mapping |
| Stroke/TIA                | SP_STRKETIA   | 1, 2         | Needs mapping |

---

### Cost Fields

Beneficiary-level reimbursement fields:

* MEDREIMB_IP
* MEDREIMB_OP
* MEDREIMB_CAR

Claim-level payment field:

* CLM_PMT_AMT

These will be used for cost and utilization analysis. Patient responsibility fields will not be used in the core analysis.

---

## Missing Values Review

* Beneficiary Summary: no major missing values
* Claims: missing values found in some date fields

Missing values do not prevent cost analysis but may affect time-based metrics.

---

## Data Type Review

| Column Type          | Action             |
| -------------------- | ------------------ |
| Dates stored as text | Convert to date    |
| Cost fields          | Convert to numeric |
| IDs                  | Keep as text       |
| Chronic indicators   | Map to Yes/No      |

---

## Profiling Notes

* Beneficiary Summary is the core population dataset
* Chronic conditions will be used for segmentation
* Cost fields are primary drivers of analysis
* Physician-level fields are excluded from core analysis

---

## Cleaning Actions Needed

### Beneficiary Summary

* Add beneficiary_year column
* Append 2008–2010 datasets
* Map sex, race, and state codes
* Convert birth/death dates
* Create age and age groups
* Create chronic condition count
* Validate composite key (DESYNPUF_ID + year)

Expected table: `beneficiaries_clean`

---

### Inpatient Claims

* Validate duplicate CLM_ID values
* Remove only exact duplicates
* Convert date fields
* Create length of stay
* Create claim_year
* Exclude physician fields

Expected table: `inpatient_claims_clean`

---

### Outpatient Claims

* Validate duplicate CLM_ID values
* Remove only exact duplicates
* Convert date fields
* Create claim_year

Expected table: `outpatient_claims_clean`

---

### Combined Claims Table

* Append inpatient and outpatient tables
* Add claim_type field
* Validate row counts and totals
* Ensure consistent schema

Expected table: `claims_all_clean`

---

## Status

Data profiling completed. Power Query cleaning requirements documented.
