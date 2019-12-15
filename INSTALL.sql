-- *********************************************************************************************************************
-- *********************************************************************************************************************
-- TABULKY
-- *********************************************************************************************************************
-- *********************************************************************************************************************
create table USERS_STATUS
(
    STATUS_ID NUMBER        not null,
    NAME      NVARCHAR2(15) not null
)
/

create unique index USERS_STATUS_NAME_UINDEX
    on USERS_STATUS (NAME)
/

create unique index USERS_STATUS_STATUS_ID_UINDEX
    on USERS_STATUS (STATUS_ID)
/

alter table USERS_STATUS
    add constraint USERS_STATUS_PK
        primary key (STATUS_ID)
/

alter table USERS_STATUS
    add check ( STATUS_ID IN (0, 1) )
/

create table FILES
(
    FILE_ID   NUMBER               not null,
    USER_ID   NUMBER               not null,
    FILE_NAME NVARCHAR2(256)       not null,
    FILE_TYPE NVARCHAR2(5),
    FILE_DATA BLOB                 not null,
    CREATED   DATE default SYSDATE not null
)
/

create unique index FILES_FILE_ID_UINDEX
    on FILES (FILE_ID)
/

alter table FILES
    add constraint FILES_PK
        primary key (FILE_ID)
/

create table USERS
(
    USER_ID       NUMBER           not null,
    USERNAME      NVARCHAR2(50)    not null,
    PASSWORD      NVARCHAR2(256)   not null,
    FIRST_NAME    NVARCHAR2(30)    not null,
    MIDDLE_NAME   NVARCHAR2(30),
    LAST_NAME     NVARCHAR2(40)    not null,
    EMAIL         NVARCHAR2(100)   not null,
    STATUS_ID     NUMBER           not null,
    ADMIN         NUMBER default 0 not null,
    PROFILE_IMAGE NUMBER,
    constraint USERS_FILES_FK
        foreign key (PROFILE_IMAGE) references FILES,
    constraint USERS_STATUS_FK
        foreign key (STATUS_ID) references USERS_STATUS
)
/

comment on table USERS is 'Table of all users'
/

create unique index USERS_EMAIL_UINDEX
    on USERS (EMAIL)
/

create unique index USERS_USER_ID_UINDEX
    on USERS (USER_ID)
/

create unique index USERS_USERNAME_UINDEX
    on USERS (USERNAME)
/

alter table USERS
    add constraint USERS_PK
        primary key (USER_ID)
/

alter table FILES
    add constraint FILES_USERS_FK
        foreign key (USER_ID) references USERS
/

alter table USERS
    add check ( ADMIN IN (0, 1) )
/

create table COURSES
(
    COURSE_ID   NUMBER         not null,
    FULL_NAME   NVARCHAR2(50)  not null,
    SHORT_NAME  NVARCHAR2(10)  not null,
    DESCRIPTION NVARCHAR2(256) not null
)
/

create unique index COURSES_COURSE_ID_UINDEX
    on COURSES (COURSE_ID)
/

create unique index COURSES_SHORT_NAME_UINDEX
    on COURSES (SHORT_NAME)
/

alter table COURSES
    add constraint COURSES_PK
        primary key (COURSE_ID)
/

create table TEACHERS
(
    TEACHER_ID NUMBER not null,
    USER_ID    NUMBER not null,
    constraint TEACHERS_USERS_FK
        foreign key (USER_ID) references USERS
)
/

create unique index TEACHERS_TEACHER_ID_UINDEX
    on TEACHERS (TEACHER_ID)
/

create unique index TEACHERS_USER_ID_UINDEX
    on TEACHERS (USER_ID)
/

alter table TEACHERS
    add constraint TEACHERS_PK
        primary key (TEACHER_ID)
/

create table GROUPS
(
    GROUP_ID        NUMBER           not null,
    TEACHER_ID      NUMBER           not null,
    NAME            NVARCHAR2(10)    not null,
    MAX_CAPACITY    NUMBER           not null,
    ACTUAL_CAPACITY NUMBER default 0 not null,
    constraint GROUPS_TEACHERS_FK
        foreign key (TEACHER_ID) references TEACHERS
)
/

create unique index GROUPS_GROUP_ID_UINDEX
    on GROUPS (GROUP_ID)
/

create unique index GROUPS_NAME_UINDEX
    on GROUPS (NAME)
/

alter table GROUPS
    add constraint GROUPS_PK
        primary key (GROUP_ID)
/

create table STUDENTS
(
    STUDENT_ID NUMBER           not null,
    USER_ID    NUMBER           not null,
    YEAR       NUMBER default 1 not null,
    constraint STUDENTS_USERS_FK
        foreign key (USER_ID) references USERS
)
/

create unique index STUDENTS_STUDENT_ID_UINDEX
    on STUDENTS (STUDENT_ID)
/

create unique index STUDENTS_USER_ID_UINDEX
    on STUDENTS (USER_ID)
/

alter table STUDENTS
    add constraint STUDENTS_PK
        primary key (STUDENT_ID)
/

create table GRADES
(
    GRADE_ID    NUMBER               not null,
    STUDENT_ID  NUMBER               not null,
    TEACHER_ID  NUMBER               not null,
    COURSE_ID   NUMBER               not null,
    VALUE       NUMBER               not null,
    DESCRIPTION NVARCHAR2(256),
    CREATED     DATE default SYSDATE not null,
    constraint GRADES_COURSES_FK
        foreign key (COURSE_ID) references COURSES,
    constraint GRADES_STUDENTS_FK
        foreign key (STUDENT_ID) references STUDENTS,
    constraint GRADES_TEACHERS_FK
        foreign key (TEACHER_ID) references TEACHERS
)
/

create unique index GRADES_GRADE_ID_UINDEX
    on GRADES (GRADE_ID)
/

alter table GRADES
    add constraint GRADES_PK
        primary key (GRADE_ID)
/

create table CLASSROOMS
(
    CLASSROOM_ID NUMBER        not null,
    NAME         NVARCHAR2(15) not null,
    CAPACITY     NUMBER        not null
)
/

create unique index CLASSROOMS_CLASSROOM_ID_UINDEX
    on CLASSROOMS (CLASSROOM_ID)
/

alter table CLASSROOMS
    add constraint CLASSROOMS_PK
        primary key (CLASSROOM_ID)
/

create table TIMETABLES
(
    TIMETABLE_ID NUMBER not null,
    GROUP_ID     NUMBER not null,
    CLASSROOM_ID NUMBER not null,
    BEGIN        DATE   not null,
    END          DATE   not null,
    constraint TIMETABLES_CLSROOM_FK
        foreign key (CLASSROOM_ID) references CLASSROOMS,
    constraint TIMETABLES_GROUPS_FK
        foreign key (GROUP_ID) references GROUPS
)
/

create unique index TIMETABLES_TIMETABLE_ID_UINDEX
    on TIMETABLES (TIMETABLE_ID)
/

alter table TIMETABLES
    add constraint TIMETABLES_PK
        primary key (TIMETABLE_ID)
/

create table GROUP_MESSAGES
(
    GMSG_ID  NUMBER               not null,
    GROUP_ID NUMBER,
    USER_ID  NUMBER               not null,
    CONTENT  NVARCHAR2(512)       not null,
    CREATED  DATE default SYSDATE not null,
    constraint GMSG_GROUPS_FK
        foreign key (GROUP_ID) references GROUPS,
    constraint GMSG_USERS_FK
        foreign key (USER_ID) references USERS
)
/

create unique index GROUP_MESSAGES_GMSG_ID_UINDEX
    on GROUP_MESSAGES (GMSG_ID)
/

alter table GROUP_MESSAGES
    add constraint GROUP_MESSAGES_PK
        primary key (GMSG_ID)
/

create table PRIVATE_MESSAGES
(
    PMSG_ID   NUMBER               not null,
    FROM_USER NUMBER               not null,
    TO_USER   NUMBER               not null,
    CONTENT   NVARCHAR2(512)       not null,
    CREATED   DATE default SYSDATE not null,
    constraint PMSG_FROM_USR_FK
        foreign key (FROM_USER) references USERS,
    constraint PMSG_TO_USR_FK
        foreign key (TO_USER) references USERS
)
/

create unique index PRIVATE_MESSAGES_PMSG_ID_UINDEX
    on PRIVATE_MESSAGES (PMSG_ID)
/

alter table PRIVATE_MESSAGES
    add constraint PRIVATE_MESSAGES_PK
        primary key (PMSG_ID)
/

create table COMMENTS
(
    COMMENT_ID NUMBER               not null,
    USER_ID    NUMBER               not null,
    MESSAGE_ID NUMBER               not null,
    CONTENT    NVARCHAR2(256)       not null,
    CREATED    DATE default SYSDATE not null,
    constraint COMMENTS_GMSG_FK
        foreign key (MESSAGE_ID) references GROUP_MESSAGES,
    constraint "comments_users.fk"
        foreign key (USER_ID) references USERS
)
/

create unique index COMMENTS_COMMENT_ID_UINDEX
    on COMMENTS (COMMENT_ID)
/

alter table COMMENTS
    add constraint COMMENTS_PK
        primary key (COMMENT_ID)
/

create table STUDENTS_GROUPS
(
    STUDENT_ID NUMBER not null,
    GROUP_ID   NUMBER not null,
    constraint STUDENTS_GROUPS_PK
        primary key (STUDENT_ID),
    constraint SG_GROUPS_FK
        foreign key (GROUP_ID) references GROUPS,
    constraint SG_STUDENTS_FK
        foreign key (STUDENT_ID) references STUDENTS
)
/

create table COURSES_GROUPS
(
    GROUP_ID  NUMBER not null,
    COURSE_ID NUMBER not null,
    constraint COURSES_GROUPS_PK
        primary key (GROUP_ID),
    constraint CRSGRP_COURSES_FK
        foreign key (COURSE_ID) references COURSES,
    constraint CRSGRP_GROUPS_FK
        foreign key (GROUP_ID) references GROUPS
)
/

-- *********************************************************************************************************************
-- *********************************************************************************************************************
-- SEKVENCE
-- *********************************************************************************************************************
-- *********************************************************************************************************************
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

-- *********************************************************************************************************************
-- *********************************************************************************************************************
-- TIGGERY
-- *********************************************************************************************************************
-- *********************************************************************************************************************
CREATE OR REPLACE TRIGGER users_insert_trg
    BEFORE INSERT ON USERS
    FOR EACH ROW WHEN (new.USER_ID IS NULL)
    BEGIN
        :new.USER_ID := users_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER pmsgs_insert_trg
    BEFORE INSERT ON PRIVATE_MESSAGES
    FOR EACH ROW WHEN (new.PMSG_ID IS NULL)
    BEGIN
        :new.PMSG_ID := pmsgs_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER students_insert_trg
    BEFORE INSERT ON STUDENTS
    FOR EACH ROW WHEN (new.STUDENT_ID IS NULL)
    BEGIN
        :new.STUDENT_ID := students_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER courses_insert_trg
    BEFORE INSERT ON COURSES
    FOR EACH ROW WHEN (new.COURSE_ID IS NULL)
    BEGIN
        :new.COURSE_ID := courses_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER teachers_insert_trg
    BEFORE INSERT ON TEACHERS
    FOR EACH ROW WHEN (new.TEACHER_ID IS NULL)
    BEGIN
        :new.TEACHER_ID := teachers_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER grades_insert_trg
    BEFORE INSERT ON GRADES
    FOR EACH ROW WHEN (new.GRADE_ID IS NULL)
    BEGIN
        :new.GRADE_ID := grades_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER groups_insert_trg
    BEFORE INSERT ON GROUPS
    FOR EACH ROW WHEN (new.GROUP_ID IS NULL)
    BEGIN
        :new.GROUP_ID := groups_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER classrooms_insert_trg
    BEFORE INSERT ON CLASSROOMS
    FOR EACH ROW WHEN (new.CLASSROOM_ID IS NULL)
    BEGIN
        :new.CLASSROOM_ID := classrooms_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER gmsg_insert_trg
    BEFORE INSERT ON GROUP_MESSAGES
    FOR EACH ROW WHEN (new.GMSG_ID IS NULL)
    BEGIN
        :new.GMSG_ID := gmsgs_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER timetables_insert_trg
    BEFORE INSERT ON TIMETABLES
    FOR EACH ROW WHEN (new.TIMETABLE_ID IS NULL)
    BEGIN
        :new.TIMETABLE_ID := timetables_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER comments_insert_trg
    BEFORE INSERT ON COMMENTS
    FOR EACH ROW WHEN (new.COMMENT_ID IS NULL)
    BEGIN
        :new.COMMENT_ID := comments_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER files_insert_trg
    BEFORE INSERT ON FILES
    FOR EACH ROW WHEN (new.FILE_ID IS NULL)
    BEGIN
        :new.FILE_ID := FILES_ID_SEQ.nextval;
    END;

-- *********************************************************************************************************************
-- *********************************************************************************************************************
-- POHLEDY
-- *********************************************************************************************************************
-- *********************************************************************************************************************
CREATE OR REPLACE VIEW VW_USERS_STATUS AS
SELECT *
FROM USERS_STATUS;

CREATE OR REPLACE VIEW VW_USERS AS
SELECT USERS.USER_ID,
       USERNAME,
       FIRST_NAME,
       MIDDLE_NAME,
       LAST_NAME,
       EMAIL,
       PROFILE_IMAGE     PROFILE_IMAGE_ID,
       FILES.FILE_DATA   PROFILE_IMAGE_DATA,
       USERS.STATUS_ID,
       USERS_STATUS.NAME STATUS_NAME,
       ADMIN
FROM USERS
         JOIN USERS_STATUS ON USERS.STATUS_ID = USERS_STATUS.STATUS_ID
         LEFT JOIN FILES ON USERS.PROFILE_IMAGE = FILES.FILE_ID;

CREATE OR REPLACE VIEW VW_STUDENTS AS
SELECT STUDENT_ID,
       STUDENTS.USER_ID,
       LAST_NAME || ', ' || FIRST_NAME || (CASE WHEN MIDDLE_NAME IS NOT NULL THEN ' ' || MIDDLE_NAME END) NAME,
       EMAIL,
       YEAR,
       STATUS_ID,
       STATUS_NAME
FROM STUDENTS
         JOIN VW_USERS ON VW_USERS.USER_ID = STUDENTS.USER_ID;

CREATE OR REPLACE VIEW VW_FILES AS
SELECT FILE_ID, FILES.USER_ID USER_ID, USERS.USERNAME USER_USERNAME, FIRST_NAME, FILE_TYPE, FILE_DATA, CREATED
FROM FILES
         JOIN USERS ON FILES.USER_ID = USERS.USER_ID;

CREATE OR REPLACE VIEW VW_TEACHERS AS
SELECT TEACHER_ID,
       TEACHERS.USER_ID,
       LAST_NAME || ', ' || FIRST_NAME || (CASE WHEN MIDDLE_NAME IS NOT NULL THEN ' ' || MIDDLE_NAME END) NAME,
       EMAIL,
       STATUS_ID,
       STATUS_NAME
FROM TEACHERS
         JOIN VW_USERS ON TEACHERS.USER_ID = VW_USERS.USER_ID;

CREATE OR REPLACE VIEW VW_CLASSROOMS AS
SELECT *
FROM CLASSROOMS;

CREATE OR REPLACE VIEW VW_COURSES AS
SELECT *
FROM COURSES;

CREATE OR REPLACE VIEW VW_GRADES AS
SELECT GRADE_ID,
       GRADES.STUDENT_ID,
       VW_STUDENTS.NAME      STUDENT_NAME,
       GRADES.TEACHER_ID,
       VW_TEACHERS.NAME      TEACHER_NAME,
       GRADES.COURSE_ID,
       VW_COURSES.SHORT_NAME COURSE_SHORT_NAME,
       VW_COURSES.FULL_NAME  COURSE_FULL_NAME,
       VALUE                 GRADE_VALUE,
       GRADES.DESCRIPTION    GRADE_DESCRIPTION,
       CREATED               GRADE_CREATED
FROM GRADES
         JOIN VW_STUDENTS ON GRADES.STUDENT_ID = VW_STUDENTS.STUDENT_ID
         JOIN VW_TEACHERS ON GRADES.TEACHER_ID = VW_TEACHERS.TEACHER_ID
         JOIN VW_COURSES ON GRADES.COURSE_ID = VW_COURSES.COURSE_ID;

CREATE OR REPLACE VIEW VW_GROUPS AS
SELECT GROUP_ID,
       GROUPS.TEACHER_ID,
       VW_TEACHERS.NAME                 TEACHER_NAME,
       GROUPS.NAME                      GROUP_NAME,
       MAX_CAPACITY,
       ACTUAL_CAPACITY,
       (MAX_CAPACITY - ACTUAL_CAPACITY) FREE_CAPACITY
FROM GROUPS
         JOIN VW_TEACHERS ON GROUPS.TEACHER_ID = VW_TEACHERS.TEACHER_ID;

CREATE OR REPLACE VIEW VW_GROUPS_COURSES AS
SELECT CG.GROUP_ID,
       VW_GROUPS.GROUP_NAME,
       VW_GROUPS.MAX_CAPACITY,
       VW_GROUPS.ACTUAL_CAPACITY,
       VW_GROUPS.FREE_CAPACITY,
       VW_GROUPS.TEACHER_ID,
       VW_GROUPS.TEACHER_NAME,
       CG.COURSE_ID,
       VW_COURSES.FULL_NAME   COURSE_FULL_NAME,
       VW_COURSES.SHORT_NAME  COURSE_SHORT_NAME,
       VW_COURSES.DESCRIPTION COURSE_DESCRIPTION
FROM COURSES_GROUPS CG
         JOIN VW_GROUPS ON CG.GROUP_ID = VW_GROUPS.GROUP_ID
         JOIN VW_COURSES ON CG.COURSE_ID = VW_COURSES.COURSE_ID;

CREATE OR REPLACE VIEW VW_STUDENTS_GROUPS AS
SELECT SG.STUDENT_ID,
       VW_STUDENTS.NAME  STUDENT_NAME,
       VW_STUDENTS.EMAIL STUDENT_EMAIL,
       SG.GROUP_ID,
       VW_GROUPS.GROUP_NAME
FROM STUDENTS_GROUPS SG
         JOIN VW_STUDENTS ON SG.STUDENT_ID = VW_STUDENTS.STUDENT_ID
         JOIN VW_GROUPS ON SG.GROUP_ID = VW_GROUPS.GROUP_ID;

CREATE OR REPLACE VIEW VW_TIMETABLES AS
SELECT TIMETABLE_ID,
       TIMETABLES.GROUP_ID,
       VW_GROUPS.GROUP_NAME,
       ACTUAL_CAPACITY        GROUP_CAPACITY,
       TIMETABLES.CLASSROOM_ID,
       VW_CLASSROOMS.NAME     CLASSROOM_NAME,
       VW_CLASSROOMS.CAPACITY CLASSROOM_CAPACITY,
       TIMETABLES."BEGIN",
       TIMETABLES."END"
FROM TIMETABLES
         JOIN VW_GROUPS ON TIMETABLES.GROUP_ID = VW_GROUPS.GROUP_ID
         JOIN VW_CLASSROOMS ON TIMETABLES.CLASSROOM_ID = VW_CLASSROOMS.CLASSROOM_ID;

CREATE OR REPLACE VIEW VW_GROUP_MESSAGES AS
SELECT GMSG_ID           MESSAGE_ID,
       GM.GROUP_ID,
       VW_GROUPS.GROUP_NAME,
       GM.USER_ID        AUTHOR_ID,
       VW_USERS.USERNAME AUTHOR_USERNAME,
       CONTENT,
       CREATED
FROM GROUP_MESSAGES GM
         JOIN VW_GROUPS ON GM.GROUP_ID = VW_GROUPS.GROUP_ID
         JOIN VW_USERS ON GM.USER_ID = VW_USERS.USER_ID;

CREATE OR REPLACE VIEW VW_COMMENTS AS
SELECT COMMENT_ID,
       COMMENTS.CONTENT                  COMMENT_CONTENT,
       COMMENTS.CREATED                  COMMENT_CREATED,
       COMMENTS.USER_ID                  COMMENT_AUTHOR_ID,
       VW_USERS.USERNAME                 COMMENT_AUTHOR_USERNAME,
       COMMENTS.MESSAGE_ID,
       VW_GROUP_MESSAGES.CONTENT         MESSAGE_CONTENT,
       VW_GROUP_MESSAGES.CREATED         MESSAGE_CREATED,
       VW_GROUP_MESSAGES.AUTHOR_ID       MESSAGE_AUTHOR_ID,
       VW_GROUP_MESSAGES.AUTHOR_USERNAME MESSAGE_AUTHOR_USERNAME
FROM COMMENTS
         JOIN VW_USERS ON COMMENTS.USER_ID = VW_USERS.USER_ID
         JOIN VW_GROUP_MESSAGES ON COMMENTS.MESSAGE_ID = VW_GROUP_MESSAGES.MESSAGE_ID;

CREATE OR REPLACE VIEW VW_PRIVATE_MESSAGES AS
SELECT PMSG_ID             MESSAGE_ID,
       FROM_USER           FROM_USER_ID,
       USERS_FROM.USERNAME FROM_USER_USERNAME,
       TO_USER             TO_USER_ID,
       USERS_TO.USERNAME   TO_USER_USERNAME,
       CONTENT             MESSAGE_CONTENT,
       CREATED             MESSAGE_CREATED
FROM PRIVATE_MESSAGES
         JOIN VW_USERS USERS_FROM ON FROM_USER = USERS_FROM.USER_ID
         JOIN VW_USERS USERS_TO ON TO_USER = USERS_TO.USER_ID

-- *********************************************************************************************************************
-- *********************************************************************************************************************
-- BALÍČKY
-- *********************************************************************************************************************
-- *********************************************************************************************************************