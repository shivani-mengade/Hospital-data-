/* Dr. speciality /*
SELECT CONCAT(first_name, " ", last_name) AS name, specialty
FROM doctors;

/* Unpaid amount and name of patient/*
SELECT CONCAT(first_name, " ", last_name) AS patient_name, amount
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN treatments t ON a.appointment_id = t.appointment_id
JOIN billing b ON t.treatment_id = b.treatment_id
WHERE payment_status = 'Unpaid';

/* Patient name and diagnosis /*
SELECT  CONCAT(first_name, " ", last_name) AS patient_name, diagnosis
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id
JOIN billing b ON t.treatment_id = b.treatment_id
JOIN patients p ON a.patient_id = p.patient_id
WHERE diagnosis = 'Diabetes'
GROUP BY patient_name;

/* Scheduled emergency visits by patients name/*
SELECT CONCAT(first_name, " ", last_name) AS name, status, reason
FROM patients p 
JOIN appointments a ON p.patient_id = a.patient_id
WHERE status = 'Scheduled' AND reason = 'Emergency Visit'; 

/* Doctor appointment date n time /*
SELECT CONCAT(first_name, " ", last_name) AS Drname, appointment_date, time_format(appointment_time, '%h:%i') AS appointment_time
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id;


/* Female patients name and diagnosis /*
SELECT CONCAT(first_name, " ", last_name) AS patients_name, gender, diagnosis
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN treatments t ON a.appointment_id = t.appointment_id
WHERE gender = 'f'
ORDER BY diagnosis;

/*Total appointment/*
SELECT COUNT(appointment_date) AS appointments
FROM appointments;

/*Appointment completed/*
SELECT (SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END)* 100.0) /
         COUNT(*) AS competed_percent
FROM appointments;   

/* Patient per Dr. /*
SELECT d.doctor_id, CONCAT(d.first_name, " ", d.last_name) AS name, COUNT(p.patient_id) AS patients
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id 
JOIN patients p ON a.patient_id = p.patient_id
GROUP BY d.doctor_id, name;

/* New VS returning /*
SELECT patient_type, COUNT(*) AS count_patients
FROM ( SELECT patient_id,
    CASE WHEN COUNT(DISTINCT appointment_id) = 1 THEN 'new_patient'
	ELSE 'returning' END AS patient_type
FROM appointments
GROUP BY patient_id) AS sub
GROUP BY patient_type;


/* most common diagnosis /*
SELECT diagnosis, COUNT(*) AS count
FROM treatments
GROUP BY diagnosis
ORDER BY count DESC;

/* Outstanding bills /*
SELECT ROUND(SUM(amount),8) AS outstanding_amount
FROM billing
WHERE payment_status = 'Unpaid';

/* Dr. utilization rate/*
SELECT doctor_id,
(SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS dr_utility_rate
FROM appointments
GROUP BY doctor_id;