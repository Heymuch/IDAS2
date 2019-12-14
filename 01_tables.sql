-- ||| TABULKY
DROP TABLE CLASSROOMS CASCADE CONSTRAINTS;
DROP TABLE COMMENTS CASCADE CONSTRAINTS;
DROP TABLE COURSES CASCADE CONSTRAINTS;
DROP TABLE GRADES CASCADE CONSTRAINTS;
DROP TABLE GROUP_MESSAGES CASCADE CONSTRAINTS;
DROP TABLE GROUPS CASCADE CONSTRAINTS;
DROP TABLE PRIVATE_MESSAGES CASCADE CONSTRAINTS;
DROP TABLE STUDENTS CASCADE CONSTRAINTS;
DROP TABLE STUDENTS_GROUPS CASCADE CONSTRAINTS;
DROP TABLE TEACHERS CASCADE CONSTRAINTS;
DROP TABLE TIMETABLES CASCADE CONSTRAINTS;
DROP TABLE USERS CASCADE CONSTRAINTS;
DROP TABLE USERS_STATUS CASCADE CONSTRAINTS;
DROP TABLE COURSES_GROUPS CASCADE CONSTRAINTS;
DROP TABLE FILES CASCADE CONSTRAINTS;


create table USERS_STATUS
(
    STATUS_ID NUMBER        not null
        check ( STATUS_ID IN (0, 1) ),
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

create table USERS
(
    USER_ID       NUMBER           not null,
    USERNAME      NVARCHAR2(50)    not null,
    PASSWORD      NVARCHAR2(256)   not null,
    FIRST_NAME    NVARCHAR2(30)    not null,
    MIDDLE_NAME   NVARCHAR2(30),
    LAST_NAME     NVARCHAR2(40)    not null,
    EMAIL         NVARCHAR2(100)   not null,
    STATUS_ID     NUMBER           not null
        constraint USERS_STATUS_FK
            references USERS_STATUS,
    ADMIN         NUMBER default 0 not null
        check ( ADMIN IN (0, 1) ),
    PROFILE_IMAGE NUMBER
        constraint USERS_FILES_FK
            references FILES
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
    USER_ID    NUMBER not null
        constraint TEACHERS_USERS_FK
            references USERS
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
    TEACHER_ID      NUMBER           not null
        constraint GROUPS_TEACHERS_FK
            references TEACHERS,
    NAME            NVARCHAR2(10)    not null,
    MAX_CAPACITY    NUMBER           not null,
    ACTUAL_CAPACITY NUMBER default 0 not null
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
    USER_ID    NUMBER           not null
        constraint STUDENTS_USERS_FK
            references USERS,
    YEAR       NUMBER default 1 not null
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
    STUDENT_ID  NUMBER               not null
        constraint GRADES_STUDENTS_FK
            references STUDENTS,
    TEACHER_ID  NUMBER               not null
        constraint GRADES_TEACHERS_FK
            references TEACHERS,
    COURSE_ID   NUMBER               not null
        constraint GRADES_COURSES_FK
            references COURSES,
    VALUE       NUMBER               not null,
    DESCRIPTION NVARCHAR2(256),
    CREATED     DATE default SYSDATE not null
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
    GROUP_ID     NUMBER not null
        constraint TIMETABLES_GROUPS_FK
            references GROUPS,
    CLASSROOM_ID NUMBER not null
        constraint TIMETABLES_CLSROOM_FK
            references CLASSROOMS,
    BEGIN        DATE   not null,
    END          DATE   not null
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
    GROUP_ID NUMBER
        constraint GMSG_GROUPS_FK
            references GROUPS,
    USER_ID  NUMBER               not null
        constraint GMSG_USERS_FK
            references USERS,
    CONTENT  NVARCHAR2(512)       not null,
    CREATED  DATE default SYSDATE not null
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
    FROM_USER NUMBER               not null
        constraint PMSG_FROM_USR_FK
            references USERS,
    TO_USER   NUMBER               not null
        constraint PMSG_TO_USR_FK
            references USERS,
    CONTENT   NVARCHAR2(512)       not null,
    CREATED   DATE default SYSDATE not null
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
    USER_ID    NUMBER               not null
        constraint "comments_users.fk"
            references USERS,
    MESSAGE_ID NUMBER               not null
        constraint COMMENTS_GMSG_FK
            references GROUP_MESSAGES,
    CONTENT    NVARCHAR2(256)       not null,
    CREATED    DATE default SYSDATE not null
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
    STUDENT_ID NUMBER not null
        constraint STUDENTS_GROUPS_PK
            primary key
        constraint SG_STUDENTS_FK
            references STUDENTS,
    GROUP_ID   NUMBER not null
        constraint SG_GROUPS_FK
            references GROUPS
)
/

create table COURSES_GROUPS
(
    GROUP_ID  NUMBER not null
        constraint COURSES_GROUPS_PK
            primary key
        constraint CRSGRP_GROUPS_FK
            references GROUPS,
    COURSE_ID NUMBER not null
        constraint CRSGRP_COURSES_FK
            references COURSES
)
/

create table FILES
(
    FILE_ID   NUMBER               not null,
    USER_ID   NUMBER               not null
        constraint FILES_USERS_FK
            references USERS,
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

