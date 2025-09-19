# Campus Tutoring Center (CIS 344 Project)

## Overview
A simplified tutoring scheduling system for a campus. Students enroll in subjects and book 1-hour sessions with tutors.

## Contents
- `docs/requirements-notes.pdf`: process & requirements
- `docs/er-chen-scan.jpg`: Chen ER (hand-drawn)
- `docs/er-uml.png`: UML ER (from Workbench)
- `db/tutoring_center.mwb`: MySQL Workbench model
- `db/tutoring_center.sql`: DDL + sample data
- `report/final-report.pdf`: final write-up

## How to run
1. Open MySQL Workbench → File → Open Model → `db/tutoring_center.mwb`
2. Database → Forward Engineer → generate and run the script, or:
3. `db/tutoring_center.sql` → open in a SQL editor connected to MySQL → Run All.

## Notes
- Unique constraints prevent double-booking a tutor, student, or room for the same start time.
- Example queries included at the bottom of the SQL file.

