#CREATE SCHEMA 
CREATE DATABASE IF NOT EXISTS `medicalfacility` ;

#DEFAULT DATABASE SELECT
USE medicalfacility;

#CREATE DOCTORS TABLE
CREATE TABLE IF NOT EXISTS medicalfacility.`doctors` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(45) NOT NULL,
  `LastName` varchar(45) NOT NULL,
  `Specialty` varchar(250) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Sex` varchar(1) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `doctorid_UNIQUE` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#CREATE NURSES TABLE
CREATE TABLE IF NOT EXISTS medicalfacility.`nurses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(45) NOT NULL,
  `LastName` varchar(45) NOT NULL,
  `DoctorId` int(11) NOT NULL,
  `Sex` varchar(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `DoctorId_idx` (`DoctorId`),
  CONSTRAINT `NurseDoctorId` FOREIGN KEY (`DoctorId`) REFERENCES `doctors` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#CREATE PATIENTS TABLE
CREATE TABLE IF NOT EXISTS medicalfacility.`patients` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(45) NOT NULL,
  `LastName` varchar(45) NOT NULL,
  `DOB` datetime NOT NULL,
  `Sex` varchar(1) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `PhoneNumber` varchar(45) NOT NULL,
  `PrimaryDoctorId` int(11) DEFAULT NULL,
  UNIQUE KEY `Id_UNIQUE` (`Id`),
  KEY `PrimaryCareDoctorId_idx` (`PrimaryDoctorId`),
  CONSTRAINT `PrimaryCareDoctorId` FOREIGN KEY (`PrimaryDoctorId`) REFERENCES `doctors` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



#CREATE APPOINTMENTS TABLE
CREATE TABLE IF NOT EXISTS medicalfacility.`appointments` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `AppointmentDateTime` datetime DEFAULT NULL,
  `PatientId` int(11) NOT NULL,
  `DoctorId` int(11) NOT NULL,
  `Notes` varchar(250) DEFAULT NULL,
  `Cancelled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  KEY `DoctorId_idx` (`DoctorId`),
  KEY `PatientId_idx` (`PatientId`),
  CONSTRAINT `AppointmentDoctorId` FOREIGN KEY (`DoctorId`) REFERENCES `doctors` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `AppointmentPatientId` FOREIGN KEY (`PatientId`) REFERENCES `patients` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#CREATE VISITS TABLE
CREATE TABLE IF NOT EXISTS medicalfacility.`visits` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Notes` varchar(250) DEFAULT NULL,
  `AppointmentId` int(11) NOT NULL,
  `RoomNum` int(11) NOT NULL,
  `Temp` decimal(3,1) NOT NULL,
  `Pulse` int(11) NOT NULL,
  `BP` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Id_UNIQUE` (`Id`),
  KEY `VisitAppointmentId_idx` (`AppointmentId`),
  CONSTRAINT `VisitAppointmentId` FOREIGN KEY (`AppointmentId`) REFERENCES `appointments` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

