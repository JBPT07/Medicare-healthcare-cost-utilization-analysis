\# Data Profiling



This project uses CMS Medicare DE-SynPUF data to analyze beneficiary populations and chronic conditions driving healthcare cost and utilization



\## Purpose



The purpose of data profiling is to understand the structure, quality, and business meaning of each dataset before performing cleaning, analysis, and visualization.



\## What This Section Will Include



\- Dataset overview

\- Number of rows and columns

\- Column descriptions

\- Data types

\- Missing value checks

\- Duplicate checks

\- Primary key and foreign key candidates

\- Date field review

\- Cost field review

\- Chronic condition field review

\- Initial data quality observations



\## Datasets to Review



\- Beneficiary Summary files

\- Inpatient Claims files

\- Outpatient Claims files



\## Row Granularity



Each row represents one synthetic Medicare beneficiary for a specific year in the Beneficiary Summary files.



\## Primary Key Review



The main beneficiary identifier is DESYNPUF\_ID. This field should be unique within each Beneficiary Summary file. After appending the 2008, 2009, and 2010 files, the recommended unique key is a combination of DESYNPUF\_ID and year.



&#x20;

|File|Duplicate Primary Key Found Count|Rows Count|Column Count|
|-|-|-|-|
|Beneficiary 2008|No duplicates found|116353|32|
|Beneficiary 2009|No duplicates found|114539|32|
|Beneficiary 2010|No duplicates found|112755|32|



\## Key Column Groups



\### Identifiers columns



|Column|Description|Notes|
|-|-|-|
|DESYNPUF\_ID|Beneficiary ID|Used to join tables with claims|



\### Demographic Columns



|Column|Description|Notes|
|-|-|-|
|BENE\_BIRTH\_DT|Beneficiary birth date|To calculate age|
|BENE\_DEATH\_DT|Beneficiary death date||
|BENE\_SEX\_IDENT\_CD|Sex code|Needs mapping|
|BENE\_RACE\_CD|Race code|Needs mapping|
|SP\_STATE\_CODE|State code|Geographic segmentation / needs mapping|



\### Chronic Conditions columns

&#x09;

|Condition|Column|Values found|Notes|
|-|-|-|-|
|End-Stage Renal Disease|BENE\_ESRD\_IND|0, Y|Needs mapping|
|Alzheimer|SP\_ALZHDMTA|1, 2|Needs mapping|
|Chronic Condition Heart Failure|SP\_CHF|1, 2|Needs mapping|
|Chronic Kidney|SP\_CHRNKIDN|1, 2|Needs mapping|
|Cancer|SP\_CNCR|1, 2|Needs mapping|
|Chronic Obstructive Pulmonary Disease|SP\_COPD|1, 2|Needs mapping|
|Depression|SP\_DEPRESSN|1, 2|Needs mapping|
|Diabetes|SP\_DIABETES|1, 2|Needs mapping|
|Ischemic Heart Disease|SP\_ISCHMCHT|1, 2|Needs mapping|
|Osteoporosis|SP\_OSTEOPRS|1, 2|Needs mapping|
|Rheumatoid Arthritis and Osteoarthritis|SP\_RA\_OA|1, 2|Needs mapping|
|Stroke/Transient Ischemic Attack|SP\_STRKETIA|1, 2|Needs mapping|



\### Cost Columns



|Column|Description|Notes|
|-|-|-|
|MEDREIMB\_IP|Annual Medicare inpatient reimbursement|Inpatient cost per year per beneficiary|
|BENRES\_IP|Inpatient Annual Beneficiary Responsibility Amount|Not relevant for this project|
|PPPYMT\_IP|Inpatient Annual Primary Payer Reimbursement Amount|Not relevant for this project|
|MEDREIMB\_OP|Annual Medicare outpatient reimbursement|Outpatient cost per year per member|
|BENRES\_OP|Outpatient Annual Beneficiary Responsibility Amount|Not relevant for this project|
|PPPYMT\_OP|Outpatient Annual Primary Payer Reimbursement Amount|Not relevant for this project|
|MEDREIMB\_CAR|Annual Medicare reimbursement for carrier|Professional claims cost per year per beneficiary|
|BENRES\_CAR|Carrier annual beneficiary responsibility|Not relevant for this project|
|PPPYMT\_CAR|Primary Payer Payment for Carrier Claims|Not relevant for this project|



\### Missing values review



No missing or blank values were identified in the key beneficiary columns reviewed. Because no missing values were found in the key beneficiary fields, the dataset appears suitable for demographic segmentation, chronic condition analysis, and cost/utilization analysis. This supports the project goal of identifying which Medicare beneficiary populations and chronic conditions are associated with the highest healthcare cost and utilization.



\### Data Type Review.



During the data profiling process, key columns were reviewed to confirm whether their data type are appropriate for analysis. Correct data types are important because they affect joins, calculations, filtering, data analysis, cost aggregation, and chronic condition segmentation.



|Table|Column|Current type|Expected Type|Action needed|
|-|-|-|-|-|
|Beneficiary Summary 2008, 2009, 2010|DESYNPUF\_ID|Text|Text|Keep as text|
|Beneficiary Summary 2008, 2009, 2010|BENE\_BIRTH\_DT|Text|Date|Convert to date|
|Beneficiary Summary 2008, 2009, 2010|BENE\_DEATH\_DT|Text|Date|Convert to date|
|Beneficiary Summary 2008, 2009, 2010|BENE\_SEX\_IDENT\_CD|Text|Text|Map code to gender label|
|Beneficiary Summary 2008, 2009, 2010|SP\_STATE\_CODE|Text|Text|Keep as text / Map|
|Beneficiary Summary 2008, 2009, 2010|BENE\_COUNTY\_CD|Text|Text|Column will not be used|
|Beneficiary Summary 2008, 2009, 2010|CLM cost fields|Text|Decimal number|Convert to numeric|
|Beneficiary Summary 2008, 2009, 2010|Chronic conditions field|Text|Text|Map to Yes/No|
|Beneficiary Summary 2008, 2009, 2010|Total month coverage fields|Text|Text|Column will not be used|





\## Profiling notes



The Beneficiary Summary files provide the core population-level information for this project. These tables will be used to segment beneficiaries by age group, gender, race, state, and chronic condition status.



Medicare reimbursement fields, such as MEDREIMB\_IP, MEDREIMB\_OP, and MEDREIMB\_CAR, were identified as the primary cost fields for this analysis. These fields will be used to evaluate payer cost across beneficiary populations and chronic condition groups.



Beneficiary responsibility fields, such as BENRES\_IP, BENRES\_OP, and BENRES\_CAR, were identified as patient responsibility amounts. These fields represent the beneficiary’s out-of-pocket responsibility rather than Medicare reimbursement. Because this project focuses on payer cost, utilization, and chronic condition cost drivers, these fields will not be used as primary cost metrics. They may be considered for a future analysis focused on patient financial burden.



Chronic condition fields, such as SP\_DIABETES, SP\_CHF, SP\_COPD, and SP\_CHRNKIDN, were identified as key segmentation variables. These fields will be used to compare cost and utilization patterns across beneficiaries with different chronic conditions and to identify higher-risk beneficiary populations.



At this stage, the profiling review only covers the Beneficiary Summary files. Inpatient and Outpatient Claims files still need to be profiled to validate claim-level cost, utilization, provider identifiers, service dates, and diagnosis/procedure fields.



\## Cleaning actions needed



\### Beneficiary summary files



\- Add year column to each file.

\- Append 2008, 2009, and 2010 beneficiary files.

\- Convert date fields to Date type.

\- Convert reimbursement fields to numeric type.

\- Map sex and race codes into readable labels.

\- Map chronic condition fields where 1 = Yes and 2 = No. 

\- Map BENE\_ESRD\_IND where Y = Yes and 0 = No.

\- Create chronic condition count.

\- Create multiple chronic conditions flag.



\## Status



In progress.

