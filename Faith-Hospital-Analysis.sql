
--CREATE PATIENT DETAILS TABLE

CREATE TABLE patient_details(
pt_id INT PRIMARY KEY,
Name VARCHAR(50),
Age VARCHAR(20),
Sex VARCHAR(1),
Occupation VARCHAR(30),
Level_of_education VARCHAR(30),
Marital_status VARCHAR(30)
);
SELECT * FROM patient_details;
ALTER TABLE patient_details
ALTER COLUMN age TYPE INT USING age::INT;

ALTER TABLE patient_details
ALTER COLUMN sex TYPE VARCHAR(10);

UPDATE patient_details
SET sex = CASE
		WHEN LOWER(TRIM(sex)) = 'm' THEN 'M'
		WHEN LOWER(TRIM(sex)) = 'f' THEN 'F'
		ELSE 'Unknown'
END
		


SELECT * FROM patient_details;

--CREATE ADMISSION DETAILS TABLE
CREATE TABLE admission_details(
pt_id INT REFERENCES patient_details (pt_id),
admission_id INT PRIMARY KEY,
admission_duration INT,
doctor_id VARCHAR (20),
dama VARCHAR(10),
reason_for_dama VARCHAR(50),
dead VARCHAR (10),
cause_of_death VARCHAR(50),
ckd VARCHAR(10),
cause_ckd VARCHAR(50),
dialysis VARCHAR(10),
no_of_sessions INT,
stroke VARCHAR(10),
dm VARCHAR(10),
cancer VARCHAR(10),
type_of_cancer VARCHAR(50),
pud VARCHAR(10)
);

ALTER TABLE admission_details
ADD FOREIGN KEY (doctor_id)
REFERENCES doctors(doctor_id);

UPDATE admission_details 
	SET cause_of_death =TRIM(cause_of_death)

SELECT * FROM admission_details;
--CREATE DOCTORS' TABLE
CREATE TABLE doctors(
doctor_id VARCHAR(20) PRIMARY KEY,
doctor VARCHAR(50),
gender VARCHAR(1),
email VARCHAR(50),
specialization VARCHAR(50)
);

SELECT * FROM doctors;

--CREATE RISK FACTOR TABLE
CREATE TABLE risk_factor(
pt_id INT REFERENCES patient_details (pt_id),
alcohol_hx VARCHAR(10),
tobacco_hx VARCHAR(10),
nsaid_use VARCHAR(10)
);

SELECT * FROM risk_factor;
SELECT * FROM patient_details;

--total admitted patients
SELECT
		count (*) as total_admitted_patients
FROM patient_details p
JOIN admission_details a ON p.pt_id = a.pt_id

SELECT * FROM admission_details

--ANALYZE PATIENT DEMOGRAPHICS IN RELATION TO HOSPITAL OUTCOMES
--TOTAL PATIENTS BY DIAGNOSIS
--CKD
SELECT 
		count(*) as total_ckd_patients
FROM patient_details p
JOIN admission_details a ON p.pt_id = a.pt_id 
WHERE a.ckd = 'Yes'
--STROKE
SELECT 
		count(*) as total_stroke_patients
FROM patient_details p
JOIN admission_details a ON p.pt_id = a.pt_id 
WHERE a.stroke = 'Yes'
--DM
SELECT 
		count(*) as total_dm_patients
FROM patient_details p
JOIN admission_details a ON p.pt_id = a.pt_id 
WHERE a.dm = 'Yes'

--CANCER
SELECT 
		count(*) as total_cancer_patients
FROM patient_details p
JOIN admission_details a ON p.pt_id = a.pt_id 
WHERE a.cancer = 'Yes'
---PUD
SELECT
		count(*) as total_pud_patients
FROM patient_details p
JOIN admission_details a ON p.pt_id = a.pt_id 
WHERE a.pud = 'Yes'

--COUNT OF PATIENTS BY GENDER
select sex,
count(pt_id) as count_by_gender
from patient_details
group by sex

--TOTAL DEATH CASES
SELECT
		count(*) as total_mortality
FROM patient_details p
JOIN admission_details a ON p.pt_id = a.pt_id 
WHERE a.dead = 'Yes'


--AGE GROUP ANALYSIS
--TOTAL ADMISSIONS PER AGE GROUP
SELECT
		--count (a.admission_id) as total_admissions,
		case
		when p.age between 13 and 19 then 'teenagers'
		when p.age between 20 and 39 then 'young adults'
		when p.age between 40 and 59 then 'middle-aged adults'
		else 'senior adults'
		end as age_group,
		count (a.admission_id) as total_admissions
from admission_details a
left join patient_details p on a.pt_id = p.pt_id
--where a.ckd = 'Yes'
group by age_group
order by total_admissions desc

LENGTH OF STAY
SELECT
		case
		when p.age between 13 and 19 then 'Teenagers'
		when p.age between 20 and 39 then 'Young adults'
		when p.age between 40 and 59 then 'Middle-Aged Adults'
		else 'Senior Adults'
		end as age_group,
		round(avg(a.admission_duration)) AS avg_length_of_stay
		--count (a.admission_id) as total_admissions
from admission_details a
left join patient_details p on a.pt_id = p.pt_id
--where a.ckd = 'Yes'
group by age_group
order by avg_length_of_stay desc


--MORTALITY CASES BY AGE GROUP
SELECT 
		case
		when p.age between 13 and 19 then 'teenagers'
		when p.age between 20 and 39 then 'young adults'
		when p.age between 40 and 59 then 'middle-aged adults'
		else 'senior adults'
		end as age_group,
		count (*) as mortality_cases
from admission_details a
left join patient_details p on a.pt_id = p.pt_id
where a.dead = 'Yes'
group by 
		age_group
order by mortality_cases desc

--WHAT IS THE LEADING CAUSE OF DEATH
SELECT cause_of_death,
		count(*) as total_cases
FROM admission_details
WHERE cause_of_death IS NOT NULL AND TRIM(cause_of_death) <> ''
GROUP BY cause_of_death
ORDER BY total_cases DESC
LIMIT 10

--MOST PROMINENT CONDITION AMONG EACH AGE GROUP
--ckd
SELECT 
		case
		when p.age between 13 and 19 then 'teenagers'
		when p.age between 20 and 39 then 'young adults'
		when p.age between 40 and 59 then 'middle-aged adults'
		else 'senior adults'
		end as age_group,
		count (*) as admission_per_medical_condition
from admission_details a
left join patient_details p on a.pt_id = p.pt_id
where a.ckd = 'Yes'
group by 
		age_group
order by admission_per_medical_condition desc

--stroke
SELECT 
		case
		when p.age between 13 and 19 then 'teenagers'
		when p.age between 20 and 39 then 'young adults'
		when p.age between 40 and 59 then 'middle-aged adults'
		else 'senior adults'
		end as age_group,
		count (*) as admission_per_medical_condition
from admission_details a
left join patient_details p on a.pt_id = p.pt_id
where a.stroke = 'Yes'
group by 
		age_group
order by admission_per_medical_condition desc

--dm
SELECT 
		case
		when p.age between 13 and 19 then 'teenagers'
		when p.age between 20 and 39 then 'young adults'
		when p.age between 40 and 59 then 'middle-aged adults'
		else 'senior adults'
		end as age_group,
		count (*) as admission_per_medical_condition
from admission_details a
left join patient_details p on a.pt_id = p.pt_id
where a.dm = 'Yes'
group by 
		age_group
order by admission_per_medical_condition desc

--cancer
SELECT 
		case
		when p.age between 13 and 19 then 'teenagers'
		when p.age between 20 and 39 then 'young adults'
		when p.age between 40 and 59 then 'middle-aged adults'
		else 'senior adults'
		end as age_group,
		count (*) as admission_per_medical_condition
from admission_details a
left join patient_details p on a.pt_id = p.pt_id
where a.cancer = 'Yes'
group by 
		age_group
order by admission_per_medical_condition desc
--pud
SELECT 
		case
		when p.age between 13 and 19 then 'teenagers'
		when p.age between 20 and 39 then 'young adults'
		when p.age between 40 and 59 then 'middle-aged adults'
		else 'senior adults'
		end as age_group,
		count (*) as admission_per_medical_condition
from admission_details a
left join patient_details p on a.pt_id = p.pt_id
where a.pud = 'Yes'
group by 
		age_group
order by admission_per_medical_condition desc
--IDENTIFY COMMON REASONS FOR DISCHARGE AGAINST MEDICAL CONDITION(DAMA).
SELECT 
		reason_for_dama,
		COUNT (pt_id) AS total_cases
FROM admission_details
WHERE dama = 'Yes'
GROUP BY reason_for_dama
ORDER BY total_cases DESC

SELECT 
		reason_for_dama,
		COUNT (a.pt_id) AS total_cases
FROM admission_details a
JOIN patient_details p ON a.pt_id = p.pt_id
WHERE dama = 'Yes'
GROUP BY reason_for_dama
ORDER BY total_cases DESC

--EXAMINE THE PREVALENCE AND IMPACT OF CHRONIC ILLNESSES AMONG PATIENTS
--which condition recorded the highest deaths
SELECT  'ckd' as condition,
		count(*) as total_ckd_patients,
		COUNT(dead) filter(where dead = 'Yes')	as total_deaths
FROM patient_details p
JOIN admission_details a ON p.pt_id = a.pt_id 
WHERE a.ckd = 'Yes'

SELECT  'stroke' as condition,
		count(*) as total_stroke_patients,
		COUNT(dead) filter(where dead = 'Yes')	as total_deaths
FROM patient_details p
JOIN admission_details a ON p.pt_id = a.pt_id 
WHERE a.stroke= 'Yes'

SELECT  'dm' as condition,
		count(*) as total_dm_patients,
		COUNT(dead) filter(where dead = 'Yes')	as total_deaths
FROM patient_details p
JOIN admission_details a ON p.pt_id = a.pt_id 
WHERE a.dm= 'Yes'

SELECT  'cancer' as condition,
		count(*) as total_cancer_patients,
		COUNT(dead) filter(where dead = 'Yes')	as total_deaths
FROM patient_details p
JOIN admission_details a ON p.pt_id = a.pt_id 
WHERE a.cancer= 'Yes'

SELECT  'pud' as condition,
		count(*) as total_pud_patients,
		COUNT(dead) filter(where dead = 'Yes')	as total_deaths
FROM patient_details p
JOIN admission_details a ON p.pt_id = a.pt_id 
WHERE a.pud= 'Yes'


--EVALUATE THE IMPORTANCE OF THE DOCTORS BASED ON PATIENT OUTCOMES SPECIALIZATION AND WORKLOAD
SELECT
		COUNT(distinct doctor_id) AS TOTAL_DOCTORS
FROM doctors

--COUNT OF DOCTORS BY GENDER
select gender,
count(distinct doctor_id) as doctors_count
from doctors
group by gender

--NUMBER OF DOCTORS PER SPECIALIZATION
SELECT 	--doctor_id,
		--doctor,
		specialization,
COUNT (*) AS DOCTORS_PER_DEPT
FROM DOCTORS
GROUP BY SPECIALIZATION---,doctor_id
ORDER BY DOCTORS_PER_DEPT DESC

--SHOW THE DEPARTMENT THAT RFECORDED THE HIGHEST ADMISSION
SELECT
		d.specialization,
		COUNT(*) AS TOTAL_ADMISSIONS
FROM admission_details a
JOIN doctors d ON a.doctor_id = d.doctor_id
group by d.specialization
ORDER BY total_admissions desc

--SPECIALIZATION WITH THE HIGHEST AVERAGE ADMISSION DURATION
SELECT 
		d.specialization,
		ROUND(avg(a.admission_duration)) AS avg_admission_duration
FROM admission_details a
LEFT JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.specialization
ORDER BY avg_admission_duration DESC

SELECT 
		d.doctor,
		ROUND(avg(a.admission_duration)) AS avg_admission_duration
FROM admission_details a
LEFT JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor
ORDER BY avg_admission_duration DESC

--COUNT OF PATIENTS HANDLED BY EACH DOCTOR
SELECT doctor from doctors

SELECT 	d.doctor_id,
		d.doctor,
		count (a.pt_id) AS total_patient_per_doctor
FROM doctors d
JOIN admission_details a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor
ORDER BY total_patient_per_doctor DESC
--------------
--PATIENTS PER DOCTOR
SELECT d.doctor,
		count (a.pt_id) AS total_patient_per_doctor
FROM doctors d
JOIN admission_details a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id
ORDER BY total_patient_per_doctor DESC

--Total mortality cases per doctor 

SELECT d.doctor,
		count (a.dead) AS total_deaths_per_doctor
FROM doctors d
JOIN admission_details a ON d.doctor_id = a.doctor_id
WHERE a.dead = 'Yes'
GROUP BY d.doctor
ORDER BY total_deaths_per_doctor DESC


--IMPACT OF LIFESTYLE FACTORS ON HOSPITAL OUTCOME
--TOTAL ALCOHOLICS
SELECT 
		count(*) as total_alcoholics
FROM patient_details p
JOIN risk_factor r ON p.pt_id = r.pt_id 
WHERE r.alcohol_hx = 'Yes'

--TOTAL TOBACCO SMOKERS
SELECT 
		count(*) as total_tobacco_smokers
FROM patient_details p
JOIN risk_factor r ON p.pt_id = r.pt_id 
WHERE r.tobacco_hx = 'Yes'

--TOTAL NSAID USERS
SELECT 
		count(*) as total_NSAID_USERS
FROM patient_details p
JOIN risk_factor r ON p.pt_id = r.pt_id 
WHERE r.nsaid_use = 'Yes'

--ALCOHOLIC CKD PATIENTS
PREVALENCE OF ALCOHOL IN CKD PATIENTS
SELECT r.alcohol_hx,
		count(a.pt_id) AS total_patients,
		count(a.ckd) filter (where a.ckd = 'Yes') AS ckd_prevalence,
		round(100 * count(a.ckd) filter (where a.ckd = 'Yes') ::numeric / count(a.pt_id), 2) AS ckd_prevalence_percentage
FROM patient_details p
JOIN risk_factor r ON p.pt_id = r.pt_id 
JOIN admission_details a ON r.pt_id = a.pt_id
WHERE r.alcohol_hx IN ('Yes', 'No')
GROUP BY r.alcohol_hx 

--IN RELATION TO ADMISSION DURATION AND MORTALITY CASES 
--ALCOHOL
SELECT r.alcohol_hx,
		count(a.pt_id) AS total_patients,
		round(avg(a.admission_duration)) AS avg_length_of_stay,
		count(a.dead) filter (where a.dead = 'Yes') AS deaths,
		round(100 *count(a.dead) filter (where a.dead = 'Yes') ::numeric / count(a.pt_id), 2) || '%' AS mortality_rate_percentage
FROM patient_details p
JOIN risk_factor r ON p.pt_id = r.pt_id 
JOIN admission_details a ON r.pt_id = a.pt_id
WHERE r.alcohol_hx IN ('Yes', 'No')
GROUP BY r.alcohol_hx 

--TOBACCO
SELECT r.tobacco_hx,
		count(a.pt_id) AS total_patients,
		round(avg(a.admission_duration)) AS avg_length_of_stay,
		count(a.dead) filter (where a.dead = 'Yes') AS deaths,
		round(100 *count(a.dead) filter (where a.dead = 'Yes') ::numeric / count(a.pt_id), 2) AS mortality_rate
FROM patient_details p
JOIN risk_factor r ON p.pt_id = r.pt_id 
JOIN admission_details a ON r.pt_id = a.pt_id
WHERE r.tobacco_hx IN ('Yes', 'No')
GROUP BY r.tobacco_hx 

---NSAID USE
SELECT r.nsaid_use,
		count(a.pt_id) AS total_patients,
		round(avg(a.admission_duration)) AS avg_length_of_stay,
		count(a.dead) filter (where a.dead = 'Yes') AS deaths,
		round(100 *count(a.dead) filter (where a.dead = 'Yes') ::numeric / count(a.pt_id), 2) AS mortality_rate
FROM patient_details p
JOIN risk_factor r ON p.pt_id = r.pt_id 
JOIN admission_details a ON r.pt_id = a.pt_id
WHERE r.nsaid_use IN ('Yes', 'No')
GROUP BY r.nsaid_use



