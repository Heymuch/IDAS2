create table USERS_STATUS
(
	STATUS_ID NUMBER not null
		check ( STATUS_ID IN (0, 1) ),
	NAME NVARCHAR2(15) not null
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
	USER_ID NUMBER not null,
	USERNAME NVARCHAR2(20) not null,
	PASSWORD NVARCHAR2(256) not null,
	FIRST_NAME NVARCHAR2(25) not null,
	MIDDLE_NAME NVARCHAR2(25),
	LAST_NAME NVARCHAR2(30) not null,
	EMAIL NVARCHAR2(50) not null,
	STATUS_ID NUMBER not null
		constraint USERS_STATUS_FK
			references USERS_STATUS,
	ADMIN NUMBER default 0 not null
		check ( ADMIN IN (0, 1) )
		check ( ADMIN IN (0, 1) )
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

create or replace trigger USERS_INSERT_TRG
	before insert
	on USERS
	for each row when (new.USER_ID IS NULL)
BEGIN
        :new.USER_ID := users_id_seq.nextval;
    END;
/

create table COURSES
(
	COURSE_ID NUMBER not null,
	FULL_NAME NVARCHAR2(50) not null,
	SHORT_NAME NVARCHAR2(10) not null,
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

create or replace trigger COURSES_NEW_TRG
	before insert
	on COURSES
	for each row when (new.COURSE_ID IS NULL)
BEGIN
        :new.COURSE_ID := courses_id_seq.nextval;
    END;
/

create table TEACHERS
(
	TEACHER_ID NUMBER not null,
	USER_ID NUMBER not null
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
	GROUP_ID NUMBER not null,
	TEACHER_ID NUMBER not null
		constraint GROUPS_TEACHERS_FK
			references TEACHERS,
	COURSE_ID NUMBER not null
		constraint GROUPS_COURSES_FK
			references COURSES,
	NAME NVARCHAR2(10) not null,
	MAX_CAPACITY NUMBER not null,
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

create or replace trigger GROUPS_NEW_TRG
	before insert
	on GROUPS
	for each row when (new.GROUP_ID IS NULL)
BEGIN
        :new.GROUP_ID := groups_id_seq.nextval;
    END;
/

create or replace trigger TEACHERS_NEW_TRG
	before insert
	on TEACHERS
	for each row when (new.TEACHER_ID IS NULL)
BEGIN
        :new.TEACHER_ID := teachers_id_seq.nextval;
    END;
/

create table STUDENTS
(
	STUDENT_ID NUMBER not null,
	USER_ID NUMBER not null
		constraint STUDENTS_USERS_FK
			references USERS,
	YEAR NUMBER default 1 not null
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

create or replace trigger STUDENTS_NEW_TRG
	before insert
	on STUDENTS
	for each row when (new.STUDENT_ID IS NULL)
BEGIN
        :new.STUDENT_ID := students_id_seq.nextval;
    END;
/

create table GRADES
(
	GRADE_ID NUMBER not null,
	STUDENT_ID NUMBER not null
		constraint GRADES_STUDENTS_FK
			references STUDENTS,
	TEACHER_ID NUMBER not null
		constraint GRADES_TEACHERS_FK
			references TEACHERS,
	COURSE_ID NUMBER not null
		constraint GRADES_COURSES_FK
			references COURSES,
	VALUE NUMBER not null,
	DESCRIPTION NVARCHAR2(256),
	CREATED DATE default SYSDATE not null
)
/

create unique index GRADES_GRADE_ID_UINDEX
	on GRADES (GRADE_ID)
/

alter table GRADES
	add constraint GRADES_PK
		primary key (GRADE_ID)
/

create or replace trigger GRADES_NEW_TRG
	before insert
	on GRADES
	for each row when (new.GRADE_ID IS NULL)
BEGIN
        :new.GRADE_ID := grades_id_seq.nextval;
    END;
/

create table CLASSROOMS
(
	CLASSROOM_ID NUMBER not null,
	NAME NVARCHAR2(15) not null,
	CAPACITY NUMBER not null
)
/

create unique index CLASSROOMS_CLASSROOM_ID_UINDEX
	on CLASSROOMS (CLASSROOM_ID)
/

alter table CLASSROOMS
	add constraint CLASSROOMS_PK
		primary key (CLASSROOM_ID)
/

create or replace trigger CLASSROOMS_NEW_TRG
	before insert
	on CLASSROOMS
	for each row when (new.CLASSROOM_ID IS NULL)
BEGIN
        :new.CLASSROOM_ID := classrooms_id_seq.nextval;
    END;
/

create table TIMETABLES
(
	TIMETABLE_ID NUMBER not null,
	GROUP_ID NUMBER not null
		constraint TIMETABLES_GROUPS_FK
			references GROUPS,
	CLASSROOM_ID NUMBER not null
		constraint TIMETABLES_CLSROOM_FK
			references CLASSROOMS,
	BEGIN DATE not null,
	END DATE not null
)
/

create unique index TIMETABLES_TIMETABLE_ID_UINDEX
	on TIMETABLES (TIMETABLE_ID)
/

alter table TIMETABLES
	add constraint TIMETABLES_PK
		primary key (TIMETABLE_ID)
/

create or replace trigger TIMETABLES_NEW_TRG
	before insert
	on TIMETABLES
	for each row when (new.TIMETABLE_ID IS NULL)
BEGIN
        :new.TIMETABLE_ID := timetables_id_seq.nextval;
    END;
/

create table GROUP_MESSAGES
(
	GMSG_ID NUMBER not null,
	GROUP_ID NUMBER
		constraint GMSG_GROUPS_FK
			references GROUPS,
	USER_ID NUMBER not null
		constraint GMSG_USERS_FK
			references USERS,
	CONTENT NVARCHAR2(512) not null,
	CREATED DATE default SYSDATE not null
)
/

create unique index GROUP_MESSAGES_GMSG_ID_UINDEX
	on GROUP_MESSAGES (GMSG_ID)
/

alter table GROUP_MESSAGES
	add constraint GROUP_MESSAGES_PK
		primary key (GMSG_ID)
/

create or replace trigger GMSG_NEW_TRG
	before insert
	on GROUP_MESSAGES
	for each row when (new.GMSG_ID IS NULL)
BEGIN
        :new.GMSG_ID := gmsgs_id_seq.nextval;
    END;
/

create table PRIVATE_MESSAGES
(
	PMSG_ID NUMBER not null,
	FROM_USER NUMBER not null
		constraint PMSG_FROM_USR_FK
			references USERS,
	TO_USER NUMBER not null
		constraint PMSG_TO_USR_FK
			references USERS,
	CONTENT NVARCHAR2(512) not null,
	CREATED DATE default SYSDATE not null
)
/

create unique index PRIVATE_MESSAGES_PMSG_ID_UINDEX
	on PRIVATE_MESSAGES (PMSG_ID)
/

alter table PRIVATE_MESSAGES
	add constraint PRIVATE_MESSAGES_PK
		primary key (PMSG_ID)
/

create or replace trigger PMSGS_INSERT_TRG
	before insert
	on PRIVATE_MESSAGES
	for each row when (new.PMSG_ID IS NULL)
BEGIN
        :new.PMSG_ID := pmsgs_id_seq.nextval;
    END;
/

create table COMMENTS
(
	COMMENT_ID NUMBER not null,
	USER_ID NUMBER not null
		constraint "comments_users.fk"
			references USERS,
	MESSAGE_ID NUMBER not null
		constraint COMMENTS_GMSG_FK
			references GROUP_MESSAGES,
	CONTENT NVARCHAR2(256) not null,
	CREATED DATE default SYSDATE not null
)
/

create unique index COMMENTS_COMMENT_ID_UINDEX
	on COMMENTS (COMMENT_ID)
/

alter table COMMENTS
	add constraint COMMENTS_PK
		primary key (COMMENT_ID)
/

create or replace trigger COMMENTS_NEW_TRG
	before insert
	on COMMENTS
	for each row when (new.COMMENT_ID IS NULL)
BEGIN
        :new.COMMENT_ID := comments_id_seq.nextval;
    END;
/

create table STUDENTS_GROUPS
(
	STUDENT_ID NUMBER not null
		constraint STUDENTS_GROUPS_PK
			primary key
		constraint SG_STUDENTS_FK
			references STUDENTS,
	GROUP_ID NUMBER not null
		constraint SG_GROUPS_FK
			references GROUPS
)
/

