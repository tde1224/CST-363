#GET NUMBER OF APPOINTMENTS A NURSE HAS BEEN ASSIGNED TOO
select CONCAT(n.FirstName," ", n.LastName), count(a.Id) as 'Appointments' from appointments a join doctors d on d.Id = a.DoctorId join nurses n on n.DoctorId = d.Id group by n.Id


#SUB QUERY GET NOTES FROM VISITS WHERE APPOINTMENT WAS A HAND RELATED ISSUE
select v.Notes, (select  a.Notes from appointments a where notes like '%hand%' limit 1) as 'Appointment Notes' from visits v where v.Notes like '%hand%'
 

#GET COUNT OF APPOINTMENTS IN A ROOM THROUGH THE HISTORY (GROUP BY)
SELECT COUNT(Id), RoomNum from visits group by RoomNum


#GET ALL PATIENT NAMES WITH TEMP OVER 99 ON THEIR VISIT
SELECT p.FirstName, p.LastName, v.temp from patients p join appointments a on p.Id = a.patientid join visits v on v.appointmentid = a.id where v.temp > 99 order by v.temp desc

#GET AVG AGE OF ALL PATIENTS
SELECT AVG(YEAR(NOW())-YEAR(dob)) as `Average` FROM patients;


#View Patient/Doctor Assignments based on appointment notes
SELECT CONCAT(patients.FirstName," ", patients.LastName) AS 'Patient Name', doctors.LastName AS 'Doctor LastName', doctors.Specialty
FROM patients JOIN appointments ON patients.Id = appointments.PatientId 
JOIN doctors ON doctors.Id = patients.PrimaryDoctorId
WHERE appointments.notes LIKE '%fracture%'


#View Patients Assigned to Doctors of the Opposite Sex    
SELECT CONCAT(patients.FirstName," ", patients.LastName) AS 'Patient Name', patients.sex, CONCAT(doctors.FirstName, " ", doctors.LastName) AS 'Doctor Name', doctors.sex
FROM 
patients JOIN doctors ON patients.primaryDoctorid = doctors.id
   WHERE patients.sex != doctors.sex;
   
   
#Create Visit Log View
CREATE OR REPLACE VIEW VisitLog AS 
SELECT DISTINCT appointments.AppointmentDateTime AS 'Appointment Time', 
   CONCAT(doctors.FirstName, " ", doctors.LastName) AS 'Doctor', 
   CONCAT(nurses.FirstName, " ", nurses.LastName) AS 'Nurse',
CONCAT(patients.FirstName, " ", patients.LastName) AS 'Patient',
   visits.RoomNum, 
   visits.notes
FROM 
appointments JOIN doctors ON appointments.DoctorId = doctors.Id
   JOIN nurses ON nurses.doctorId = doctors.Id
   JOIN patients ON patients.PrimaryDoctorId = doctors.Id
   JOIN visits ON visits.AppointmentId = appointments.id;
   
   
#Stored Procedure to look at a single Doctor's appointments
   DELIMITER //
   CREATE PROCEDURE AppointmentsForDoctor(IN DoctorLastName VARCHAR(50))
   BEGIN
SELECT appointments.AppointmentDateTime, Doctors.LastName, Patients.LastName
       FROM appointments JOIN Doctors ON appointments.doctorId = doctors.id
       JOIN Patients ON patients.id = appointments.PatientId
       WHERE doctors.LastName = DoctorLastName AND appointments.Cancelled IS FALSE
       ORDER BY appointments.AppointmentDateTime DESC;
       
END //
    
    DELIMITER ;
CALL AppointmentsForDoctor('Elner');
