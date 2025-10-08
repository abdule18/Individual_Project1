# 🎓 Campus Tutoring Center Database Project

## 📘 Overview
The **Campus Tutoring Center** project is a relational database system designed to manage tutoring operations efficiently.  
It connects **students**, **tutors**, **subjects**, and **rooms** through a central **appointment scheduling system** that prevents double-booking conflicts.

This project was created in **MySQL Workbench** and includes both **Chen ER** and **UML (EER)** diagrams, along with a detailed design report and SQL schema.

---

## 🧩 Features
- Manage student and tutor profiles with unique emails.
- Register subjects offered by the tutoring center.
- Assign tutors to multiple subjects.
- Allow students to enroll in multiple subjects.
- Schedule tutoring appointments between students and tutors by subject and room.
- Automatically prevent double-booking for tutors, students, and rooms.
- Track appointment details such as start time, end time, status, and notes.

---

## 🧠 System Design Summary

### Entities
- **Student** (student_id, first_name, last_name, email)
- **Tutor** (tutor_id, first_name, last_name, email)
- **Subject** (subject_id, code, title)
- **Room** (room_id, building, room_number, capacity)
- **Appointment** (appt_id, student_id, tutor_id, subject_id, room_id, start_time, end_time, status, notes)
- **Enrollment** (enrollment_id, student_id, subject_id, created_at)
- **Teaches** (teach_id, tutor_id, subject_id)

### Key Relationships
- **Student –< Enrollment >– Subject** (M:N)
- **Tutor –< Teaches >– Subject** (M:N)
- **Student, Tutor, Subject, Room –< Appointment** (1:M relationships)
- **Constraints**:
  - Prevent double-booking using composite UNIQUE keys.
  - Enforce referential integrity with ON DELETE / ON UPDATE rules.

---

## 🧱 Technologies Used
- **MySQL Workbench** (for modeling and schema generation)
- **MySQL Server** (for database implementation)
- **Chen ER Model** (for conceptual design)
- **UML/EER Diagram** (for logical and physical design)
- **Microsoft Word / PDF** (for process documentation and final report)

---
