# **RICD SQLite Code for Clinical Analysis**

## **Overview**

This repository contains SQL scripts used for the analysis of the **Russian Intensive Care Dataset (RICD v.2.0)** developed by the **Federal Research and Clinical Center of Intensive Care and Rehabilitology**. The RICD dataset includes anonymized medical data of all patients treated at the center from **December 2017 to September 2024**. The dataset encompasses various medical and anthropometric information, patient movement data, diagnoses, therapy details, laboratory results, scale scores, vital signs, and hospitalization outcomes.

## **Dataset Description**

The **RICD** dataset consists of comprehensive clinical records from patients treated in the **Federal Research and Clinical Center of Intensive Care and Rehabilitology**. Key components of the dataset include:

- **Medical and anthropometric data**
- **Patient movement within the institution**
- **Clinical diagnoses**
- **Therapeutic interventions**
- **Laboratory results**
- **Scores on clinical scales (e.g., APACHE II, NUTRIC)**
- **Vital monitored parameters over time**
- **Hospitalization outcomes (discharge status, mortality, etc.)**

For more information about the RICD dataset, please visit: [https://fnkcrr-database.ru/](https://fnkcrr-database.ru/)

## **Purpose of the SQL Code**

The provided SQLite code performs several key functions for analyzing and processing clinical data from the RICD dataset:

1. **Processed Data Table** (`processed_data`):  
   This table is created to assess key clinical parameters at the time of patient admission, including:
   - **Comorbidities**
   - **Clinical scales** (e.g., APACHE II, NUTRIC)
   - **Laboratory parameters** at admission
   - **Ventilator requirements**
   - **Readmissions** to the ICU
   - **Vasopressor/ionotropic support needs**

2. **Dynamic Data Table** (`ricd_dynamic`):  
   This table represents a total of **252,836 patient-days**. It evaluates the following clinical parameters:
   - **SIRS criteria** (including individual components) on a daily basis during hospitalization
   - **Sepsis-3 criteria** on a daily basis, including:
     - Use of **antibiotic therapy**
     - Presence of **positive cultures**
     - **SOFA score** dynamics
     - Episodes of **sepsis** and **septic shock**

3. **Additional Clinical Metrics**:
   - **AKI (Acute Kidney Injury)** assessed using **KDIGO criteria** on a daily basis
   - Daily evaluation of **APACHE II** and **NUTRIC** scores, when applicable

## **How to Use**

1. **Download the SQLite database** and ensure it is accessible in your environment.
2. **Execute the provided SQL scripts** in your SQLite database tool (e.g., DB Browser for SQLite, SQLite3 CLI, etc.).
3. **Verify the creation of the tables** (`processed_data`, `ricd_dynamic`) after running the scripts.
4. The data from these tables can be used for further clinical analysis, such as cohort identification, risk stratification, or mortality prediction.

## **License**

This code is provided as-is for research and academic purposes. The use of the RICD dataset is governed by its respective terms and conditions. Please ensure proper citation and permission from the **Federal Research and Clinical Center of Intensive Care and Rehabilitology** when using the dataset.
