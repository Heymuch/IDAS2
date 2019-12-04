ALTER SESSION SET CURRENT_SCHEMA = IDAS;

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

-- ||| TRIGGERY
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

CREATE OR REPLACE TRIGGER students_new_trg
    BEFORE INSERT ON STUDENTS
    FOR EACH ROW WHEN (new.STUDENT_ID IS NULL)
    BEGIN
        :new.STUDENT_ID := students_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER courses_new_trg
    BEFORE INSERT ON COURSES
    FOR EACH ROW WHEN (new.COURSE_ID IS NULL)
    BEGIN
        :new.COURSE_ID := courses_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER teachers_new_trg
    BEFORE INSERT ON TEACHERS
    FOR EACH ROW WHEN (new.TEACHER_ID IS NULL)
    BEGIN
        :new.TEACHER_ID := teachers_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER grades_new_trg
    BEFORE INSERT ON GRADES
    FOR EACH ROW WHEN (new.GRADE_ID IS NULL)
    BEGIN
        :new.GRADE_ID := grades_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER groups_new_trg
    BEFORE INSERT ON GROUPS
    FOR EACH ROW WHEN (new.GROUP_ID IS NULL)
    BEGIN
        :new.GROUP_ID := groups_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER classrooms_new_trg
    BEFORE INSERT ON CLASSROOMS
    FOR EACH ROW WHEN (new.CLASSROOM_ID IS NULL)
    BEGIN
        :new.CLASSROOM_ID := classrooms_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER gmsg_new_trg
    BEFORE INSERT ON GROUP_MESSAGES
    FOR EACH ROW WHEN (new.GMSG_ID IS NULL)
    BEGIN
        :new.GMSG_ID := gmsgs_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER timetables_new_trg
    BEFORE INSERT ON TIMETABLES
    FOR EACH ROW WHEN (new.TIMETABLE_ID IS NULL)
    BEGIN
        :new.TIMETABLE_ID := timetables_id_seq.nextval;
    END;

CREATE OR REPLACE TRIGGER comments_new_trg
    BEFORE INSERT ON COMMENTS
    FOR EACH ROW WHEN (new.COMMENT_ID IS NULL)
    BEGIN
        :new.COMMENT_ID := comments_id_seq.nextval;
    END;

-- ||| CHECKS
ALTER TABLE USERS ADD CHECK ( ADMIN IN (0, 1) );
ALTER TABLE USERS_STATUS ADD CHECK ( STATUS_ID IN (0, 1) );

-- ||| FUNKCE
CREATE OR REPLACE FUNCTION USER_NEW(
        p_username USERS.USERNAME%TYPE,
        p_password USERS.PASSWORD%TYPE,
        p_firstname USERS.FIRST_NAME%TYPE,
        p_middlename USERS.MIDDLE_NAME%TYPE,
        p_lastname USERS.LAST_NAME%TYPE,
        p_email USERS.EMAIL%TYPE,
        p_status USERS.STATUS_ID%TYPE)
    RETURN USERS.USER_ID%TYPE IS
        v_id USERS.USER_ID%TYPE;
    BEGIN
        INSERT INTO USERS(USERNAME, PASSWORD, FIRST_NAME, MIDDLE_NAME, LAST_NAME, EMAIL, STATUS_ID)
        VALUES (p_username, p_password, p_firstname, p_middlename, p_lastname, p_email, p_status);
        SELECT USER_ID INTO v_id FROM USERS WHERE USERNAME = p_username;
        RETURN v_id;

        EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END;

CREATE OR REPLACE FUNCTION USER_LOGIN(p_username USERS.USERNAME%TYPE, p_password USERS.PASSWORD%TYPE)
    RETURN USERS.USER_ID%TYPE IS
        v_id USERS.USER_ID%TYPE;
        v_status USERS.STATUS_ID%TYPE;
    BEGIN
        SELECT USER_ID, STATUS_ID INTO v_id, v_status FROM USERS WHERE USERNAME = p_username AND PASSWORD = p_password;
        IF v_status = 1 THEN
            RETURN v_id;
        ELSE
            RETURN NULL;
        END IF;
        EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END;

CREATE OR REPLACE FUNCTION USER_GET(p_user_id USERS.USER_ID%TYPE)
    RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT USERNAME, FIRST_NAME, MIDDLE_NAME, LAST_NAME, EMAIL FROM USERS WHERE USER_ID = p_user_id;
        RETURN v_cursor;

        EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END;

CREATE OR REPLACE FUNCTION STUDENT_NEW(p_user_id USERS.USER_ID%TYPE, p_year STUDENTS.YEAR%TYPE DEFAULT 1)
    RETURN STUDENTS.STUDENT_ID%TYPE IS
        v_id STUDENTS.STUDENT_ID%TYPE;
    BEGIN
        INSERT INTO STUDENTS(USER_ID, YEAR) VALUES (p_user_id, p_year);
        SELECT STUDENT_ID INTO v_id FROM STUDENTS WHERE USER_ID = p_user_id;
        RETURN v_id;

        EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END;



-- ||| PROCEDURY
CREATE OR REPLACE PROCEDURE USER_UPDATE_STATUS(p_user_id USERS.USER_ID%TYPE, p_status USERS_STATUS.STATUS_ID%TYPE) IS
    BEGIN
        UPDATE USERS SET STATUS_ID = p_status WHERE USER_ID = p_user_id;
    END;

CREATE OR REPLACE PROCEDURE USER_UPDATE_LOGIN(p_user_id USERS.USER_ID%TYPE, p_username USERS.USERNAME%TYPE, p_password USERS.PASSWORD%TYPE) IS
    BEGIN
        UPDATE USERS SET USERNAME = p_username, PASSWORD = p_password WHERE USER_ID = p_user_id;
    END;

CREATE OR REPLACE PROCEDURE USER_UPDATE_DETAILS(p_user_id USERS.USER_ID%TYPE, p_firstname USERS.FIRST_NAME%TYPE, p_middlename USERS.MIDDLE_NAME%TYPE, p_lastname USERS.LAST_NAME%TYPE, p_email USERS.EMAIL%TYPE) IS
    BEGIN
        UPDATE USERS SET FIRST_NAME = p_firstname, MIDDLE_NAME = p_middlename, LAST_NAME = p_lastname, EMAIL = p_email WHERE USER_ID = p_user_id;
    END;

CREATE OR REPLACE PROCEDURE USER_UPDATE_ADMIN(p_user_id USERS.USER_ID%TYPE, p_admin USERS.ADMIN%TYPE) IS
    BEGIN
        UPDATE USERS SET ADMIN = p_admin WHERE USER_ID = p_user_id;
    END;

CREATE OR REPLACE PROCEDURE STUDENT_UPDATE_YEAR(p_student_id STUDENTS.STUDENT_ID%TYPE, p_year STUDENTS.YEAR%TYPE) IS
    BEGIN
        UPDATE STUDENTS SET YEAR = p_year WHERE STUDENT_ID = p_student_id;
    END;

CREATE OR REPLACE PROCEDURE STUDENT_GROUP_ADD(p_student_id STUDENTS.STUDENT_ID%TYPE, p_group_id GROUPS.GROUP_ID%TYPE) IS
    BEGIN
        INSERT INTO STUDENTS_GROUPS(STUDENT_ID, GROUP_ID) VALUES (p_student_id, p_group_id);
    END;

CREATE OR REPLACE PROCEDURE STUDENT_GROUP_REMOVE(p_student_id STUDENTS.STUDENT_ID%TYPE, p_group_id GROUPS.GROUP_ID%TYPE) IS
    BEGIN
        DELETE FROM STUDENTS_GROUPS WHERE STUDENT_ID = p_student_id AND GROUP_ID = p_group_id;
    end;