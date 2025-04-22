-- Создание таблицы processed_data
CREATE TABLE processed_data AS
SELECT 
    new_patient_id, 
    new_hosp_id, 
    visit_number, 
    sex, 
    body_weight, 
    height, 
    "BMI", 
    age, 
    transfer, 
    adm_year, 
    admission_department, 
    discharge_department, 
    hospital_length_of_stay, 
    icu_length_of_stay, 
    icu_free_days, 
    fatal_outcome
FROM all_patients;
-- Оценка коморбидности
ALTER TABLE processed_data ADD COLUMN "ischemic stroke" TEXT;
UPDATE processed_data
SET "ischemic stroke" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('I63.0', 'I63.2', 'I63.3', 'I63.4', 'I63.5', 'I63.8', 'I63.9', 'I69.3')
        AND post_admission_hours <= 48
        
        UNION
              
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%I63.0%' OR
            ICD_10 LIKE '%I63.2%' OR
            ICD_10 LIKE '%I63.3%' OR
            ICD_10 LIKE '%I63.4%' OR
            ICD_10 LIKE '%I63.5%' OR
            ICD_10 LIKE '%I63.8%' OR
            ICD_10 LIKE '%I63.9%' OR
            ICD_10 LIKE '%I69.3%'
        )
        AND post_admission_hours <= 48
    )
);
ALTER TABLE processed_data ADD COLUMN "hemorrhagic stroke" TEXT;
UPDATE processed_data
SET "hemorrhagic stroke" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('I61.0', 'I61.1', 'I61.2', 'I61.3', 'I61.4', 'I61.5', 'I61.6', 'I61.8', 'I61.9', 'I62.9', 'I69.1')
        AND post_admission_hours <= 48
        
        UNION
             
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%I61.0%' OR
            ICD_10 LIKE '%I61.1%' OR
            ICD_10 LIKE '%I61.2%' OR
            ICD_10 LIKE '%I61.3%' OR
            ICD_10 LIKE '%I61.4%' OR
            ICD_10 LIKE '%I61.5%' OR
            ICD_10 LIKE '%I61.6%' OR
            ICD_10 LIKE '%I61.8%' OR
            ICD_10 LIKE '%I61.9%' OR
            ICD_10 LIKE '%I62.9%' OR
            ICD_10 LIKE '%I69.1%'
        )
        AND post_admission_hours <= 48
    )
);
ALTER TABLE processed_data ADD COLUMN "traumatic brain injury" TEXT DEFAULT 'No';

UPDATE processed_data
SET "traumatic brain injury" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM icd10_diagnoses
    WHERE ICD_10 IN ('S06.0', 'S06.1', 'S06.10', 'S06.11', 'S06.2', 'S06.20', 'S06.3', 'S06.30', 'S06.31', 
                     'S06.4', 'S06.41', 'S06.5', 'S06.50', 'S06.51', 'S06.6', 'S06.60', 'S06.61', 'S06.7', 
                     'S06.70', 'S06.71', 'S06.8', 'S06.80', 'S06.81', 'S06.9', 'S06.90', 'T06.0', 'T90.5')
    
    UNION
    
    SELECT DISTINCT new_hosp_id
    FROM clinical_notes
    WHERE (
        ICD_10 IN ('S06.0', 'S06.1', 'S06.10', 'S06.11', 'S06.2', 'S06.20', 'S06.3', 'S06.30', 'S06.31',
                   'S06.4', 'S06.41', 'S06.5', 'S06.50', 'S06.51', 'S06.6', 'S06.60', 'S06.61', 'S06.7',
                   'S06.70', 'S06.71', 'S06.8', 'S06.80', 'S06.81', 'S06.9', 'S06.90', 'T06.0', 'T90.5')
    )
);
ALTER TABLE processed_data ADD COLUMN "anemia";

UPDATE processed_data
SET "anemia" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM icd10_diagnoses
    WHERE ICD_10 IN ('D50', 'D50.0', 'D50.8', 'D50.9', 'D51.9', 'D53.0', 'D53.8', 'D53.9', 'D55.8', 'D62', 'D63.8', 'D64.8', 'D64.9')
    AND post_admission_hours <= 48
    
    UNION
    
    SELECT DISTINCT new_hosp_id
    FROM clinical_notes
    WHERE (
        ICD_10 IN ('D50', 'D50.0', 'D50.8', 'D50.9', 'D51.9', 'D53.0', 'D53.8', 'D53.9', 'D55.8', 'D62', 'D63.8', 'D64.8', 'D64.9')
    )
    AND post_admission_hours <= 48
);
ALTER TABLE processed_data ADD COLUMN diabetis_1_type TEXT;

UPDATE processed_data
SET diabetis_1_type = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (

        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('E10', 'E10.4', 'E10.5', 'E10.7', 'E10.8', 'E10.9')
        
        UNION
        
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%E10%' OR
            ICD_10 LIKE '%E10.4%' OR
            ICD_10 LIKE '%E10.5%' OR
            ICD_10 LIKE '%E10.7%' OR
            ICD_10 LIKE '%E10.8%' OR
            ICD_10 LIKE '%E10.9%'
        )
    )
);
ALTER TABLE processed_data ADD COLUMN diabetis_2_type TEXT;
UPDATE processed_data
SET diabetis_2_type = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('E11.1', 'E11.2', 'E11.4', 'E11.5', 'E11.6', 'E11.7', 'E11.8', 'E11.9')
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%E11.1%' OR
            ICD_10 LIKE '%E11.2%' OR
            ICD_10 LIKE '%E11.4%' OR
            ICD_10 LIKE '%E11.5%' OR
            ICD_10 LIKE '%E11.6%' OR
            ICD_10 LIKE '%E11.7%' OR
            ICD_10 LIKE '%E11.8%' OR
            ICD_10 LIKE '%E11.9%'
        )
    )
);
ALTER TABLE processed_data ADD COLUMN cerebrovascular_disease TEXT;
UPDATE processed_data
SET cerebrovascular_disease = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('I66.0', 'I67.1', 'I67.2', 'I67.3', 'I67.4')
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%I66.0%' OR
            ICD_10 LIKE '%I67.1%' OR
            ICD_10 LIKE '%I67.2%' OR
            ICD_10 LIKE '%I67.3%' OR
            ICD_10 LIKE '%I67.4%'
        )
    )
);
ALTER TABLE processed_data ADD COLUMN chronic_kidney_disease TEXT;
UPDATE processed_data
SET chronic_kidney_disease = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('N18', 'N18.1', 'N18.2', 'N18.3', 'N18.4', 'N18.9')
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%N18%' OR
            ICD_10 LIKE '%N18.1%' OR
            ICD_10 LIKE '%N18.2%' OR
            ICD_10 LIKE '%N18.3%' OR
            ICD_10 LIKE '%N18.4%' OR
            ICD_10 LIKE '%N18.9%'
        )
    )
);
ALTER TABLE processed_data ADD COLUMN "COPD" TEXT;
UPDATE processed_data
SET "COPD" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('J44.0', 'J44.1', 'J44.8', 'J44.9')
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%J44.0%' OR
            ICD_10 LIKE '%J44.1%' OR
            ICD_10 LIKE '%J44.8%' OR
            ICD_10 LIKE '%J44.9%'
        )
    )
);
ALTER TABLE processed_data ADD COLUMN pneumonia TEXT;
UPDATE processed_data
SET pneumonia = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN (
            'J12.8', 'J12.9', 'J15.0', 'J15.1', 'J15.2', 'J15.5', 'J15.6', 'J15.8', 'J15.9',
            'J16.8', 'J17.1', 'J17.8', 'J18.0', 'J18.1', 'J18.2', 'J18.8', 'J18.9'
        )
        AND post_admission_hours <= 48
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%J12.8%' OR
            ICD_10 LIKE '%J12.9%' OR
            ICD_10 LIKE '%J15.0%' OR
            ICD_10 LIKE '%J15.1%' OR
            ICD_10 LIKE '%J15.2%' OR
            ICD_10 LIKE '%J15.5%' OR
            ICD_10 LIKE '%J15.6%' OR
            ICD_10 LIKE '%J15.8%' OR
            ICD_10 LIKE '%J15.9%' OR
            ICD_10 LIKE '%J16.8%' OR
            ICD_10 LIKE '%J17.1%' OR
            ICD_10 LIKE '%J17.8%' OR
            ICD_10 LIKE '%J18.0%' OR
            ICD_10 LIKE '%J18.1%' OR
            ICD_10 LIKE '%J18.2%' OR
            ICD_10 LIKE '%J18.8%' OR
            ICD_10 LIKE '%J18.9%'
        )
        AND post_admission_hours <= 48
    )
);
ALTER TABLE processed_data ADD COLUMN "myocardial_infarction" TEXT;
UPDATE processed_data
SET "myocardial_infarction" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('I21.0', 'I21.1', 'I21.4', 'I21.9', 'I23.6', 'I24.9')
        AND post_admission_hours <= 48
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%I21.0%' OR
            ICD_10 LIKE '%I21.1%' OR
            ICD_10 LIKE '%I21.4%' OR
            ICD_10 LIKE '%I21.9%' OR
            ICD_10 LIKE '%I23.6%' OR
            ICD_10 LIKE '%I24.9%'
        )
        AND post_admission_hours <= 48
    )
);
ALTER TABLE processed_data ADD COLUMN coronary_artery_disease TEXT;
UPDATE processed_data
SET coronary_artery_disease = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('I25', 'I25.0', 'I25.1', 'I25.2', 'I25.3', 'I25.5', 'I25.8', 'I25.9')
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%I25%' OR
            ICD_10 LIKE '%I25.0%' OR
            ICD_10 LIKE '%I25.1%' OR
            ICD_10 LIKE '%I25.2%' OR
            ICD_10 LIKE '%I25.3%' OR
            ICD_10 LIKE '%I25.5%' OR
            ICD_10 LIKE '%I25.8%' OR
            ICD_10 LIKE '%I25.9%'
        )
    )
);
ALTER TABLE processed_data ADD COLUMN "atrial_fibrillation" TEXT;
UPDATE processed_data
SET "atrial_fibrillation" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('I48.1', 'I48.2')
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%I48.1%' OR
            ICD_10 LIKE '%I48.2%'
        )
    )
);

ALTER TABLE processed_data ADD COLUMN "arterial hypertension" TEXT;
UPDATE processed_data
SET "arterial hypertension" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('I10', 'I11', 'I11.0', 'I11.9', 'I12.9', 'I13.0', 'I13.2', 'I13.9', 'I15.2', 'I15.8', 'I15.9')
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%I10%' OR
            ICD_10 LIKE '%I11%' OR
            ICD_10 LIKE '%I11.0%' OR
            ICD_10 LIKE '%I11.9%' OR
            ICD_10 LIKE '%I12.9%' OR
            ICD_10 LIKE '%I13.0%' OR
            ICD_10 LIKE '%I13.2%' OR
            ICD_10 LIKE '%I13.9%' OR
            ICD_10 LIKE '%I15.2%' OR
            ICD_10 LIKE '%I15.8%' OR
            ICD_10 LIKE '%I15.9%'
        )
    )
);
ALTER TABLE processed_data ADD COLUMN "coagulopathy" TEXT;
UPDATE processed_data
SET "coagulopathy" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('D68.0', 'D68.3', 'D68.4', 'D68.5', 'D68.6', 'D69.5', 'D69.6', 'D69.9')
        AND post_admission_hours <= 48
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%D68.0%' OR
            ICD_10 LIKE '%D68.3%' OR
            ICD_10 LIKE '%D68.4%' OR
            ICD_10 LIKE '%D68.5%' OR
            ICD_10 LIKE '%D68.6%' OR
            ICD_10 LIKE '%D69.5%' OR
            ICD_10 LIKE '%D69.6%' OR
            ICD_10 LIKE '%D69.9%'
        )
        AND post_admission_hours <= 48
    )
);
ALTER TABLE processed_data ADD COLUMN "inflammatory_diseases_CNS" TEXT;
UPDATE processed_data
SET "inflammatory_diseases_CNS" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('G00.8', 'G00.9', 'G03.9', 'G04.2', 'G04.8', 'G04.9', 'G05.0', 'G06.0', 'G06.2', 'G09')
        AND post_admission_hours <= 48
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%G00.8%' OR
            ICD_10 LIKE '%G00.9%' OR
            ICD_10 LIKE '%G03.9%' OR
            ICD_10 LIKE '%G04.2%' OR
            ICD_10 LIKE '%G04.8%' OR
            ICD_10 LIKE '%G04.9%' OR
            ICD_10 LIKE '%G05.0%' OR
            ICD_10 LIKE '%G06.0%' OR
            ICD_10 LIKE '%G06.2%' OR
            ICD_10 LIKE '%G09%'
        )
        AND post_admission_hours <= 48
    )
);
ALTER TABLE processed_data ADD COLUMN "polyneuropathy" TEXT;
UPDATE processed_data
SET "polyneuropathy" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('G61.0', 'G61.8', 'G61.9', 'G62.1', 'G62.2', 'G62.8', 'G62.9', 'G63.0', 'G63.2', 'G63.3', 'G63.8')
        AND post_admission_hours <= 48
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%G61.0%' OR
            ICD_10 LIKE '%G61.8%' OR
            ICD_10 LIKE '%G61.9%' OR
            ICD_10 LIKE '%G62.1%' OR
            ICD_10 LIKE '%G62.2%' OR
            ICD_10 LIKE '%G62.8%' OR
            ICD_10 LIKE '%G62.9%' OR
            ICD_10 LIKE '%G63.0%' OR
            ICD_10 LIKE '%G63.2%' OR
            ICD_10 LIKE '%G63.3%' OR
            ICD_10 LIKE '%G63.8%'
        )
        AND post_admission_hours <= 48
    )
);
ALTER TABLE processed_data ADD COLUMN "heart_failure" TEXT;
UPDATE processed_data
SET "heart_failure" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('I11.0', 'I13.0', 'I13.2', 'I50.0', 'I50.1', 'I50.9')
        AND post_admission_hours <= 48
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%I11.0%' OR
            ICD_10 LIKE '%I13.0%' OR
            ICD_10 LIKE '%I13.2%' OR
            ICD_10 LIKE '%I50.0%' OR
            ICD_10 LIKE '%I50.1%' OR
            ICD_10 LIKE '%I50.9%'
        )
        AND post_admission_hours <= 48
    )
);
ALTER TABLE processed_data ADD COLUMN "valvular_heart_disease" TEXT;
UPDATE processed_data
SET "valvular_heart_disease" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('I05.0', 'I05.8', 'I06.9', 'I07.0', 'I07.1', 'I07.8', 'I08.1', 'I08.3', 'I08.9', 'I34.0', 'I34.1', 'I35.0', 'I35.1', 'I35.2', 'I35.8', 'I35.9', 'I36.1', 'I38', 'Q23.3', 'Q23.8')
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%I05.0%' OR
            ICD_10 LIKE '%I05.8%' OR
            ICD_10 LIKE '%I06.9%' OR
            ICD_10 LIKE '%I07.0%' OR
            ICD_10 LIKE '%I07.1%' OR
            ICD_10 LIKE '%I07.8%' OR
            ICD_10 LIKE '%I08.1%' OR
            ICD_10 LIKE '%I08.3%' OR
            ICD_10 LIKE '%I08.9%' OR
            ICD_10 LIKE '%I34.0%' OR
            ICD_10 LIKE '%I34.1%' OR
            ICD_10 LIKE '%I35.0%' OR
            ICD_10 LIKE '%I35.1%' OR
            ICD_10 LIKE '%I35.2%' OR
            ICD_10 LIKE '%I35.8%' OR
            ICD_10 LIKE '%I35.9%' OR
            ICD_10 LIKE '%I36.1%' OR
            ICD_10 LIKE '%I38%' OR
            ICD_10 LIKE '%Q23.3%' OR
            ICD_10 LIKE '%Q23.8%'
        )
    )
);
ALTER TABLE processed_data ADD COLUMN "mental_cognitive_disorders" TEXT;
UPDATE processed_data
SET "mental_cognitive_disorders" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('F00.1', 'F00.9', 'F01.9', 'F02.8', 'F05.8', 'F06', 'F06.2', 'F06.3', 'F06.6', 'F06.7', 'F06.8', 'F06.9', 'F07', 'F07.0', 'F07.8', 'F07.9', 'F09.9', 'F13', 'F19.1', 'F23.1', 'F29', 'F45.3')
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%F00.1%' OR
            ICD_10 LIKE '%F00.9%' OR
            ICD_10 LIKE '%F01.9%' OR
            ICD_10 LIKE '%F02.8%' OR
            ICD_10 LIKE '%F05.8%' OR
            ICD_10 LIKE '%F06%' OR
            ICD_10 LIKE '%F06.2%' OR
            ICD_10 LIKE '%F06.3%' OR
            ICD_10 LIKE '%F06.6%' OR
            ICD_10 LIKE '%F06.7%' OR
            ICD_10 LIKE '%F06.8%' OR
            ICD_10 LIKE '%F06.9%' OR
            ICD_10 LIKE '%F07%' OR
            ICD_10 LIKE '%F07.0%' OR
            ICD_10 LIKE '%F07.8%' OR
            ICD_10 LIKE '%F07.9%' OR
            ICD_10 LIKE '%F09.9%' OR
            ICD_10 LIKE '%F13%' OR
            ICD_10 LIKE '%F19.1%' OR
            ICD_10 LIKE '%F23.1%' OR
            ICD_10 LIKE '%F29%' OR
            ICD_10 LIKE '%F45.3%'
        )
    )
);
ALTER TABLE processed_data ADD COLUMN "polytrauma" TEXT;
UPDATE processed_data
SET "polytrauma" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('T02.7', 'T02.8', 'T02.80', 'T02.81', 'T06.0', 'T06.8', 'T94.0', 'T94.1')
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%T02.7%' OR
            ICD_10 LIKE '%T02.8%' OR
            ICD_10 LIKE '%T02.80%' OR
            ICD_10 LIKE '%T02.81%' OR
            ICD_10 LIKE '%T06.0%' OR
            ICD_10 LIKE '%T06.8%' OR
            ICD_10 LIKE '%T94.0%' OR
            ICD_10 LIKE '%T94.1%'
        )
    )
);
ALTER TABLE processed_data ADD COLUMN "malignant_tumor" TEXT;
UPDATE processed_data
SET "malignant_tumor" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('C00', 'C02.1', 'C07', 'C16.2', 'C16.8', 'C18.2', 'C18.7', 'C19', 'C21.8', 'C25.1', 'C34.1', 'C34.9', 'C38.1', 'C40.2', 'C44.4', 'C44.9', 'C50.1', 'C50.4', 'C50.8', 'C50.9', 'C53.8', 'C53.9', 'C61', 'C64', 'C67.8', 'C70.0', 'C71.1', 'C71.2', 'C71.4', 'C71.6', 'C71.7', 'C71.8', 'C71.9', 'C72.0', 'C72.8', 'C73', 'C74.0', 'C75.3', 'C79.3', 'C79.8', 'C90.0', 'D05.1')
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%C00%' OR
            ICD_10 LIKE '%C02.1%' OR
            ICD_10 LIKE '%C07%' OR
            ICD_10 LIKE '%C16.2%' OR
            ICD_10 LIKE '%C16.8%' OR
            ICD_10 LIKE '%C18.2%' OR
            ICD_10 LIKE '%C18.7%' OR
            ICD_10 LIKE '%C19%' OR
            ICD_10 LIKE '%C21.8%' OR
            ICD_10 LIKE '%C25.1%' OR
            ICD_10 LIKE '%C34.1%' OR
            ICD_10 LIKE '%C34.9%' OR
            ICD_10 LIKE '%C38.1%' OR
            ICD_10 LIKE '%C40.2%' OR
            ICD_10 LIKE '%C44.4%' OR
            ICD_10 LIKE '%C44.9%' OR
            ICD_10 LIKE '%C50.1%' OR
            ICD_10 LIKE '%C50.4%' OR
            ICD_10 LIKE '%C50.8%' OR
            ICD_10 LIKE '%C50.9%' OR
            ICD_10 LIKE '%C53.8%' OR
            ICD_10 LIKE '%C53.9%' OR
            ICD_10 LIKE '%C61%' OR
            ICD_10 LIKE '%C64%' OR
            ICD_10 LIKE '%C67.8%' OR
            ICD_10 LIKE '%C70.0%' OR
            ICD_10 LIKE '%C71.1%' OR
            ICD_10 LIKE '%C71.2%' OR
            ICD_10 LIKE '%C71.4%' OR
            ICD_10 LIKE '%C71.6%' OR
            ICD_10 LIKE '%C71.7%' OR
            ICD_10 LIKE '%C71.8%' OR
            ICD_10 LIKE '%C71.9%' OR
            ICD_10 LIKE '%C72.0%' OR
            ICD_10 LIKE '%C72.8%' OR
            ICD_10 LIKE '%C73%' OR
            ICD_10 LIKE '%C74.0%' OR
            ICD_10 LIKE '%C75.3%' OR
            ICD_10 LIKE '%C79.3%' OR
            ICD_10 LIKE '%C79.8%' OR
            ICD_10 LIKE '%C90.0%' OR
            ICD_10 LIKE '%D05.1%'
        )
    )
);
ALTER TABLE detailed_sofa ADD COLUMN "multiorgan_failure" TEXT;
UPDATE detailed_sofa
SET "multiorgan_failure" = 'Yes'
WHERE new_hosp_id IN (
    SELECT new_hosp_id
    FROM detailed_sofa
    WHERE (
        (mechanical_ventilation = 'Yes') +
        (vasoactive_drugs = 'Yes') +
        (GCS_score < 15) +
        (platelets < 150) +
        (bilirubin > 20) +
        (creatinine >= 110)
    ) >= 2
);
ALTER TABLE processed_data ADD COLUMN multiorgan_failure_admission TEXT;
UPDATE processed_data
SET multiorgan_failure_admission = (
    SELECT CASE
        WHEN COUNT(*) = 0 THEN NULL
        WHEN SUM(CASE WHEN multiorgan_failure = 'Yes' THEN 1 ELSE 0 END) > 0 THEN 'Yes'
        ELSE 'No'
    END
    FROM detailed_sofa
    WHERE detailed_sofa.new_hosp_id = processed_data.new_hosp_id
    AND post_admission_days IN (0, 1)
);
ALTER TABLE processed_data ADD COLUMN "brain_disorders" TEXT;

UPDATE processed_data
SET "brain_disorders" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN (
            'G45.0', 'G45.9', 'G46.0', 'H11.3', 'I60.0', 'I60.1', 'I60.2', 'I60.6', 
            'I60.8', 'I60.9', 'I61.0', 'I61.1', 'I61.2', 'I61.3', 'I61.4', 'I61.5', 
            'I61.6', 'I61.8', 'I61.9', 'I62.0', 'I62.9', 'I63.0', 'I63.2', 'I63.3', 
            'I63.4', 'I63.5', 'I63.8', 'I63.9', 'I64', 'I69.0', 'I69.1', 'I69.2', 
            'I69.3', 'I69.4', 'S06.0', 'S06.1', 'S06.10', 'S06.11', 'S06.2', 'S06.20', 
            'S06.3', 'S06.30', 'S06.31', 'S06.4', 'S06.41', 'S06.5', 'S06.50', 'S06.51', 
            'S06.6', 'S06.60', 'S06.61', 'S06.7', 'S06.70', 'S06.71', 'S06.8', 'S06.80', 
            'S06.81', 'S06.9', 'S06.90', 'T90.5'
        )
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%G45.0%' OR ICD_10 LIKE '%G45.9%' OR ICD_10 LIKE '%G46.0%' OR
            ICD_10 LIKE '%H11.3%' OR ICD_10 LIKE '%I60.0%' OR ICD_10 LIKE '%I60.1%' OR
            ICD_10 LIKE '%I60.2%' OR ICD_10 LIKE '%I60.6%' OR ICD_10 LIKE '%I60.8%' OR
            ICD_10 LIKE '%I60.9%' OR ICD_10 LIKE '%I61.0%' OR ICD_10 LIKE '%I61.1%' OR
            ICD_10 LIKE '%I61.2%' OR ICD_10 LIKE '%I61.3%' OR ICD_10 LIKE '%I61.4%' OR
            ICD_10 LIKE '%I61.5%' OR ICD_10 LIKE '%I61.6%' OR ICD_10 LIKE '%I61.8%' OR
            ICD_10 LIKE '%I61.9%' OR ICD_10 LIKE '%I62.0%' OR ICD_10 LIKE '%I62.9%' OR
            ICD_10 LIKE '%I63.0%' OR ICD_10 LIKE '%I63.2%' OR ICD_10 LIKE '%I63.3%' OR
            ICD_10 LIKE '%I63.4%' OR ICD_10 LIKE '%I63.5%' OR ICD_10 LIKE '%I63.8%' OR
            ICD_10 LIKE '%I63.9%' OR ICD_10 LIKE '%I64%' OR ICD_10 LIKE '%I69.0%' OR
            ICD_10 LIKE '%I69.1%' OR ICD_10 LIKE '%I69.2%' OR ICD_10 LIKE '%I69.3%' OR
            ICD_10 LIKE '%I69.4%' OR ICD_10 LIKE '%S06.0%' OR ICD_10 LIKE '%S06.1%' OR
            ICD_10 LIKE '%S06.10%' OR ICD_10 LIKE '%S06.11%' OR ICD_10 LIKE '%S06.2%' OR
            ICD_10 LIKE '%S06.20%' OR ICD_10 LIKE '%S06.3%' OR ICD_10 LIKE '%S06.30%' OR
            ICD_10 LIKE '%S06.31%' OR ICD_10 LIKE '%S06.4%' OR ICD_10 LIKE '%S06.41%' OR
            ICD_10 LIKE '%S06.5%' OR ICD_10 LIKE '%S06.50%' OR ICD_10 LIKE '%S06.51%' OR
            ICD_10 LIKE '%S06.6%' OR ICD_10 LIKE '%S06.60%' OR ICD_10 LIKE '%S06.61%' OR
            ICD_10 LIKE '%S06.7%' OR ICD_10 LIKE '%S06.70%' OR ICD_10 LIKE '%S06.71%' OR
            ICD_10 LIKE '%S06.8%' OR ICD_10 LIKE '%S06.80%' OR ICD_10 LIKE '%S06.81%' OR
            ICD_10 LIKE '%S06.9%' OR ICD_10 LIKE '%S06.90%' OR ICD_10 LIKE '%T90.5%'
        )
    )
);




-- Шкалы при поступлении

ALTER TABLE processed_data ADD COLUMN "SOFA" TEXT;
ALTER TABLE processed_data ADD COLUMN "GCS" TEXT;
ALTER TABLE processed_data ADD COLUMN "DRS" TEXT;
ALTER TABLE processed_data ADD COLUMN "FOUR" TEXT;
ALTER TABLE processed_data ADD COLUMN "Waterlow" TEXT;
ALTER TABLE processed_data ADD COLUMN "Wells_DVT" TEXT;
ALTER TABLE processed_data ADD COLUMN "Geneva" TEXT;
ALTER TABLE processed_data ADD COLUMN "CRS-R" TEXT;
ALTER TABLE processed_data ADD COLUMN "MRS" TEXT;
ALTER TABLE processed_data ADD COLUMN "ШРМ" TEXT;
ALTER TABLE processed_data ADD COLUMN "Ashworth" TEXT;
ALTER TABLE processed_data ADD COLUMN "Rivermid" TEXT;
ALTER TABLE processed_data ADD COLUMN "Barthel" TEXT;
ALTER TABLE processed_data ADD COLUMN "Caprini" TEXT;

UPDATE processed_data
SET "SOFA" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Шкала SOFA (Sequential Organ Failure Assessment)'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "GCS" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Шкала комы Глазго (ШКГ)'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "DRS" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Шкала оценки тяжести делирия (DRS)'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "FOUR" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Шкала подробной оценки состояния ареактивных пациентов (FOUR)'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "Waterlow" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Шкала Ватерлоу (Waterlow, pressure ulcer risk)'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "Wells_DVT" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Шкала Уэллса для оценки вероятности ТЭЛА (Wells'' Criteria for DVT)'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "Geneva" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Женевская шкала'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "CRS-R" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Шкала восстановления после комы (пересмотренная) Coma Recovery Scale – Revised (CRS-R)'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "MRS" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Модифицированная шкала Рэнкина (Modified Rankin Scale)'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "ШРМ" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Шкала реабилитационной маршрутизации (ШРМ)'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "Ashworth" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Модифицированная шкала Эшворта (Modified Ashworth Scale)'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "Rivermid" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Индекс мобильности Ривермид'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "Barthel" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Шкала Бартель (Barthel Activities of daily living Index)'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);

UPDATE processed_data
SET "Caprini" = (
    SELECT result 
    FROM all_scales 
    WHERE all_scales.new_hosp_id = processed_data.new_hosp_id 
    AND scale_rus = 'Шкала оценки риска развития венозных тромбоэмболических осложнений (ВТЭО) у пациентов хирургического профиля (Caprini)'
    AND post_admission_days IN (0, 1)
    ORDER BY post_admission_days ASC
    LIMIT 1
);
-- Лабораторные параметры при поступлении
CREATE INDEX IF NOT EXISTS idx_lab_data_hosp_id ON lab_data(new_hosp_id);
CREATE INDEX IF NOT EXISTS idx_lab_data_parameter ON lab_data(parameter_eng_short);
CREATE INDEX IF NOT EXISTS idx_lab_data_days ON lab_data(post_admission_days);
CREATE INDEX IF NOT EXISTS idx_lab_data_biomaterial ON lab_data(biomaterial_eng);

CREATE TEMP TABLE first_lab_results AS
SELECT 
    new_hosp_id,
    parameter_eng_short,
    result_num
FROM (
    SELECT 
        new_hosp_id,
        parameter_eng_short,
        result_num,
        post_admission_days,
        ROW_NUMBER() OVER (PARTITION BY new_hosp_id, parameter_eng_short ORDER BY post_admission_days ASC) as rn
    FROM lab_data
    WHERE 
        post_admission_days IN (0, 1) AND
        biomaterial_eng IN ('Venous blood', 'Capillary blood', 'Arterial blood')
) 
WHERE rn = 1;

CREATE INDEX idx_temp_lab_results ON first_lab_results(new_hosp_id, parameter_eng_short);

ALTER TABLE processed_data ADD COLUMN "glucose" REAL;
ALTER TABLE processed_data ADD COLUMN "WBC" REAL;
ALTER TABLE processed_data ADD COLUMN "RBC" REAL;
ALTER TABLE processed_data ADD COLUMN "Hct" REAL;
ALTER TABLE processed_data ADD COLUMN "lym" REAL;
ALTER TABLE processed_data ADD COLUMN "neu" REAL;
ALTER TABLE processed_data ADD COLUMN "PLT" REAL;
ALTER TABLE processed_data ADD COLUMN "MCV" REAL;
ALTER TABLE processed_data ADD COLUMN "MCH" REAL;
ALTER TABLE processed_data ADD COLUMN "MCHC" REAL;
ALTER TABLE processed_data ADD COLUMN "RDW-CV" REAL;
ALTER TABLE processed_data ADD COLUMN "monocytes" REAL;
ALTER TABLE processed_data ADD COLUMN "abs_lym" REAL;
ALTER TABLE processed_data ADD COLUMN "abs_neu" REAL;
ALTER TABLE processed_data ADD COLUMN "abs_mono" REAL;
ALTER TABLE processed_data ADD COLUMN "basophils" REAL;
ALTER TABLE processed_data ADD COLUMN "MPV" REAL;
ALTER TABLE processed_data ADD COLUMN "eos" REAL;
ALTER TABLE processed_data ADD COLUMN "creatinine" REAL;
ALTER TABLE processed_data ADD COLUMN "RDW-SD" REAL;
ALTER TABLE processed_data ADD COLUMN "Total_protein" REAL;
ALTER TABLE processed_data ADD COLUMN "AST" REAL;
ALTER TABLE processed_data ADD COLUMN "ALT" REAL;
ALTER TABLE processed_data ADD COLUMN "abs_eos" REAL;
ALTER TABLE processed_data ADD COLUMN "BUN" REAL;
ALTER TABLE processed_data ADD COLUMN "CRP" REAL;
ALTER TABLE processed_data ADD COLUMN "Hb" REAL;
ALTER TABLE processed_data ADD COLUMN "alb" REAL;
ALTER TABLE processed_data ADD COLUMN "total_bilirubin" REAL;
ALTER TABLE processed_data ADD COLUMN "lactate" REAL;

UPDATE processed_data
SET 
    glucose = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Glucose'),
    WBC = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Leukocytes (WBC)'),
    RBC = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Erythrocytes (RBC)'),
    Hct = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Hematocrit (Hct)'),
    lym = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Lymphocytes'),
    neu = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Neutrophils'),
    PLT = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Platelets (PLT)'),
    MCV = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Mean Corpuscular Volume (MCV)'),
    MCH = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Mean Corpuscular Hemoglobin (MCH)'),
    MCHC = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Mean Corpuscular Hemoglobin Concentration (MCHC)'),
    "RDW-CV" = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Red Cell Distribution Width - Coefficient of Variation (RDW-CV)'),
    monocytes = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Monocytes'),
    abs_lym = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Absolute Lymphocyte Count'),
    abs_neu = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Absolute Neutrophil Count'),
    abs_mono = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Absolute Monocyte Count'),
    basophils = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Basophils'),
    MPV = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Mean Platelet Volume (MPV)'),
    eos = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Eosinophils'),
    creatinine = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Creatinine'),
    "RDW-SD" = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Red Cell Distribution Width - Standard Deviation (RDW-SD)'),
    Total_protein = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Total Protein'),
    AST = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Aspartate Aminotransferase (AST)'),
    ALT = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Alanine Aminotransferase (ALT)'),
    abs_eos = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Absolute Eosinophil Count'),
    BUN = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Urea (Blood Urea Nitrogen - BUN)'),
    CRP = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'C-Reactive Protein (CRP)'),
    Hb = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Hemoglobin (Hb)'),
    alb = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Albumin'),
    total_bilirubin = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Total Bilirubin'),
    lactate = (SELECT result_num FROM first_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Lactate (cLac)');

DROP TABLE first_lab_results;

DROP INDEX IF EXISTS idx_lab_data_hosp_id;
DROP INDEX IF EXISTS idx_lab_data_parameter;
DROP INDEX IF EXISTS idx_lab_data_days;
DROP INDEX IF EXISTS idx_lab_data_biomaterial;

CREATE INDEX IF NOT EXISTS idx_lab_data_fibrinogen ON lab_data(parameter_eng_short) WHERE parameter_eng_short = 'Fibrinogen (Clauss Method)';
CREATE INDEX IF NOT EXISTS idx_lab_data_ph ON lab_data(parameter_eng_short) WHERE parameter_eng_short = 'pH';
CREATE INDEX IF NOT EXISTS idx_lab_data_ck ON lab_data(parameter_eng_short) WHERE parameter_eng_short = 'Creatine Kinase (CK)';
CREATE INDEX IF NOT EXISTS idx_lab_data_cholesterol ON lab_data(parameter_eng_short) WHERE parameter_eng_short = 'Total Cholesterol';
CREATE INDEX IF NOT EXISTS idx_lab_data_pct ON lab_data(parameter_eng_short) WHERE parameter_eng_short = 'Procalcitonin (PCT)';
CREATE INDEX IF NOT EXISTS idx_lab_data_ddimer ON lab_data(parameter_eng_short) WHERE parameter_eng_short = 'D-Dimer';

ALTER TABLE processed_data ADD COLUMN "fibrinogen" REAL;
ALTER TABLE processed_data ADD COLUMN "pH" REAL;
ALTER TABLE processed_data ADD COLUMN "creatine_kinase" REAL;
ALTER TABLE processed_data ADD COLUMN "total_cholesterol" REAL;
ALTER TABLE processed_data ADD COLUMN "procalcitonin" REAL;
ALTER TABLE processed_data ADD COLUMN "D-Dimer" REAL;

CREATE TEMP TABLE additional_lab_results AS
SELECT 
    new_hosp_id,
    parameter_eng_short,
    result_num
FROM (
    SELECT 
        new_hosp_id,
        parameter_eng_short,
        result_num,
        post_admission_days,
        ROW_NUMBER() OVER (PARTITION BY new_hosp_id, parameter_eng_short ORDER BY post_admission_days ASC) as rn
    FROM lab_data
    WHERE 
        post_admission_days IN (0, 1) AND
        biomaterial_eng IN ('Venous blood', 'Capillary blood', 'Arterial blood') AND
        parameter_eng_short IN (
            'Fibrinogen (Clauss Method)',
            'pH',
            'Creatine Kinase (CK)',
            'Total Cholesterol',
            'Procalcitonin (PCT)',
            'D-Dimer'
        )
) 
WHERE rn = 1;

CREATE INDEX idx_temp_additional_results ON additional_lab_results(new_hosp_id, parameter_eng_short);

UPDATE processed_data
SET 
    fibrinogen = (SELECT result_num FROM additional_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Fibrinogen (Clauss Method)'),
    pH = (SELECT result_num FROM additional_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'pH'),
    creatine_kinase = (SELECT result_num FROM additional_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Creatine Kinase (CK)'),
    total_cholesterol = (SELECT result_num FROM additional_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Total Cholesterol'),
    procalcitonin = (SELECT result_num FROM additional_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'Procalcitonin (PCT)'),
    "D-Dimer" = (SELECT result_num FROM additional_lab_results WHERE new_hosp_id = processed_data.new_hosp_id AND parameter_eng_short = 'D-Dimer');

DROP TABLE additional_lab_results;

DROP INDEX IF EXISTS idx_lab_data_fibrinogen;
DROP INDEX IF EXISTS idx_lab_data_ph;
DROP INDEX IF EXISTS idx_lab_data_ck;
DROP INDEX IF EXISTS idx_lab_data_cholesterol;
DROP INDEX IF EXISTS idx_lab_data_pct;
DROP INDEX IF EXISTS idx_lab_data_ddimer;
-- Осложнения и исходы
ALTER TABLE processed_data ADD COLUMN "sepsis_outcome_icd" TEXT;
UPDATE processed_data
SET "sepsis_outcome_icd" = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM (
        SELECT new_hosp_id
        FROM icd10_diagnoses
        WHERE ICD_10 IN ('A41.0', 'A41.1', 'A41.5', 'A41.8', 'A41.9')
        
        UNION
                
        SELECT new_hosp_id
        FROM clinical_notes
        WHERE (
            ICD_10 LIKE '%A41.0%' OR
            ICD_10 LIKE '%A41.1%' OR
            ICD_10 LIKE '%A41.5%' OR
            ICD_10 LIKE '%A41.8%' OR
            ICD_10 LIKE '%A41.9%'
        )
    )
);

ALTER TABLE processed_data ADD COLUMN multiorgan_failure_outcome TEXT;
UPDATE processed_data
SET multiorgan_failure_outcome = (
    SELECT CASE
        WHEN COUNT(*) = 0 THEN NULL
        WHEN SUM(CASE WHEN multiorgan_failure = 'Yes' THEN 1 ELSE 0 END) > 0 THEN 'Yes'
        ELSE 'No'
    END
    FROM detailed_sofa
    WHERE detailed_sofa.new_hosp_id = processed_data.new_hosp_id
); 
-- АНАЛИЗ ИВЛ
ALTER TABLE processed_data ADD COLUMN MV_SOFA TEXT;
ALTER TABLE processed_data ADD COLUMN MV_ICD TEXT;
ALTER TABLE processed_data ADD COLUMN MV_ICD_clinnotes TEXT;
UPDATE processed_data
SET MV_SOFA = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM detailed_sofa
    WHERE mechanical_ventilation = 'Yes'
);

UPDATE processed_data
SET MV_ICD = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM icd10_diagnoses
    WHERE ICD_10 IN ('Z93.0', 'Z99.1', 'J95.0')
);

UPDATE processed_data
SET MV_ICD_clinnotes = 'Yes'
WHERE new_hosp_id IN (
    SELECT DISTINCT new_hosp_id
    FROM clinical_notes
    WHERE ICD_10 LIKE '%Z93.0%'
       OR ICD_10 LIKE '%Z99.1%'
       OR ICD_10 LIKE '%J95.0%'
);

ALTER TABLE processed_data ADD COLUMN need_for_mv TEXT;

UPDATE processed_data
SET need_for_mv = CASE 
    WHEN COALESCE(MV_SOFA, '') = 'Yes' 
      OR COALESCE(MV_ICD, '') = 'Yes' 
      OR COALESCE(MV_ICD_clinnotes, '') = 'Yes' THEN 'Yes'
    ELSE 'No'
END;

ALTER TABLE processed_data DROP COLUMN MV_SOFA;
ALTER TABLE processed_data DROP COLUMN MV_ICD;
ALTER TABLE processed_data DROP COLUMN MV_ICD_clinnotes;

Анализ ICU_readmission
ALTER TABLE processed_data ADD COLUMN ICU_readmission TEXT;

UPDATE processed_data
SET ICU_readmission = 'Yes'
WHERE new_hosp_id IN (
    SELECT new_hosp_id
    FROM patient_pathway
    GROUP BY new_hosp_id
    HAVING MAX(icu_admission_number) >= 2
);

UPDATE processed_data
SET ICU_readmission = COALESCE(ICU_readmission, 'No');

-- Анализ потребности в гемодинамической поддержке

CREATE INDEX IF NOT EXISTS idx_detailed_sofa_hosp_id ON detailed_sofa(new_hosp_id);
CREATE INDEX IF NOT EXISTS idx_detailed_sofa_vasoactive ON detailed_sofa(vasoactive_drugs);
CREATE INDEX IF NOT EXISTS idx_therapy_prescriptions_hosp_id ON therapy_prescriptions(new_hosp_id);
CREATE INDEX IF NOT EXISTS idx_therapy_prescriptions_inn_rus ON therapy_prescriptions(inn_rus);

ALTER TABLE processed_data ADD COLUMN hemodynamic_support TEXT;

CREATE TEMP TABLE temp_vasoactive AS
SELECT new_hosp_id, 
       MAX(CASE WHEN vasoactive_drugs != 'No' THEN 1 ELSE 0 END) AS has_vasoactive
FROM detailed_sofa
GROUP BY new_hosp_id;

CREATE TEMP TABLE temp_specific_drugs AS
SELECT new_hosp_id,
       MAX(CASE WHEN inn_rus IN ('Норэпинефрин', 'Фенилэфрин', 'Эпинефрин', 'Добутамин', 'Допамин') 
           THEN 1 ELSE 0 END) AS has_specific_drugs
FROM therapy_prescriptions
GROUP BY new_hosp_id;

UPDATE processed_data
SET hemodynamic_support = CASE 
    WHEN EXISTS (
        SELECT 1 FROM temp_vasoactive 
        WHERE temp_vasoactive.new_hosp_id = processed_data.new_hosp_id 
        AND temp_vasoactive.has_vasoactive = 1
    ) OR EXISTS (
        SELECT 1 FROM temp_specific_drugs 
        WHERE temp_specific_drugs.new_hosp_id = processed_data.new_hosp_id 
        AND temp_specific_drugs.has_specific_drugs = 1
    ) THEN 'Yes' 
    ELSE 'No' 
END;

DROP TABLE temp_vasoactive;
DROP TABLE temp_specific_drugs;

-- Расчет дополнительных шкал

CREATE TABLE ricd_dynamic (
    new_patient_id INTEGER,
    new_hosp_id INTEGER,
    post_admission_days INTEGER,
    PaCO2_SIRS REAL,
    respiratory_rate_SIRS REAL,
    WBC_SIRS REAL,
    temperature_SIRS REAL,
    heart_rate_SIRS REAL,
    SIRS INTEGER
);

WITH RECURSIVE days_sequence AS (
    SELECT 
        new_patient_id,
        new_hosp_id,
        hospital_length_of_stay,
        0 AS day
    FROM all_patients
    
    UNION ALL
    
    SELECT 
        new_patient_id,
        new_hosp_id,
        hospital_length_of_stay,
        day + 1
    FROM days_sequence
    WHERE day < hospital_length_of_stay - 1
)

INSERT INTO ricd_dynamic (new_patient_id, new_hosp_id, post_admission_days)
SELECT 
    ds.new_patient_id,
    ds.new_hosp_id,
    ds.day AS post_admission_days
FROM days_sequence ds
JOIN all_patients ap ON ds.new_patient_id = ap.new_patient_id
ORDER BY ds.new_patient_id, ds.day;

CREATE TABLE temp_ricd_dynamic AS
SELECT DISTINCT * FROM ricd_dynamic;

DROP TABLE ricd_dynamic;

ALTER TABLE temp_ricd_dynamic RENAME TO ricd_dynamic;


-- SIRS
CREATE TEMP TABLE temp_paco2 AS
SELECT 
    new_hosp_id,
    post_admission_days,
    MIN(result_num) AS min_paco2  
FROM lab_data
WHERE 
    parameter_rus = 'Парциальное давление углекислого газа (pCO2)' AND
    biomaterial_rus = 'Кровь артериальная'
GROUP BY 
    new_hosp_id, 
    post_admission_days;

CREATE INDEX idx_temp_paco2 ON temp_paco2(new_hosp_id, post_admission_days);
CREATE INDEX idx_ricd_dynamic ON ricd_dynamic(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET PaCO2_SIRS = (
    SELECT min_paco2
    FROM temp_paco2
    WHERE 
        temp_paco2.new_hosp_id = ricd_dynamic.new_hosp_id AND
        temp_paco2.post_admission_days = ricd_dynamic.post_admission_days
);

DROP INDEX idx_temp_paco2;
DROP INDEX idx_ricd_dynamic;
DROP TABLE temp_paco2;

CREATE TEMPORARY TABLE temp_resp_rate AS
SELECT 
    new_hosp_id,
    post_admission_days,
    MAX(value) AS max_resp_rate
FROM monitoring_data
WHERE parameter = 'respiratory rate'
GROUP BY new_hosp_id, post_admission_days;

CREATE INDEX idx_temp_resp_rate ON temp_resp_rate(new_hosp_id, post_admission_days);
CREATE INDEX idx_ricd_dynamic ON ricd_dynamic(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET respiratory_rate_SIRS = (
    SELECT max_resp_rate
    FROM temp_resp_rate tr
    WHERE tr.new_hosp_id = ricd_dynamic.new_hosp_id
    AND tr.post_admission_days = ricd_dynamic.post_admission_days
);

DROP TABLE temp_resp_rate;

CREATE TEMPORARY TABLE temp_lab_wbc AS
SELECT 
    new_hosp_id,
    post_admission_days,
    result_num,
    parameter_rus,
    biomaterial_rus
FROM lab_data
WHERE parameter_rus = 'Лейкоциты' AND biomaterial_rus = 'Кровь венозная';

CREATE INDEX idx_temp_lab_wbc ON temp_lab_wbc(new_hosp_id, post_admission_days);

CREATE TEMPORARY TABLE temp_wbc_aggregated AS
SELECT 
    new_hosp_id,
    post_admission_days,
    MAX(result_num) AS max_wbc,
    MIN(result_num) AS min_wbc,
    COUNT(*) AS wbc_count
FROM temp_lab_wbc
GROUP BY new_hosp_id, post_admission_days;

CREATE INDEX idx_temp_wbc_agg ON temp_wbc_aggregated(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic AS rd
SET WBC_SIRS = (
    SELECT 
        CASE 
            WHEN MAX(result_num) > 12 THEN MAX(result_num)
            ELSE MIN(result_num)
        END
    FROM temp_lab_wbc
    WHERE rd.new_hosp_id = temp_lab_wbc.new_hosp_id 
    AND rd.post_admission_days = temp_lab_wbc.post_admission_days
    GROUP BY temp_lab_wbc.new_hosp_id, temp_lab_wbc.post_admission_days
)
WHERE EXISTS (
    SELECT 1 
    FROM temp_lab_wbc 
    WHERE rd.new_hosp_id = temp_lab_wbc.new_hosp_id 
    AND rd.post_admission_days = temp_lab_wbc.post_admission_days
);

UPDATE ricd_dynamic AS rd
SET WBC_SIRS = (
    SELECT 
        CASE 
            WHEN MAX(result_num) > 12 THEN MAX(result_num)
            ELSE MIN(result_num)
        END
    FROM temp_lab_wbc
    WHERE rd.new_hosp_id = temp_lab_wbc.new_hosp_id 
    AND (rd.post_admission_days = temp_lab_wbc.post_admission_days + 1 
         OR rd.post_admission_days = temp_lab_wbc.post_admission_days - 1)
    GROUP BY temp_lab_wbc.new_hosp_id
)
WHERE WBC_SIRS IS NULL
AND EXISTS (
    SELECT 1 
    FROM temp_lab_wbc 
    WHERE rd.new_hosp_id = temp_lab_wbc.new_hosp_id 
    AND (rd.post_admission_days = temp_lab_wbc.post_admission_days + 1 
         OR rd.post_admission_days = temp_lab_wbc.post_admission_days - 1)
);

DROP TABLE temp_lab_wbc;
DROP TABLE temp_wbc_aggregated;

CREATE TEMPORARY TABLE temp_monitoring_temp AS
SELECT 
    new_hosp_id,
    post_admission_days,
    value AS temperature_value,
    parameter
FROM monitoring_data
WHERE parameter = 'temperature';

CREATE INDEX idx_temp_monitoring_temp ON temp_monitoring_temp(new_hosp_id, post_admission_days);

CREATE TEMPORARY TABLE temp_temperature_aggregated AS
SELECT 
    new_hosp_id,
    post_admission_days,
    MAX(temperature_value) AS max_temp,
    MIN(temperature_value) AS min_temp,
    COUNT(*) AS temp_count
FROM temp_monitoring_temp
GROUP BY new_hosp_id, post_admission_days;

CREATE INDEX idx_temp_temp_agg ON temp_temperature_aggregated(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic AS rd
SET temperature_SIRS = (
    SELECT 
        CASE 
            WHEN MAX(temperature_value) > 38 THEN MAX(temperature_value)
            ELSE MIN(temperature_value)
        END
    FROM temp_monitoring_temp
    WHERE rd.new_hosp_id = temp_monitoring_temp.new_hosp_id 
    AND rd.post_admission_days = temp_monitoring_temp.post_admission_days
    GROUP BY temp_monitoring_temp.new_hosp_id, temp_monitoring_temp.post_admission_days
)
WHERE EXISTS (
    SELECT 1 
    FROM temp_monitoring_temp 
    WHERE rd.new_hosp_id = temp_monitoring_temp.new_hosp_id 
    AND rd.post_admission_days = temp_monitoring_temp.post_admission_days
);

UPDATE ricd_dynamic AS rd
SET temperature_SIRS = (
    SELECT 
        CASE 
            WHEN MAX(temperature_value) > 38 THEN MAX(temperature_value)
            ELSE MIN(temperature_value)
        END
    FROM temp_monitoring_temp
    WHERE rd.new_hosp_id = temp_monitoring_temp.new_hosp_id 
    AND (rd.post_admission_days = temp_monitoring_temp.post_admission_days + 1 
         OR rd.post_admission_days = temp_monitoring_temp.post_admission_days - 1)
    GROUP BY temp_monitoring_temp.new_hosp_id
)
WHERE temperature_SIRS IS NULL
AND EXISTS (
    SELECT 1 
    FROM temp_monitoring_temp 
    WHERE rd.new_hosp_id = temp_monitoring_temp.new_hosp_id 
    AND (rd.post_admission_days = temp_monitoring_temp.post_admission_days + 1 
         OR rd.post_admission_days = temp_monitoring_temp.post_admission_days - 1)
);

DROP TABLE temp_monitoring_temp;
DROP TABLE temp_temperature_aggregated;

CREATE TEMPORARY TABLE temp_heart_data AS
SELECT 
    new_hosp_id,
    post_admission_days,
    value,
    parameter,
    CASE WHEN parameter = 'heart rate' THEN 1 ELSE 2 END AS priority 
FROM monitoring_data
WHERE parameter IN ('heart rate', 'pulse');

CREATE INDEX idx_temp_heart_data ON temp_heart_data(new_hosp_id, post_admission_days, priority);

CREATE TEMPORARY TABLE temp_heart_rate_agg AS
SELECT 
    new_hosp_id,
    post_admission_days,
    MAX(value) AS max_heart_rate
FROM temp_heart_data
WHERE parameter = 'heart rate'
GROUP BY new_hosp_id, post_admission_days;

CREATE INDEX idx_temp_heart_rate_agg ON temp_heart_rate_agg(new_hosp_id, post_admission_days);

CREATE TEMPORARY TABLE temp_pulse_agg AS
SELECT 
    new_hosp_id,
    post_admission_days,
    MAX(value) AS max_pulse
FROM temp_heart_data
WHERE parameter = 'pulse'
GROUP BY new_hosp_id, post_admission_days;

CREATE INDEX idx_temp_pulse_agg ON temp_pulse_agg(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET heart_rate_SIRS = (
    SELECT max_heart_rate
    FROM temp_heart_rate_agg
    WHERE ricd_dynamic.new_hosp_id = temp_heart_rate_agg.new_hosp_id
    AND ricd_dynamic.post_admission_days = temp_heart_rate_agg.post_admission_days
)
WHERE EXISTS (
    SELECT 1
    FROM temp_heart_rate_agg
    WHERE ricd_dynamic.new_hosp_id = temp_heart_rate_agg.new_hosp_id
    AND ricd_dynamic.post_admission_days = temp_heart_rate_agg.post_admission_days
);

UPDATE ricd_dynamic
SET heart_rate_SIRS = (
    SELECT max_pulse
    FROM temp_pulse_agg
    WHERE ricd_dynamic.new_hosp_id = temp_pulse_agg.new_hosp_id
    AND ricd_dynamic.post_admission_days = temp_pulse_agg.post_admission_days
)
WHERE heart_rate_SIRS IS NULL
AND EXISTS (
    SELECT 1
    FROM temp_pulse_agg
    WHERE ricd_dynamic.new_hosp_id = temp_pulse_agg.new_hosp_id
    AND ricd_dynamic.post_admission_days = temp_pulse_agg.post_admission_days
);

DROP TABLE temp_heart_data;
DROP TABLE temp_heart_rate_agg;
DROP TABLE temp_pulse_agg;

UPDATE ricd_dynamic
SET SIRS = 
    CASE 
        WHEN (PaCO2_SIRS IS NOT NULL AND PaCO2_SIRS < 32) OR 
             (respiratory_rate_SIRS IS NOT NULL AND respiratory_rate_SIRS > 20) 
        THEN 1 
        ELSE 0 
    END +
    
    CASE 
        WHEN (WBC_SIRS IS NOT NULL AND (WBC_SIRS > 12 OR WBC_SIRS < 4)) 
        THEN 1 
        ELSE 0 
    END +
    
    CASE 
        WHEN (temperature_SIRS IS NOT NULL AND (temperature_SIRS > 38 OR temperature_SIRS < 36)) 
        THEN 1 
        ELSE 0 
    END +
    
    CASE 
        WHEN (heart_rate_SIRS IS NOT NULL AND heart_rate_SIRS > 90) 
        THEN 1 
        ELSE 0 
    END;

ALTER TABLE ricd_dynamic RENAME COLUMN SIRS TO SIRS_score;

ALTER TABLE ricd_dynamic ADD COLUMN SIRS TEXT;

UPDATE ricd_dynamic
SET SIRS = 
    CASE 
        WHEN SIRS_score >= 2 THEN 'Yes'
        WHEN SIRS_score < 2 THEN 'No'
        ELSE NULL 
    END;

-- Sepsis-3 и шок
ALTER TABLE ricd_dynamic ADD COLUMN SOFA INTEGER;

CREATE TEMPORARY TABLE temp_sofa_scores AS
SELECT 
    new_hosp_id,
    post_admission_days,
    MAX(result) AS max_sofa_score
FROM all_scales
WHERE scale_rus = 'Шкала SOFA (Sequential Organ Failure Assessment)'
GROUP BY new_hosp_id, post_admission_days;

CREATE INDEX idx_temp_sofa ON temp_sofa_scores(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET SOFA = (
    SELECT max_sofa_score
    FROM temp_sofa_scores
    WHERE temp_sofa_scores.new_hosp_id = ricd_dynamic.new_hosp_id
    AND temp_sofa_scores.post_admission_days = ricd_dynamic.post_admission_days
);

DROP TABLE temp_sofa_scores;

ALTER TABLE ricd_dynamic ADD COLUMN infection_source TEXT;


CREATE TEMPORARY TABLE temp_bacteria_culture AS
SELECT DISTINCT
    new_hosp_id,
    post_admission_days
FROM bacteria_culture_test
WHERE result_rus NOT IN ('Не обнаружено', 'не обнаружено', 'Не обнаруж.');

CREATE INDEX idx_temp_bacteria_culture ON temp_bacteria_culture(new_hosp_id, post_admission_days);

CREATE TEMPORARY TABLE temp_antibiotic_resistance AS
SELECT DISTINCT
    new_hosp_id,
    post_admission_days
FROM antibiotic_resistance;

CREATE INDEX idx_temp_antibiotic_res ON temp_antibiotic_resistance(new_hosp_id, post_admission_days);

CREATE TEMPORARY TABLE temp_lab_bacteria AS
SELECT DISTINCT
    new_hosp_id,
    post_admission_days
FROM lab_data
WHERE parameter_rus = 'Бактерии'
AND result_rus NOT IN ('не обнаружены', 'Не обнаружены', 'Не обнаруж.', 'не обнаруж.');

CREATE INDEX idx_temp_lab_bacteria ON temp_lab_bacteria(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET infection_source = 
    CASE
        WHEN EXISTS (
            SELECT 1 FROM temp_bacteria_culture
            WHERE temp_bacteria_culture.new_hosp_id = ricd_dynamic.new_hosp_id
            AND temp_bacteria_culture.post_admission_days = ricd_dynamic.post_admission_days
        ) OR EXISTS (
            SELECT 1 FROM temp_antibiotic_resistance
            WHERE temp_antibiotic_resistance.new_hosp_id = ricd_dynamic.new_hosp_id
            AND temp_antibiotic_resistance.post_admission_days = ricd_dynamic.post_admission_days
        ) OR EXISTS (
            SELECT 1 FROM temp_lab_bacteria
            WHERE temp_lab_bacteria.new_hosp_id = ricd_dynamic.new_hosp_id
            AND temp_lab_bacteria.post_admission_days = ricd_dynamic.post_admission_days
        ) THEN 'Yes'
        ELSE 'No'
    END;

DROP TABLE temp_bacteria_culture;
DROP TABLE temp_antibiotic_resistance;
DROP TABLE temp_lab_bacteria;

CREATE TEMPORARY TABLE temp_antibiotics AS
SELECT DISTINCT inn_rus 
FROM therapy_prescriptions 
WHERE 
    pharm_group_rus IN (
        'антибактериальные средства системного действия; другие бета-лактамные антибактериальные средства; цефалоспорины третьего поколения',
        'антибактериальные средства системного действия; бета-лактамные антибактериальные средства, пенициллины; пенициллины широкого спектра действия',
        'Антибактериальные средства системного действия; другие антибактериальные средства; полимиксины',
        'противомикробное средство комбинированное',
        'антибиотики и противомикробные средства, применяемые в дерматологии;антибиотики для наружного применения; другие антибиотики для наружного применения',
        'противомикробное средство - нитрофуран',
        'противомикробное средство - хиноксалин',
        'противомикробные средства и антисептики, применяемые в гинекологии; противомикробные средства и антисептики, кроме комбинаций с кортикостероидами; производные имидазола',
        'антибиотики и противомикробные средства, применяемые в дерматологии; противомикробные средства для наружного применения; противовирусные средства',
        'противомикробные средства и антисептики, применяемые в гинекологии; противомикробные средства и антисептики, кроме комбинаций с кортикостероидами; антибиотики',
        'противомикробное средство - фторхинолон',
        'противомикробное и противовоспалительное кишечное средство',
        'противомикробное и противопротозойное средство',
        'противомикробное и противопротозойное средство - нитрофуран',
        'противомикробное средство',
        'противомикробное средство - хинолон',
        'противомикробное средство – сульфаниламид',
        'противомикробное и противопротозойное средство',
        'антибиотик',
        'антибиотик комбинированный (антибиотик+муколитик)',
        'антибиотик комбинированный (антибиотики: аминогликозид+полиен+циклический полипептид)',
        'антибиотик комбинированный (антибиотики: аминогликозид+полипептид циклический+местноанестезирующее средство)',
        'антибиотик-азалид',
        'антибиотик-аминогликозид',
        'антибиотик-гликопептид',
        'антибиотик-карбапенем',
        'антибиотик-макролид',
        'антибиотик-монобактам',
        'антибиотик-оксазолидинон',
        'антибиотик-полипептид циклический',
        'антибиотик-рифаксимин',
        'антибиотик-тетрациклин',
        'антибиотик-цефалоспорин',
        'антибиотики и противомикробные средства, применяемые в дерматологии; противомикробные средства для наружного применения; противовирусные средства',
        'антибиотики и противомикробные средства, применяемые в дерматологии;антибиотики для наружного применения; другие антибиотики для наружного применения',
        'глюкокортикостероид для местного применения+антибиотик-аминогликозид',
        'глюкокортикостероид для местного применения+антибиотик-аминогликозид+противогрибковое средство',
        'глюкокортикостероид для местного применения+антибиотики (аминогликозид+циклический полипептид)+альфа-адреномиметик',
        'глюкокортикостероид+антибиотики (аминогликозид и циклический полипептид)',
        'противомикробные средства и антисептики, применяемые в гинекологии; противомикробные средства и антисептики, кроме комбинаций с кортикостероидами; антибиотики'
    )
    OR inn_rus IN (
        'Амоксициллин+[Клавулановая кислота]',
        'Цефоперазон+[Сульбактам]',
        'Цефепим+[Сульбактам]',
        'Ампициллин+[Сульбактам]',
        'Сульбактам',
        'Цефоперазон',
		'Ко-тримоксазол [Сульфаметоксазол+Триметоприм]',
		'Грамицидин С+Дексаметазон+Фрамицетин',
		'Имипенем+[Циластатин]',
		'Пиперациллин+[Тазобактам]', 'Бактериофаг синегнойной палочки', 'Интести-бактериофаг', 'Пиобактериофаг', 'Бактериофаг клебсиелл пневмонии', 'Бактериофаг клебсиелл'
    );

CREATE INDEX IF NOT EXISTS idx_therapy_prescriptions_composite ON therapy_prescriptions(new_hosp_id, post_admission_days);
CREATE INDEX IF NOT EXISTS idx_ricd_dynamic_composite ON ricd_dynamic(new_hosp_id, post_admission_days);
CREATE INDEX IF NOT EXISTS idx_temp_antibiotics_inn ON temp_antibiotics(inn_rus);

ALTER TABLE ricd_dynamic ADD COLUMN antibiotic_therapy TEXT;

CREATE TEMPORARY TABLE temp_updates AS
SELECT 
    rd.rowid AS row_id,
    tp.inn_rus AS antibiotic_value
FROM 
    ricd_dynamic rd
JOIN 
    therapy_prescriptions tp ON rd.new_hosp_id = tp.new_hosp_id 
    AND rd.post_admission_days = tp.post_admission_days
JOIN 
    temp_antibiotics ta ON tp.inn_rus = ta.inn_rus;

CREATE INDEX IF NOT EXISTS idx_temp_updates_rowid ON temp_updates(row_id);

CREATE TEMPORARY TABLE temp_unique_updates AS
SELECT 
    row_id,
    GROUP_CONCAT(DISTINCT antibiotic_value) AS combined_antibiotics
FROM 
    (SELECT DISTINCT row_id, antibiotic_value FROM temp_updates)
GROUP BY 
    row_id;

UPDATE ricd_dynamic
SET antibiotic_therapy = (
    SELECT combined_antibiotics
    FROM temp_unique_updates
    WHERE temp_unique_updates.row_id = ricd_dynamic.rowid
)
WHERE rowid IN (SELECT row_id FROM temp_unique_updates);

DROP TABLE temp_antibiotics;
DROP TABLE temp_updates;
DROP TABLE temp_unique_updates;

ALTER TABLE ricd_dynamic ADD COLUMN sepsis_3 TEXT;
ALTER TABLE ricd_dynamic ADD COLUMN sepsis_episode TEXT;
ALTER TABLE ricd_dynamic ADD COLUMN lactate_shock REAL;
ALTER TABLE ricd_dynamic ADD COLUMN vasopressors_shock TEXT;
ALTER TABLE ricd_dynamic ADD COLUMN septic_shock TEXT;

CREATE INDEX IF NOT EXISTS idx_lab_data_lactate
ON lab_data (parameter_rus, biomaterial_rus, new_hosp_id, post_admission_days);

CREATE TEMP TABLE tmp_max_lactate AS
SELECT
    new_hosp_id,
    post_admission_days,
    MAX(result_num) AS max_lactate
FROM lab_data
WHERE parameter_rus = 'Лактат'
  AND biomaterial_rus = 'Кровь артериальная'
GROUP BY new_hosp_id, post_admission_days;

CREATE INDEX IF NOT EXISTS idx_tmp_lactate
ON tmp_max_lactate (new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET lactate_shock = (
    SELECT max_lactate
    FROM tmp_max_lactate
    WHERE tmp_max_lactate.new_hosp_id = ricd_dynamic.new_hosp_id
      AND tmp_max_lactate.post_admission_days = ricd_dynamic.post_admission_days
)
WHERE EXISTS (
    SELECT 1
    FROM tmp_max_lactate
    WHERE tmp_max_lactate.new_hosp_id = ricd_dynamic.new_hosp_id
      AND tmp_max_lactate.post_admission_days = ricd_dynamic.post_admission_days
);
CREATE TABLE ricd_dynamic_temp (
    new_patient_id INTEGER,
    new_hosp_id INTEGER,
    post_admission_days INTEGER,
    PaCO2_SIRS REAL,
    respiratory_rate_SIRS REAL,
    WBC_SIRS REAL,
    temperature_SIRS REAL,
    heart_rate_SIRS REAL,
    SIRS_score INTEGER,
    SIRS TEXT, 
    SOFA INTEGER, 
    infection_source TEXT,
    infection_period TEXT,  
    antibiotic_therapy TEXT,
    antibiotic_episode TEXT,  
    "infection_period+antibiotics" TEXT,  
    sepsis_3 TEXT, 
    lactate_shock REAL, 
    vasopressors_shock TEXT, 
    septic_shock TEXT
);

INSERT INTO ricd_dynamic_temp (
    new_patient_id,
    new_hosp_id,
    post_admission_days,
    PaCO2_SIRS,
    respiratory_rate_SIRS,
    WBC_SIRS,
    temperature_SIRS,
    heart_rate_SIRS,
    SIRS_score,
    SIRS,
    SOFA,
    infection_source,
    antibiotic_therapy,
    sepsis_3,
    lactate_shock,
    vasopressors_shock,
    septic_shock
)
SELECT 
    new_patient_id,
    new_hosp_id,
    post_admission_days,
    PaCO2_SIRS,
    respiratory_rate_SIRS,
    WBC_SIRS,
    temperature_SIRS,
    heart_rate_SIRS,
    SIRS_score,
    SIRS,
    SOFA,
    infection_source,
    antibiotic_therapy,
    sepsis_3,
    lactate_shock,
    vasopressors_shock,
    septic_shock
FROM ricd_dynamic;

DROP TABLE ricd_dynamic;

ALTER TABLE ricd_dynamic_temp RENAME TO ricd_dynamic;

CREATE INDEX IF NOT EXISTS idx_hosp_id_days ON ricd_dynamic(new_hosp_id, post_admission_days);
CREATE INDEX IF NOT EXISTS idx_infection_source ON ricd_dynamic(infection_source);

CREATE TEMP TABLE infection_ranges AS
SELECT 
    new_hosp_id,
    post_admission_days AS infection_day,
    post_admission_days + 6 AS infection_end_day,  
    post_admission_days - 1 AS infection_start_day 
FROM ricd_dynamic
WHERE infection_source = 'Yes';

CREATE INDEX IF NOT EXISTS idx_temp_infection_ranges ON infection_ranges(new_hosp_id, infection_day);

UPDATE ricd_dynamic
SET infection_period = 'Yes'
WHERE EXISTS (
    SELECT 1
    FROM infection_ranges
    WHERE infection_ranges.new_hosp_id = ricd_dynamic.new_hosp_id
    AND ricd_dynamic.post_admission_days BETWEEN infection_ranges.infection_start_day AND infection_ranges.infection_end_day  
);

UPDATE ricd_dynamic
SET infection_period = 'No'
WHERE infection_period IS NULL;

DROP TABLE IF EXISTS infection_ranges;
DROP INDEX IF EXISTS idx_hosp_id_days;
DROP INDEX IF EXISTS idx_infection_source;

CREATE INDEX IF NOT EXISTS idx_ricd_dynamic_hosp_id ON ricd_dynamic(new_hosp_id, post_admission_days);
CREATE INDEX IF NOT EXISTS idx_ricd_dynamic_days ON ricd_dynamic(post_admission_days);

UPDATE ricd_dynamic
SET antibiotic_episode = CASE 
    WHEN antibiotic_therapy IS NOT NULL AND antibiotic_therapy != '' THEN 'Yes'
    ELSE 'No'
END;

CREATE TEMPORARY TABLE temp_antibiotic_ranges AS
WITH flagged_days AS (
    SELECT 
        new_hosp_id,
        post_admission_days,
        antibiotic_episode,
        LAG(antibiotic_episode) OVER (PARTITION BY new_hosp_id ORDER BY post_admission_days) AS prev_day,
        LEAD(antibiotic_episode) OVER (PARTITION BY new_hosp_id ORDER BY post_admission_days) AS next_day
    FROM ricd_dynamic
)
SELECT 
    new_hosp_id,
    post_admission_days
FROM flagged_days
WHERE 
    (antibiotic_episode = 'No' AND prev_day = 'Yes' AND next_day = 'Yes') OR
    (antibiotic_episode = 'Yes');

CREATE INDEX idx_temp_antibiotic_ranges ON temp_antibiotic_ranges(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET antibiotic_episode = 'Yes'
WHERE EXISTS (
    SELECT 1 
    FROM temp_antibiotic_ranges t
    WHERE 
        t.new_hosp_id = ricd_dynamic.new_hosp_id AND
        t.post_admission_days = ricd_dynamic.post_admission_days
);

DROP TABLE temp_antibiotic_ranges;

CREATE INDEX IF NOT EXISTS idx_infection_period ON ricd_dynamic(infection_period);
CREATE INDEX IF NOT EXISTS idx_antibiotic_episode ON ricd_dynamic(antibiotic_episode);

UPDATE ricd_dynamic
SET "infection_period+antibiotics" = 
    CASE 
        WHEN infection_period = 'Yes' OR antibiotic_episode = 'Yes'
        THEN 'Yes' 
        ELSE 'No' 
    END;

DROP INDEX IF EXISTS idx_infection_period;
DROP INDEX IF EXISTS idx_antibiotic_therapy;

-- Сепсис-3

CREATE INDEX IF NOT EXISTS idx_ricd_main ON ricd_dynamic(new_hosp_id, post_admission_days);
CREATE INDEX IF NOT EXISTS idx_ricd_sofa ON ricd_dynamic(new_hosp_id, post_admission_days, SOFA);
CREATE INDEX IF NOT EXISTS idx_ricd_infection ON ricd_dynamic(new_hosp_id, post_admission_days, "infection_period+antibiotics");
CREATE INDEX IF NOT EXISTS idx_ricd_antibiotic ON ricd_dynamic(new_hosp_id, post_admission_days, antibiotic_episode);
CREATE INDEX IF NOT EXISTS idx_ricd_sepsis ON ricd_dynamic(new_hosp_id, post_admission_days, sepsis_3);

UPDATE ricd_dynamic
SET sepsis_3 = CASE WHEN SOFA IS NOT NULL THEN 'No' ELSE NULL END
WHERE post_admission_days = 0;

DROP TABLE IF EXISTS temp_sofa_min;
CREATE TEMP TABLE temp_sofa_min AS
SELECT 
    r1.new_hosp_id,
    r1.post_admission_days,
    MIN(r2.SOFA) AS min_sofa_prev_2_days,
    COUNT(r2.SOFA) AS sofa_count_prev_2_days
FROM ricd_dynamic r1
LEFT JOIN ricd_dynamic r2 ON 
    r1.new_hosp_id = r2.new_hosp_id AND
    r2.post_admission_days BETWEEN r1.post_admission_days - 2 AND r1.post_admission_days - 1 AND
    r2.SOFA IS NOT NULL
WHERE r1.post_admission_days > 0
GROUP BY r1.new_hosp_id, r1.post_admission_days;

CREATE INDEX idx_temp_sofa_min ON temp_sofa_min(new_hosp_id, post_admission_days);

DROP TABLE IF EXISTS temp_initial_sepsis;
CREATE TEMP TABLE temp_initial_sepsis AS
SELECT 
    r.new_hosp_id,
    r.post_admission_days,
    r.SOFA,
    r."infection_period+antibiotics",
    CASE
        WHEN t.sofa_count_prev_2_days > 0 AND
             r.SOFA >= t.min_sofa_prev_2_days + 2 AND
             r."infection_period+antibiotics" = 'Yes' 
        THEN 'Yes'
        WHEN t.sofa_count_prev_2_days > 0 AND
             (r.SOFA < t.min_sofa_prev_2_days + 2 OR
              r."infection_period+antibiotics" = 'No')
        THEN 'No'
        ELSE NULL
    END AS sepsis_status
FROM ricd_dynamic r
LEFT JOIN temp_sofa_min t ON 
    r.new_hosp_id = t.new_hosp_id AND 
    r.post_admission_days = t.post_admission_days
WHERE r.post_admission_days > 0;

CREATE INDEX idx_temp_initial_sepsis ON temp_initial_sepsis(new_hosp_id, post_admission_days);

DROP TABLE IF EXISTS temp_sepsis_with_ab;
CREATE TEMP TABLE temp_sepsis_with_ab AS
SELECT 
    s.new_hosp_id,
    s.post_admission_days AS sepsis_day,
    MIN(a.post_admission_days) AS first_ab_day
FROM temp_initial_sepsis s
JOIN ricd_dynamic a ON 
    a.new_hosp_id = s.new_hosp_id AND
    a.post_admission_days BETWEEN s.post_admission_days + 1 AND s.post_admission_days + 7 AND
    a.antibiotic_episode = 'Yes'
WHERE s.sepsis_status = 'Yes'
GROUP BY s.new_hosp_id, s.post_admission_days;

CREATE INDEX idx_temp_sepsis_with_ab ON temp_sepsis_with_ab(new_hosp_id, sepsis_day);

DROP TABLE IF EXISTS temp_sepsis_periods;
CREATE TEMP TABLE temp_sepsis_periods AS
SELECT 
    s.new_hosp_id,
    s.sepsis_day AS start_day,
    COALESCE(
        (SELECT MIN(r.post_admission_days) - 1
         FROM ricd_dynamic r
         WHERE 
             r.new_hosp_id = s.new_hosp_id AND
             r.post_admission_days > s.first_ab_day AND
             r.antibiotic_episode = 'No'),
        (SELECT MAX(post_admission_days) FROM ricd_dynamic WHERE new_hosp_id = s.new_hosp_id)
    ) AS end_day
FROM temp_sepsis_with_ab s;

CREATE INDEX idx_temp_sepsis_periods ON temp_sepsis_periods(new_hosp_id, start_day, end_day);

UPDATE ricd_dynamic
SET sepsis_3 = CASE
    WHEN post_admission_days = 0 THEN 
        CASE WHEN SOFA IS NOT NULL THEN 'No' ELSE NULL END
    
    WHEN EXISTS (
        SELECT 1 FROM temp_initial_sepsis i
        WHERE 
            i.new_hosp_id = ricd_dynamic.new_hosp_id AND
            i.post_admission_days = ricd_dynamic.post_admission_days AND
            i.sepsis_status = 'Yes' AND
            NOT EXISTS (
                SELECT 1 FROM temp_sepsis_with_ab a
                WHERE 
                    a.new_hosp_id = i.new_hosp_id AND
                    a.sepsis_day = i.post_admission_days
            )
    ) THEN 'Yes'
    
    WHEN EXISTS (
        SELECT 1 FROM temp_sepsis_periods p
        WHERE 
            p.new_hosp_id = ricd_dynamic.new_hosp_id AND
            ricd_dynamic.post_admission_days BETWEEN p.start_day AND p.end_day
    ) THEN 'Yes'
    
    WHEN EXISTS (
        SELECT 1 FROM temp_initial_sepsis i
        WHERE 
            i.new_hosp_id = ricd_dynamic.new_hosp_id AND
            i.post_admission_days = ricd_dynamic.post_admission_days AND
            i.sepsis_status = 'No'
    ) THEN 'No'
    
    ELSE NULL
END;

WITH sepsis_episodes AS (
    SELECT 
        new_hosp_id,
        post_admission_days,
        SUM(new_episode) OVER (PARTITION BY new_hosp_id ORDER BY post_admission_days) AS episode_num
    FROM (
        SELECT 
            new_hosp_id,
            post_admission_days,
            CASE WHEN sepsis_3 = 'Yes' AND 
                      (LAG(sepsis_3) OVER (PARTITION BY new_hosp_id ORDER BY post_admission_days) IS NULL OR 
                       LAG(sepsis_3) OVER (PARTITION BY new_hosp_id ORDER BY post_admission_days) = 'No' OR
                       LAG(sepsis_3) OVER (PARTITION BY new_hosp_id ORDER BY post_admission_days) IS NULL)
                 THEN 1 ELSE 0 END AS new_episode
        FROM ricd_dynamic
    )
)
UPDATE ricd_dynamic
SET sepsis_episode = e.episode_num
FROM sepsis_episodes e
WHERE 
    ricd_dynamic.new_hosp_id = e.new_hosp_id AND
    ricd_dynamic.post_admission_days = e.post_admission_days AND
    ricd_dynamic.sepsis_3 = 'Yes';

DROP TABLE IF EXISTS temp_sofa_min;
DROP TABLE IF EXISTS temp_initial_sepsis;
DROP TABLE IF EXISTS temp_sepsis_with_ab;
DROP TABLE IF EXISTS temp_sepsis_periods;

DROP TABLE IF EXISTS temp_sepsis_to_revert;
CREATE TEMP TABLE temp_sepsis_to_revert AS
SELECT 
    s.new_hosp_id,
    s.post_admission_days AS sepsis_day
FROM ricd_dynamic s
WHERE s.sepsis_3 = 'Yes'
AND NOT EXISTS (
    SELECT 1 
    FROM ricd_dynamic a
    WHERE 
        a.new_hosp_id = s.new_hosp_id AND
        a.post_admission_days BETWEEN s.post_admission_days AND s.post_admission_days + 7 AND
        a.antibiotic_episode = 'Yes'
);

CREATE INDEX idx_temp_sepsis_to_revert ON temp_sepsis_to_revert(new_hosp_id, sepsis_day);

UPDATE ricd_dynamic
SET sepsis_3 = 'No'
WHERE EXISTS (
    SELECT 1
    FROM temp_sepsis_to_revert r
    WHERE 
        ricd_dynamic.new_hosp_id = r.new_hosp_id AND
        ricd_dynamic.post_admission_days = r.sepsis_day
);

DROP TABLE IF EXISTS temp_sepsis_to_revert;
DROP TABLE IF EXISTS temp_sepsis_yes_days;
CREATE TEMP TABLE temp_sepsis_yes_days AS
SELECT 
    new_hosp_id,
    post_admission_days
FROM ricd_dynamic
WHERE sepsis_3 = 'Yes';

CREATE INDEX idx_temp_sepsis_yes_days ON temp_sepsis_yes_days(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET sepsis_3 = NULL
WHERE sepsis_3 = 'No'
AND EXISTS (
    SELECT 1
    FROM temp_sepsis_yes_days y
    WHERE 
        y.new_hosp_id = ricd_dynamic.new_hosp_id AND
        y.post_admission_days = ricd_dynamic.post_admission_days - 1
);

DROP TABLE IF EXISTS temp_sepsis_yes_days;

UPDATE ricd_dynamic
SET sepsis_episode = NULL;

DROP TABLE IF EXISTS temp_sepsis_episodes;
CREATE TEMP TABLE temp_sepsis_episodes AS
WITH sepsis_sequence AS (
    SELECT 
        new_hosp_id,
        post_admission_days,
        sepsis_3,
        CASE WHEN sepsis_3 = 'Yes' AND 
                  (LAG(sepsis_3, 1, NULL) OVER (PARTITION BY new_hosp_id ORDER BY post_admission_days) IS NULL OR
                   LAG(sepsis_3, 1, NULL) OVER (PARTITION BY new_hosp_id ORDER BY post_admission_days) != 'Yes')
             THEN 1 ELSE 0 END AS new_episode_flag
    FROM ricd_dynamic
)
SELECT 
    new_hosp_id,
    post_admission_days,
    SUM(new_episode_flag) OVER (PARTITION BY new_hosp_id ORDER BY post_admission_days) AS episode_number
FROM sepsis_sequence
WHERE sepsis_3 = 'Yes';

CREATE INDEX idx_temp_sepsis_episodes ON temp_sepsis_episodes(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET sepsis_episode = (
    SELECT episode_number
    FROM temp_sepsis_episodes e
    WHERE 
        e.new_hosp_id = ricd_dynamic.new_hosp_id AND
        e.post_admission_days = ricd_dynamic.post_admission_days
)
WHERE EXISTS (
    SELECT 1
    FROM temp_sepsis_episodes e
    WHERE 
        e.new_hosp_id = ricd_dynamic.new_hosp_id AND
        e.post_admission_days = ricd_dynamic.post_admission_days
);

DROP TABLE IF EXISTS temp_sepsis_episodes;

-- Cептический шок
UPDATE ricd_dynamic
SET septic_shock = CASE 
    WHEN sepsis_3 = 'Yes' 
    AND vasopressors_shock = 'Yes'
    AND (
        (lactate_shock IS NOT NULL AND lactate_shock > 2) OR
        EXISTS (
            SELECT 1 FROM ricd_dynamic r2 
            WHERE r2.new_hosp_id = ricd_dynamic.new_hosp_id 
            AND r2.post_admission_days = ricd_dynamic.post_admission_days + 1
            AND r2.lactate_shock IS NOT NULL 
            AND r2.lactate_shock > 2
        ) OR
        EXISTS (
            SELECT 1 FROM ricd_dynamic r2 
            WHERE r2.new_hosp_id = ricd_dynamic.new_hosp_id 
            AND r2.post_admission_days = ricd_dynamic.post_admission_days - 1
            AND r2.lactate_shock IS NOT NULL 
            AND r2.lactate_shock > 2
        )
    )
    THEN 'Yes'
    ELSE 'No'
END;

-- AKIN
ALTER TABLE ricd_dynamic ADD COLUMN creatinine_AKIN REAL;

CREATE INDEX IF NOT EXISTS idx_lab_data_creatinine ON lab_data (new_hosp_id, post_admission_days) 
WHERE parameter_eng_short = 'Creatinine' AND biomaterial_rus = 'Кровь венозная';

CREATE INDEX IF NOT EXISTS idx_ricd_dynamic_hosp_days ON ricd_dynamic (new_hosp_id, post_admission_days);

CREATE TEMPORARY TABLE temp_creatinine AS
SELECT 
    l.new_hosp_id, 
    l.post_admission_days, 
    l.result_num AS creatinine_value
FROM 
    lab_data l
WHERE 
    l.parameter_eng_short = 'Creatinine' 
    AND l.biomaterial_rus = 'Кровь венозная'
    AND l.result_num IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_temp_creatinine ON temp_creatinine (new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET creatinine_AKIN = (
    SELECT t.creatinine_value
    FROM temp_creatinine t
    WHERE t.new_hosp_id = ricd_dynamic.new_hosp_id
    AND t.post_admission_days = ricd_dynamic.post_admission_days
    LIMIT 1  
)
WHERE EXISTS (
    SELECT 1
    FROM temp_creatinine t
    WHERE t.new_hosp_id = ricd_dynamic.new_hosp_id
    AND t.post_admission_days = ricd_dynamic.post_admission_days
);

DROP TABLE IF EXISTS temp_creatinine;

ALTER TABLE ricd_dynamic ADD COLUMN daily_diuresis_by_weight_AKIN REAL;
ALTER TABLE ricd_dynamic ADD COLUMN oliguria_AKIN INTEGER;

CREATE INDEX IF NOT EXISTS idx_monitoring_diuresis ON monitoring_data (new_hosp_id, post_admission_days) 
WHERE parameter = 'diuresis';

CREATE INDEX IF NOT EXISTS idx_all_patients_weight ON all_patients (new_hosp_id);

CREATE TEMPORARY TABLE temp_daily_diuresis AS
SELECT 
    new_hosp_id, 
    post_admission_days,
    SUM(value) AS total_diuresis_ml
FROM monitoring_data
WHERE parameter = 'diuresis'
GROUP BY new_hosp_id, post_admission_days;

UPDATE ricd_dynamic
SET daily_diuresis_by_weight_AKIN = (
    SELECT ROUND((d.total_diuresis_ml / p.body_weight) / 24, 1)
    FROM temp_daily_diuresis d
    JOIN all_patients p ON d.new_hosp_id = p.new_hosp_id
    WHERE d.new_hosp_id = ricd_dynamic.new_hosp_id
      AND d.post_admission_days = ricd_dynamic.post_admission_days
      AND p.body_weight > 0
    LIMIT 1
)
WHERE EXISTS (
    SELECT 1 FROM temp_daily_diuresis d
    JOIN all_patients p ON d.new_hosp_id = p.new_hosp_id
    WHERE d.new_hosp_id = ricd_dynamic.new_hosp_id
      AND d.post_admission_days = ricd_dynamic.post_admission_days
      AND p.body_weight > 0
);

UPDATE ricd_dynamic
SET oliguria_AKIN = CASE 
    WHEN daily_diuresis_by_weight_AKIN < 0.5 THEN 'Yes'
    WHEN daily_diuresis_by_weight_AKIN >= 0.5 THEN 'No' 
    ELSE NULL 
END;

DROP TABLE IF EXISTS temp_daily_diuresis;

ALTER TABLE ricd_dynamic ADD COLUMN AKIN TEXT;

CREATE TEMPORARY TABLE prev_creatinine AS
SELECT 
    rd1.new_hosp_id,
    rd1.post_admission_days,
    MAX(rd2.post_admission_days) AS prev_day,
    rd2.creatinine_AKIN AS prev_creatinine
FROM ricd_dynamic rd1
LEFT JOIN ricd_dynamic rd2 ON 
    rd1.new_hosp_id = rd2.new_hosp_id AND 
    rd2.post_admission_days < rd1.post_admission_days AND
    rd2.creatinine_AKIN IS NOT NULL
GROUP BY rd1.new_hosp_id, rd1.post_admission_days;

CREATE INDEX idx_ricd_dynamic_id_day ON ricd_dynamic(new_hosp_id, post_admission_days);
CREATE INDEX idx_prev_creatinine_id_day ON prev_creatinine(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET AKIN = CASE 
    WHEN oliguria_AKIN = 'Yes' THEN 'Yes'
    WHEN (
        SELECT COUNT(*) 
        FROM prev_creatinine pc 
        WHERE pc.new_hosp_id = ricd_dynamic.new_hosp_id 
        AND pc.post_admission_days = ricd_dynamic.post_admission_days
        AND pc.prev_creatinine IS NOT NULL
    ) > 0 AND (
            SELECT pc.prev_creatinine 
            FROM prev_creatinine pc 
            WHERE pc.new_hosp_id = ricd_dynamic.new_hosp_id 
            AND pc.post_admission_days = ricd_dynamic.post_admission_days
        )) >= 26.4
        OR
        (ricd_dynamic.creatinine_AKIN * 1.0 / (
            SELECT pc.prev_creatinine 
            FROM prev_creatinine pc 
            WHERE pc.new_hosp_id = ricd_dynamic.new_hosp_id 
            AND pc.post_admission_days = ricd_dynamic.post_admission_days
        )) >= 1.5
    ) THEN 'Yes'
    ELSE 'No'
END
WHERE creatinine_AKIN IS NOT NULL OR oliguria_AKIN = 'Yes';

UPDATE ricd_dynamic
SET AKIN = 'No'
WHERE AKIN IS NULL;

DROP TABLE prev_creatinine;

ALTER TABLE ricd_dynamic RENAME COLUMN creatinine_AKIN TO creatinine_kdigo;

ALTER TABLE ricd_dynamic RENAME COLUMN daily_diuresis_by_weight_AKIN TO daily_diuresis_by_weight_kdigo;

ALTER TABLE ricd_dynamic RENAME COLUMN oliguria_AKIN TO oliguria_kdigo;

ALTER TABLE ricd_dynamic RENAME COLUMN AKIN TO AKI_kdigo;

-- APACHE II
DROP TABLE IF EXISTS APACHE_components;

CREATE TABLE APACHE_components (
  new_hosp_id TEXT,
  post_admission_days INTEGER,
  score_age INTEGER,
  score_hematocrit INTEGER,
  score_potassium INTEGER,
  score_sodium INTEGER,
  score_creatinine INTEGER,
  score_wbc INTEGER,
  score_ph INTEGER,
  score_map INTEGER,
  score_temp INTEGER,
  score_rr INTEGER,
  score_hr INTEGER,
  score_gcs INTEGER,
  score_oxygenation INTEGER
);

WITH 

Age_Score AS (
  SELECT 
    new_hosp_id,
    CASE
      WHEN age <= 44 THEN 0
      WHEN age BETWEEN 45 AND 54 THEN 2
      WHEN age BETWEEN 55 AND 64 THEN 3
      WHEN age BETWEEN 65 AND 74 THEN 5
      ELSE 6
    END AS score_age
  FROM all_patients
),

Best_Lab_Scores AS (
  SELECT 
    l.new_hosp_id,
    r.post_admission_days,
    l.parameter_rus,
    MAX(
      CASE
        WHEN l.parameter_rus = 'Гематокрит' THEN
          CASE
            WHEN result_num BETWEEN 30 AND 45.9 THEN 0
            WHEN result_num BETWEEN 46 AND 49.9 THEN 1
            WHEN (result_num BETWEEN 20 AND 29.9) OR (result_num BETWEEN 50 AND 59.9) THEN 2
            WHEN result_num < 20 OR result_num > 59.9 THEN 4
          END
        WHEN l.parameter_rus = 'Калий (К)' AND l.biomaterial_rus = 'Кровь венозная' THEN
          CASE
            WHEN result_num BETWEEN 3.5 AND 5.4 THEN 0
            WHEN result_num BETWEEN 3.0 AND 3.4 THEN 1
            WHEN result_num BETWEEN 2.5 AND 2.9 THEN 2
            WHEN result_num BETWEEN 6.0 AND 6.9 THEN 3
            WHEN result_num < 2.5 OR result_num > 6.9 THEN 4
          END
        WHEN l.parameter_rus = 'Натрий (Na)' AND l.biomaterial_rus = 'Кровь венозная' THEN
          CASE
            WHEN result_num BETWEEN 130 AND 149 THEN 0
            WHEN result_num BETWEEN 150 AND 154 THEN 1
            WHEN (result_num BETWEEN 120 AND 129) OR (result_num BETWEEN 155 AND 159) THEN 2
            WHEN (result_num BETWEEN 111 AND 119) OR (result_num BETWEEN 160 AND 179) THEN 3
            WHEN result_num < 111 OR result_num > 179 THEN 4
          END
        WHEN l.parameter_rus = 'Лейкоциты' AND l.biomaterial_rus = 'Кровь венозная' THEN
          CASE
            WHEN result_num BETWEEN 3.0 AND 14.9 THEN 0
            WHEN result_num BETWEEN 15 AND 19.9 THEN 1
            WHEN (result_num BETWEEN 1.0 AND 2.9) OR (result_num BETWEEN 20 AND 39.9) THEN 2
            WHEN result_num < 1.0 OR result_num > 39.9 THEN 4
          END
        WHEN l.parameter_rus = 'pH' AND l.biomaterial_rus = 'Кровь артериальная' THEN
          CASE
            WHEN result_num BETWEEN 7.33 AND 7.49 THEN 0
            WHEN result_num BETWEEN 7.50 AND 7.59 THEN 1
            WHEN result_num BETWEEN 7.25 AND 7.32 THEN 2
            WHEN (result_num BETWEEN 7.15 AND 7.24) OR (result_num BETWEEN 7.60 AND 7.69) THEN 3
            WHEN result_num < 7.15 OR result_num > 7.69 THEN 4
          END
      END
    ) AS score_value
  FROM lab_data l
  JOIN ricd_dynamic r 
    ON l.new_hosp_id = r.new_hosp_id 
   AND ABS(l.post_admission_days - r.post_admission_days) <= 1
  WHERE l.parameter_rus IN ('Гематокрит', 'Калий (К)', 'Натрий (Na)', 'Лейкоциты', 'pH')
  GROUP BY l.new_hosp_id, r.post_admission_days, l.parameter_rus
),


Creatinine_Score AS (
  SELECT 
    l.new_hosp_id,
    r.post_admission_days,
    MAX(
      CASE
        WHEN l.result_num < 132.5 THEN 0
        WHEN l.result_num BETWEEN 132.6 AND 176.7 THEN CASE WHEN r.AKI_kdigo = 'Yes' THEN 3 ELSE 2 END
        WHEN l.result_num BETWEEN 176.8 AND 300.56 THEN CASE WHEN r.AKI_kdigo = 'Yes' THEN 6 ELSE 3 END
        WHEN l.result_num > 300.56 THEN CASE WHEN r.AKI_kdigo = 'Yes' THEN 8 ELSE 4 END
      END
    ) AS score_creatinine
  FROM lab_data l
  JOIN ricd_dynamic r 
    ON l.new_hosp_id = r.new_hosp_id 
   AND ABS(l.post_admission_days - r.post_admission_days) <= 1
  WHERE l.parameter_rus = 'Креатинин' AND l.biomaterial_rus = 'Кровь венозная'
  GROUP BY l.new_hosp_id, r.post_admission_days
),


Best_Monitoring_Scores AS (
  SELECT 
    m.new_hosp_id,
    m.post_admission_days,
    m.parameter,
    MAX(
      CASE
        WHEN m.parameter = 'mean AP' THEN
          CASE
            WHEN value BETWEEN 70 AND 109 THEN 0
            WHEN (value BETWEEN 50 AND 69) OR (value BETWEEN 110 AND 129) THEN 2
            WHEN value BETWEEN 130 AND 159 THEN 3
            WHEN value <= 49 OR value >= 160 THEN 4
          END
        WHEN m.parameter = 'temperature' THEN
          CASE
            WHEN value BETWEEN 36 AND 38.4 THEN 0
            WHEN (value BETWEEN 34 AND 35.9) OR (value BETWEEN 38.5 AND 38.9) THEN 1
            WHEN value BETWEEN 32 AND 33.9 THEN 2
            WHEN (value BETWEEN 30 AND 31.9) OR (value BETWEEN 39 AND 40.9) THEN 3
            WHEN value >= 41 OR value < 30 THEN 4
          END
        WHEN m.parameter = 'respiratory rate' THEN
          CASE
            WHEN value BETWEEN 12 AND 24 THEN 0
            WHEN (value BETWEEN 10 AND 11) OR (value BETWEEN 25 AND 34) THEN 1
            WHEN value BETWEEN 6 AND 9 THEN 2
            WHEN value BETWEEN 35 AND 49 THEN 3
            WHEN value < 6 OR value >= 50 THEN 4
          END
        WHEN m.parameter = 'heart rate' THEN
          CASE
            WHEN value BETWEEN 70 AND 109 THEN 0
            WHEN (value BETWEEN 55 AND 69) OR (value BETWEEN 110 AND 139) THEN 2
            WHEN (value BETWEEN 40 AND 54) OR (value BETWEEN 140 AND 179) THEN 3
            WHEN value < 40 OR value >= 180 THEN 4
          END
      END
    ) AS score_value
  FROM monitoring_data m
  WHERE m.parameter IN ('mean AP', 'temperature', 'respiratory rate', 'heart rate')
  GROUP BY m.new_hosp_id, m.post_admission_days, m.parameter
),

Oxygenation_Score AS (
  SELECT 
    d.new_hosp_id,
    d.post_admission_days,
    CASE
      WHEN d."FiO2 %" IS NULL OR d."PaO2" IS NULL THEN NULL
      WHEN "FiO2 %" < 50 THEN 
        CASE 
          WHEN "PaO2" >= 70 THEN 0
          WHEN "PaO2" BETWEEN 61 AND 69 THEN 1
          WHEN "PaO2" BETWEEN 55 AND 60 THEN 3
          WHEN "PaO2" < 55 THEN 4
        END
      WHEN "FiO2 %" >= 50 THEN  
        CASE 
          WHEN (713 - (PaO2 + 1.25 * ("FiO2 %" - 21))) <= 100 THEN 0
          WHEN (713 - (PaO2 + 1.25 * ("FiO2 %" - 21))) BETWEEN 101 AND 200 THEN 1
          WHEN (713 - (PaO2 + 1.25 * ("FiO2 %" - 21))) BETWEEN 201 AND 350 THEN 3
          WHEN (713 - (PaO2 + 1.25 * ("FiO2 %" - 21))) > 350 THEN 4
        END
    END AS score_oxygenation
  FROM detailed_sofa d
),

GCS_Score AS (
  SELECT 
    s.new_hosp_id,
    r.post_admission_days,
    15 - s.result AS score_gcs
  FROM all_scales s
  JOIN ricd_dynamic r 
    ON s.new_hosp_id = r.new_hosp_id 
   AND ABS(s.post_admission_days - r.post_admission_days) <= 2
  WHERE s.scale_rus = 'Шкала комы Глазго (ШКГ)'
)

INSERT INTO APACHE_components (new_hosp_id, post_admission_days, 
  score_age, score_hematocrit, score_potassium, score_sodium, score_creatinine, score_wbc,
  score_ph, score_map, score_temp, score_rr, score_hr, score_gcs, score_oxygenation)

SELECT
  r.new_hosp_id,
  r.post_admission_days,
  a.score_age,
  (SELECT score_value FROM Best_Lab_Scores WHERE new_hosp_id = r.new_hosp_id AND post_admission_days = r.post_admission_days AND parameter_rus = 'Гематокрит'),
  (SELECT score_value FROM Best_Lab_Scores WHERE new_hosp_id = r.new_hosp_id AND post_admission_days = r.post_admission_days AND parameter_rus = 'Калий (К)'),
  (SELECT score_value FROM Best_Lab_Scores WHERE new_hosp_id = r.new_hosp_id AND post_admission_days = r.post_admission_days AND parameter_rus = 'Натрий (Na)'),
  (SELECT score_creatinine FROM Creatinine_Score WHERE new_hosp_id = r.new_hosp_id AND post_admission_days = r.post_admission_days),
  (SELECT score_value FROM Best_Lab_Scores WHERE new_hosp_id = r.new_hosp_id AND post_admission_days = r.post_admission_days AND parameter_rus = 'Лейкоциты'),
  (SELECT score_value FROM Best_Lab_Scores WHERE new_hosp_id = r.new_hosp_id AND post_admission_days = r.post_admission_days AND parameter_rus = 'pH'),
  (SELECT score_value FROM Best_Monitoring_Scores WHERE new_hosp_id = r.new_hosp_id AND post_admission_days = r.post_admission_days AND parameter = 'mean AP'),
  (SELECT score_value FROM Best_Monitoring_Scores WHERE new_hosp_id = r.new_hosp_id AND post_admission_days = r.post_admission_days AND parameter = 'temperature'),
  (SELECT score_value FROM Best_Monitoring_Scores WHERE new_hosp_id = r.new_hosp_id AND post_admission_days = r.post_admission_days AND parameter = 'respiratory rate'),
  (SELECT score_value FROM Best_Monitoring_Scores WHERE new_hosp_id = r.new_hosp_id AND post_admission_days = r.post_admission_days AND parameter = 'heart rate'),
  (SELECT score_gcs FROM GCS_Score WHERE new_hosp_id = r.new_hosp_id AND post_admission_days = r.post_admission_days),
  (SELECT score_oxygenation FROM Oxygenation_Score WHERE new_hosp_id = r.new_hosp_id AND post_admission_days = r.post_admission_days)

FROM RICD_dynamic r
LEFT JOIN Age_Score a ON a.new_hosp_id = r.new_hosp_id
WHERE r.post_admission_days % 7 = 0;

ALTER TABLE RICD_dynamic ADD COLUMN APACHE_II INTEGER;
UPDATE RICD_dynamic
SET APACHE_II = (
  SELECT 
    CASE 
      WHEN ac1.score_age IS NOT NULL THEN
        CASE
          WHEN ac1.score_hematocrit IS NULL OR ac1.score_potassium IS NULL OR ac1.score_sodium IS NULL OR
               ac1.score_creatinine IS NULL OR ac1.score_wbc IS NULL OR ac1.score_ph IS NULL OR 
               ac1.score_map IS NULL OR ac1.score_temp IS NULL OR ac1.score_rr IS NULL OR
               ac1.score_hr IS NULL OR ac1.score_gcs IS NULL
          THEN NULL
          ELSE 
            ac1.score_age + ac1.score_hematocrit + ac1.score_potassium + ac1.score_sodium +
            ac1.score_creatinine + ac1.score_wbc + ac1.score_ph + ac1.score_map + 
            ac1.score_temp + ac1.score_rr + ac1.score_hr + ac1.score_gcs+ ac1.score_oxygenation
        END
      WHEN ac2.score_age IS NOT NULL THEN
        CASE
          WHEN ac2.score_hematocrit IS NULL OR ac2.score_potassium IS NULL OR ac2.score_sodium IS NULL OR
               ac2.score_creatinine IS NULL OR ac2.score_wbc IS NULL OR ac2.score_ph IS NULL OR 
               ac2.score_map IS NULL OR ac2.score_temp IS NULL OR ac2.score_rr IS NULL OR
               ac2.score_hr IS NULL OR ac2.score_gcs IS NULL
          THEN NULL
          ELSE 
            ac2.score_age + ac2.score_hematocrit + ac2.score_potassium + ac2.score_sodium +
            ac2.score_creatinine + ac2.score_wbc + ac2.score_ph + ac2.score_map + 
            ac2.score_temp + ac2.score_rr + ac2.score_hr + ac2.score_gcs+ ac2.score_oxygenation
        END
      WHEN ac3.score_age IS NOT NULL THEN
        CASE
          WHEN ac3.score_hematocrit IS NULL OR ac3.score_potassium IS NULL OR ac3.score_sodium IS NULL OR
               ac3.score_creatinine IS NULL OR ac3.score_wbc IS NULL OR ac3.score_ph IS NULL OR 
               ac3.score_map IS NULL OR ac3.score_temp IS NULL OR ac3.score_rr IS NULL OR
               ac3.score_hr IS NULL OR ac3.score_gcs IS NULL
          THEN NULL
          ELSE 
            ac3.score_age + ac3.score_hematocrit + ac3.score_potassium + ac3.score_sodium +
            ac3.score_creatinine + ac3.score_wbc + ac3.score_ph + ac3.score_map + 
            ac3.score_temp + ac3.score_rr + ac3.score_hr + ac3.score_gcs+ ac3.score_oxygenation
        END
      ELSE NULL
    END
  FROM
    APACHE_components ac1
    LEFT JOIN APACHE_components ac2 ON ac2.new_hosp_id = RICD_dynamic.new_hosp_id AND ac2.post_admission_days = RICD_dynamic.post_admission_days + 1
    LEFT JOIN APACHE_components ac3 ON ac3.new_hosp_id = RICD_dynamic.new_hosp_id AND ac3.post_admission_days = RICD_dynamic.post_admission_days + 2
  WHERE 
    ac1.new_hosp_id = RICD_dynamic.new_hosp_id 
    AND ac1.post_admission_days = RICD_dynamic.post_admission_days
)
WHERE post_admission_days % 7 = 0;


ALTER TABLE RICD_dynamic RENAME COLUMN APACHE_II TO APACHE_II_calculated;
ALTER TABLE RICD_dynamic ADD COLUMN APACHE_II_stated INTEGER;
UPDATE RICD_dynamic AS r
SET APACHE_II_stated = (
  SELECT s.result
  FROM all_scales AS s
  WHERE s.new_hosp_id = r.new_hosp_id
    AND s.post_admission_days = r.post_admission_days
    AND s.scale_rus = 'APACHE II'
  LIMIT 1
);

ALTER TABLE ricd_dynamic ADD COLUMN APACHE_II_united INTEGER;

UPDATE ricd_dynamic
SET APACHE_II_united = COALESCE(APACHE_II_stated, APACHE_II_calculated);


-- NUTRIC
ALTER TABLE ricd_dynamic ADD COLUMN NUTRIC INTEGER;

CREATE TEMP TABLE temp_patient_info AS
SELECT 
    new_hosp_id,
    CASE 
        WHEN age < 50 THEN 0
        WHEN age BETWEEN 50 AND 74 THEN 1
        ELSE 2
    END AS age_score,
    CASE 
        WHEN icu_length_of_stay = 0 THEN 0
        ELSE 1
    END AS icu_stay_score
FROM all_patients;

CREATE TEMP TABLE temp_comorbidities AS
SELECT 
    new_hosp_id,
    CASE 
        WHEN (
            (CASE WHEN "ischemic stroke" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "hemorrhagic stroke" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "traumatic brain injury" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN anemia = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN diabetis_1_type = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN diabetis_2_type = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN cerebrovascular_disease = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN chronic_kidney_disease = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "COPD" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN pneumonia = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "myocardial_infarction" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN coronary_artery_disease = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "atrial_fibrillation" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "arterial hypertension" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "coagulopathy" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "inflammatory_diseases_CNS" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "polyneuropathy" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "heart_failure" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "valvular_heart_disease" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "mental_cognitive_disorders" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "polytrauma" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "malignant_tumor" = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN multiorgan_failure_admission = 'Yes' THEN 1 ELSE 0 END) +
            (CASE WHEN "brain_disorders" = 'Yes' THEN 1 ELSE 0 END)
        ) >= 2 THEN 1
        ELSE 0
    END AS comorbidity_score
FROM processed_data;

UPDATE ricd_dynamic AS r
SET NUTRIC = (
    SELECT 
        CASE 
            WHEN a.APACHE_II_united IS NULL OR s.SOFA IS NULL OR tpi.age_score IS NULL OR tpi.icu_stay_score IS NULL OR tc.comorbidity_score IS NULL THEN NULL
            ELSE 
                (CASE 
                    WHEN a.APACHE_II_united < 15 THEN 0
                    WHEN a.APACHE_II_united BETWEEN 15 AND 19 THEN 1
                    WHEN a.APACHE_II_united BETWEEN 20 AND 27 THEN 2
                    ELSE 3
                END) + 
                (CASE 
                    WHEN s.SOFA < 6 THEN 0
                    WHEN s.SOFA BETWEEN 6 AND 9 THEN 1
                    ELSE 2
                END) +
                tpi.age_score +
                tpi.icu_stay_score +
                tc.comorbidity_score
        END
    FROM (
        SELECT r2.APACHE_II_united
        FROM ricd_dynamic r2
        WHERE r2.new_hosp_id = r.new_hosp_id 
          AND r2.post_admission_days <= r.post_admission_days 
          AND r2.post_admission_days >= r.post_admission_days - 14
          AND r2.APACHE_II_united IS NOT NULL
        ORDER BY r2.post_admission_days DESC
        LIMIT 1
    ) AS a,
    (
        SELECT r3.SOFA
        FROM ricd_dynamic r3
        WHERE r3.new_hosp_id = r.new_hosp_id 
          AND r3.post_admission_days <= r.post_admission_days 
          AND r3.post_admission_days >= r.post_admission_days - 7
          AND r3.SOFA IS NOT NULL
        ORDER BY r3.post_admission_days DESC
        LIMIT 1
    ) AS s,
    temp_patient_info AS tpi,
    temp_comorbidities AS tc
    WHERE tpi.new_hosp_id = r.new_hosp_id
      AND tc.new_hosp_id = r.new_hosp_id
);

-- PNI
ALTER TABLE ricd_dynamic ADD COLUMN albumin REAL;
ALTER TABLE ricd_dynamic ADD COLUMN LYM REAL;
ALTER TABLE ricd_dynamic ADD COLUMN PNI REAL;

CREATE TEMPORARY TABLE temp_albumin AS
SELECT 
    new_hosp_id, 
    post_admission_days, 
    MIN(result_num) as min_albumin
FROM lab_data
WHERE parameter_rus = 'Альбумин'
GROUP BY new_hosp_id, post_admission_days;

CREATE INDEX idx_temp_albumin ON temp_albumin(new_hosp_id, post_admission_days);

CREATE TEMPORARY TABLE temp_lym AS
SELECT 
    new_hosp_id, 
    post_admission_days, 
    MIN(result_num) as min_lym
FROM lab_data
WHERE parameter_rus = 'Лимфоциты абс.'
GROUP BY new_hosp_id, post_admission_days;

CREATE INDEX idx_temp_lym ON temp_lym(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET albumin = (
    SELECT min_albumin
    FROM temp_albumin
    WHERE temp_albumin.new_hosp_id = ricd_dynamic.new_hosp_id
    AND temp_albumin.post_admission_days = ricd_dynamic.post_admission_days
);

UPDATE ricd_dynamic
SET LYM = (
    SELECT min_lym
    FROM temp_lym
    WHERE temp_lym.new_hosp_id = ricd_dynamic.new_hosp_id
    AND temp_lym.post_admission_days = ricd_dynamic.post_admission_days
);

DROP TABLE temp_albumin;
DROP TABLE temp_lym;

UPDATE ricd_dynamic
SET LYM = NULL
WHERE LYM > 50;

CREATE TEMPORARY TABLE albumin_extended AS
WITH albumin_data AS (
    SELECT 
        r1.new_hosp_id,
        r1.post_admission_days,
        MIN(r2.albumin) AS nearest_albumin,
        MIN(ABS(r1.post_admission_days - r2.post_admission_days)) AS albumin_day_diff
    FROM ricd_dynamic r1
    JOIN ricd_dynamic r2 ON r1.new_hosp_id = r2.new_hosp_id
        AND r2.albumin IS NOT NULL
        AND ABS(r1.post_admission_days - r2.post_admission_days) <= 2
    GROUP BY r1.new_hosp_id, r1.post_admission_days
)
SELECT 
    new_hosp_id,
    post_admission_days,
    CASE 
        WHEN albumin_day_diff = 0 THEN (SELECT albumin FROM ricd_dynamic 
                                      WHERE new_hosp_id = a.new_hosp_id 
                                      AND post_admission_days = a.post_admission_days)
        ELSE nearest_albumin
    END AS final_albumin,
    albumin_day_diff
FROM albumin_data a;

CREATE INDEX idx_albumin_ext ON albumin_extended(new_hosp_id, post_admission_days);

CREATE TEMPORARY TABLE lym_extended AS
WITH lym_data AS (
    SELECT 
        r1.new_hosp_id,
        r1.post_admission_days,
        MIN(r2.LYM) AS nearest_lym,
        MIN(ABS(r1.post_admission_days - r2.post_admission_days)) AS lym_day_diff
    FROM ricd_dynamic r1
    JOIN ricd_dynamic r2 ON r1.new_hosp_id = r2.new_hosp_id
        AND r2.LYM IS NOT NULL
        AND ABS(r1.post_admission_days - r2.post_admission_days) <= 1
    GROUP BY r1.new_hosp_id, r1.post_admission_days
)
SELECT 
    new_hosp_id,
    post_admission_days,
    CASE 
        WHEN lym_day_diff = 0 THEN (SELECT LYM FROM ricd_dynamic 
                                   WHERE new_hosp_id = l.new_hosp_id 
                                   AND post_admission_days = l.post_admission_days)
        ELSE nearest_lym
    END AS final_lym,
    lym_day_diff
FROM lym_data l;

CREATE INDEX idx_lym_ext ON lym_extended(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic
SET PNI = (
    SELECT (a.final_albumin + 5 * l.final_lym)
    FROM albumin_extended a
    JOIN lym_extended l ON a.new_hosp_id = l.new_hosp_id 
                       AND a.post_admission_days = l.post_admission_days
    WHERE a.new_hosp_id = ricd_dynamic.new_hosp_id
      AND a.post_admission_days = ricd_dynamic.post_admission_days
      AND a.final_albumin IS NOT NULL
      AND l.final_lym IS NOT NULL
      AND (
          (a.albumin_day_diff = 0 AND l.lym_day_diff = 0) OR 
          (a.albumin_day_diff <= 2 AND l.lym_day_diff <= 1)   
      )
);

DROP TABLE albumin_extended;
DROP TABLE lym_extended;

-- Добавление icu
ALTER TABLE ricd_dynamic ADD COLUMN icu TEXT;

CREATE TEMP TABLE temp_icu_mapping AS
SELECT 
    pp.new_hosp_id,
    pp.actual_department_admission_day - 1 AS adjusted_admission_day,
    pp.actual_department_discharge_day - 1 AS adjusted_discharge_day,
    pp.ICU_period
FROM patient_pathway pp
WHERE pp.ICU_period IN ('Yes', 'No');

CREATE INDEX idx_temp_icu_mapping ON temp_icu_mapping(new_hosp_id, adjusted_admission_day, adjusted_discharge_day);
CREATE INDEX idx_ricd_dynamic ON ricd_dynamic(new_hosp_id, post_admission_days);

UPDATE ricd_dynamic AS rd
SET icu = (
    SELECT t.ICU_period
    FROM temp_icu_mapping t
    WHERE t.new_hosp_id = rd.new_hosp_id
    AND rd.post_admission_days BETWEEN t.adjusted_admission_day AND t.adjusted_discharge_day
    LIMIT 1  
);

DROP TABLE temp_icu_mapping;

-- Оценка дня смерти
ALTER TABLE ricd_dynamic ADD COLUMN mortality TEXT;

CREATE TEMP TABLE temp_mortality_mapping AS
SELECT 
    new_hosp_id,
    CASE 
        WHEN fatal_outcome = 'Yes' THEN hospital_length_of_stay - 1
        ELSE 'No'
    END AS mortality_day
FROM all_patients
WHERE fatal_outcome IN ('Yes', 'No');

CREATE INDEX idx_temp_mortality ON temp_mortality_mapping(new_hosp_id);

UPDATE ricd_dynamic AS rd
SET mortality = (
    SELECT t.mortality_day
    FROM temp_mortality_mapping t
    WHERE t.new_hosp_id = rd.new_hosp_id
    LIMIT 1  
);

DROP TABLE temp_mortality_mapping;






