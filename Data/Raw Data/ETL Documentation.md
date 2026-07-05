\# Medicare Cost \& Utilization Project  

\## ETL Documentation \& Data Cleaning Log



\---



\# 1. Purpose of Data Cleaning



This document tracks all data cleaning, transformation, and feature engineering steps performed in \*\*Power Query\*\* across all datasets used in the Medicare Cost and Utilization Project, including:



\- Beneficiary Summary Files (2008–2010)  

\- Inpatient Claims  

\- Outpatient Claims  



\---



\# 2. Data Cleaning Standards Applied Across All Datasets



The following standards were consistently applied across all datasets:



\- Standardized column names for consistency across years  

\- Unified data types across all datasets  

\- Removal of duplicate records based on unique identifiers  

\- Creation of analytical features (age groups, risk flags, year)  

\- No records were deleted without documented justification  

\- All transformations were documented for auditability and reproducibility  



\---



\# 3. Beneficiary Data Cleaning



\## A. Data Ingestion



\- Imported Beneficiary Summary files for years 2008, 2009, and 2010 into Power Query  

\- No transformations were applied during the ingestion stage  



\---



\## B. Schema Standardization



Column names were standardized to ensure consistency across all datasets and enable append operations.



\### Column Renaming Mapping



| Original Name           | Renamed To                |

|-------------------------|---------------------------|

| DESYNPUF\_ID             | Beneficiary\_ID            |

| BENE\_BIRTH\_DT           | Birthdate                 |

| BENE\_DEATH\_DT           | Deathdate                 |

| BENE\_SEX\_IDENT\_CD       | Gender                    |

| BENE\_RACE\_CD            | Race                      |

| SP\_STATE\_CODE           | Beneficiary\_State\_CD      |

| BENE\_ESRD\_IND           | ESRD                      |

| SP\_ALZHDMTA             | Alzheimer\_Indicator       |

| SP\_CHF                  | CHF\_Indicator             |

| SP\_CHRNKIDN             | CKD\_Indicator             |

| SP\_CNCR                 | Cancer\_Indicator          |

| SP\_COPD                 | COPD\_Indicator            |

| SP\_DEPRESSN             | Depression\_Indicator      |

| SP\_DIABETES             | Diabetes\_Indicator        |

| SP\_ISCHMCHT             | IHD\_Indicator             |

| SP\_OSTEOPRS             | Osteoporosis\_Indicator    |

| SP\_RA\_OA                | Osteoarthritis\_Indicator  |

| SP\_STRKETIA             | TIA\_Indicator             |

| MEDREIMB\_IP             | Inpatient\_Reimbursement   |

| MEDREIMB\_OP             | Outpatient\_Reimbursement  |



\---



\## Value Mapping Transformations



All mappings were applied based on official CMS DE-SynPUF documentation.



\### Gender

\- 1 = Male  

\- 2 = Female  



\### Race

\- 1 = White  

\- 2 = Black  

\- 3 = Other  

\- 4 = Asian  

\- 5 = Hispanic  



\### Chronic Conditions

\- 0 = No condition  

\- 1 = Has condition  



\---



\## C. Data Integration



Beneficiary datasets from 2008, 2009, and 2010 were appended into a unified dataset:



\- Cleaned\_Beneficiaries\_All



A new column `Year` was added prior to append to preserve temporal context.



\---



\## D. Feature Engineering



The following features were created to support segmentation and cost/utilization analysis:



| Feature                | Description                                                  | Business Purpose                                 |

|------------------------|--------------------------------------------------------------|--------------------------------------------------|

| age\_group              | Groups beneficiaries into Medicare-relevant age bands        | Analyze cost/utilization by age segment          |

| chronic\_condition\_count| Counts total chronic conditions per beneficiary              | Measure disease burden intensity                 |

| high\_risk\_flag         | Flags beneficiaries meeting high-risk criteria               | Identify high-cost / high-utilization patients   |



\---



\## E. Data Quality Checks



This phase validates accuracy, consistency, and analytical readiness of the dataset.



\---



\### 1. Duplicate Records

\- No unexpected duplicates were identified using primary keys (Beneficiary\_ID, Claim\_ID where applicable)



\---



\### 2. Missing Values

\- No critical missing values were found in key analytical fields  

\- Non-critical nulls were retained when business-valid (e.g., Deathdate for living beneficiaries)



\---



\### 3. Data Types

\- All variables were validated and confirmed to have correct data types for SQL and Power BI usage  



\---



\### 4. Value Consistency

\- All categorical mappings were validated after transformation  

\- No inconsistencies detected across years  



\---



\### 5. Feature Validation

\- All engineered features (age\_group, chronic\_condition\_count, high\_risk\_flag) were validated against business rules and confirmed correct  



\---



\## Data Quality Issues Identified



\### 1. Data Issue: Negative Reimbursement Values



\- Negative values were identified in:

&#x20; - Inpatient\_Reimbursement  

&#x20; - Outpatient\_Reimbursement  



\*\*Treatment Applied:\*\*

\- Negative values were replaced with `0` to avoid distortion in cost and utilization metrics  

\- A data quality flag was created to track adjusted records for future traceability  



\---



\### 2. Outlier Issue: Age Calculation



\*\*Issue:\*\*

\- Initial age values exceeded plausible human limits due to incorrect calculation using current date instead of dataset observation year  



\*\*Resolution:\*\*

\- Age was recalculated using the corresponding dataset year (2008–2010)  

\- All implausible values were corrected  

\- No remaining unrealistic age values after adjustment  



\---



\# Final Assessment



After completing all transformations and data quality validations:



\- Dataset is consistent across all years  

\- All key analytical fields are standardized  

\- Feature engineering is validated  

\- Known data issues have been resolved or documented  



\## Conclusion



The Beneficiary dataset is \*\*approved and ready for SQL analysis and Power BI dashboard development\*\*.

