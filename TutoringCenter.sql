-- Schema
CREATE SCHEMA IF NOT EXISTS tutoring_center;
USE tutoring_center;

-- Core tables
CREATE TABLE Student (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name  VARCHAR(50) NOT NULL,
  email      VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE Tutor (
  tutor_id   INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name  VARCHAR(50) NOT NULL,
  email      VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE Subject (
  subject_id INT AUTO_INCREMENT PRIMARY KEY,
  code       VARCHAR(20) NOT NULL UNIQUE,   -- e.g., CIS1115
  title      VARCHAR(120) NOT NULL
);

CREATE TABLE Room (
  room_id     INT AUTO_INCREMENT PRIMARY KEY,
  building    VARCHAR(50) NOT NULL,
  room_number VARCHAR(20) NOT NULL,
  capacity    INT NOT NULL,
  UNIQUE (building, room_number)
);

-- M:N bridges
CREATE TABLE Enrollment (
  enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id    INT NOT NULL,
  subject_id    INT NOT NULL,
  created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (student_id, subject_id),
  FOREIGN KEY (student_id) REFERENCES Student(student_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Teaches (
  teach_id   INT AUTO_INCREMENT PRIMARY KEY,
  tutor_id   INT NOT NULL,
  subject_id INT NOT NULL,
  UNIQUE (tutor_id, subject_id),
  FOREIGN KEY (tutor_id) REFERENCES Tutor(tutor_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Appointment (associative entity with its own attributes)
CREATE TABLE Appointment (
  appt_id    INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  tutor_id   INT NOT NULL,
  subject_id INT NOT NULL,
  room_id    INT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time   DATETIME NOT NULL,
  status     ENUM('Scheduled','Completed','Cancelled','NoShow') NOT NULL DEFAULT 'Scheduled',
  notes      VARCHAR(500),

  FOREIGN KEY (student_id) REFERENCES Student(student_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (tutor_id)   REFERENCES Tutor(tutor_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (room_id)    REFERENCES Room(room_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  -- double-booking guards
  UNIQUE KEY uq_tutor_slot   (tutor_id,   start_time),
  UNIQUE KEY uq_student_slot (student_id, start_time),
  UNIQUE KEY uq_room_slot    (room_id,    start_time),

  CHECK (end_time > start_time)
);

-- Sample data (small but realistic)
INSERT INTO Student(first_name,last_name,email) VALUES
('Amina','Diallo','amina@school.edu'),
('Luis','Munoz','luis@school.edu');

INSERT INTO Tutor(first_name,last_name,email) VALUES
('Sara','Ng','sng@school.edu'),
('Omar','Khan','okhan@school.edu');

INSERT INTO Subject(code,title) VALUES
('CIS1115','Prog. Fundamentals (Java)'),
('CIS344','Database Systems');

INSERT INTO Room(building,room_number,capacity) VALUES
('Science','204',20), ('Library','1A',8);

INSERT INTO Teaches(tutor_id,subject_id) VALUES (1,1),(1,2),(2,1);
INSERT INTO Enrollment(student_id,subject_id) VALUES (1,1),(1,2),(2,1);

INSERT INTO Appointment(student_id,tutor_id,subject_id,room_id,start_time,end_time,status)
VALUES
(1,1,1,1,'2025-10-01 10:00:00','2025-10-01 11:00:00','Scheduled'),
(2,2,1,2,'2025-10-01 10:00:00','2025-10-01 11:00:00','Scheduled');

-- Example queries for your report
-- 1) Upcoming sessions with names and room
SELECT a.appt_id, a.start_time, s.first_name AS student, t.first_name AS tutor,
       sub.code, CONCAT(r.building,' ',r.room_number) AS room
FROM Appointment a
JOIN Student s ON a.student_id = s.student_id
JOIN Tutor   t ON a.tutor_id   = t.tutor_id
JOIN Subject sub ON a.subject_id = sub.subject_id
JOIN Room r ON a.room_id = r.room_id
WHERE a.start_time >= NOW()
ORDER BY a.start_time;

-- 2) Tutor load by subject
SELECT t.first_name, sub.code, COUNT(*) AS sessions
FROM Appointment a
JOIN Tutor t ON a.tutor_id = t.tutor_id
JOIN Subject sub ON a.subject_id = sub.subject_id
GROUP BY t.tutor_id, sub.subject_id
ORDER BY sessions DESC;
