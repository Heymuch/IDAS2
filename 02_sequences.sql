-- ||| SEKVENCE
DROP SEQUENCE users_id_seq;
DROP SEQUENCE pmsgs_id_seq;
DROP SEQUENCE students_id_seq;
DROP SEQUENCE courses_id_seq;
DROP SEQUENCE teachers_id_seq;
DROP SEQUENCE grades_id_seq;
DROP SEQUENCE groups_id_seq;
DROP SEQUENCE classrooms_id_seq;
DROP SEQUENCE gmsgs_id_seq;
DROP SEQUENCE timetables_id_seq;
DROP SEQUENCE comments_id_seq;
DROP SEQUENCE files_id_seq;

CREATE SEQUENCE users_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE pmsgs_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE students_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE courses_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE teachers_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE grades_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE groups_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE classrooms_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE gmsgs_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE timetables_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE comments_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE files_id_seq START WITH 1 INCREMENT BY 1;