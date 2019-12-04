-- ||| PROCEDURY/FUNKCE USERS
-- Funkce pro vytvoření nového uživatele; Vrací ID nového uživatele; TESTED
CREATE OR REPLACE FUNCTION USER_NEW(
        p_username USERS.USERNAME%TYPE,
        p_password USERS.PASSWORD%TYPE,
        p_firstname USERS.FIRST_NAME%TYPE,
        p_middlename USERS.MIDDLE_NAME%TYPE,
        p_lastname USERS.LAST_NAME%TYPE,
        p_email USERS.EMAIL%TYPE,
        p_status USERS.STATUS_ID%TYPE)
    RETURN USERS.USER_ID%TYPE AS
        v_id USERS.USER_ID%TYPE;
    BEGIN
        INSERT INTO USERS(USERNAME, PASSWORD, FIRST_NAME, MIDDLE_NAME, LAST_NAME, EMAIL, STATUS_ID)
        VALUES (p_username, p_password, p_firstname, p_middlename, p_lastname, p_email, p_status);
        SELECT USER_ID INTO v_id FROM USERS WHERE USERNAME = p_username;
        COMMIT;
        RETURN v_id;

        --EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END;

-- Funkce pro přihlášení uživatele na základě jeho přihlašovacích údajů; Vrací ID uživatele; TESTED
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

-- Funkce vrací cursor s daty o uživateli se vstupním ID; TESTED
CREATE OR REPLACE FUNCTION USER_GET(p_user_id USERS.USER_ID%TYPE)
    RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM VW_USERS WHERE USER_ID = p_user_id;
        RETURN v_cursor;

        --EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END;

-- Funkce vrací cursor se všemi uživateli
CREATE OR REPLACE FUNCTION USER_GET_ALL
    RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM VW_USERS;
        RETURN v_cursor;
    end;

-- Procedura pro změnu stavu uživatele; TESTED
CREATE OR REPLACE PROCEDURE USER_UPDATE_STATUS(p_user_id USERS.USER_ID%TYPE, p_status USERS_STATUS.STATUS_ID%TYPE) IS
    BEGIN
        UPDATE USERS SET STATUS_ID = p_status WHERE USER_ID = p_user_id;
        COMMIT;
    END;

-- Procedura pro změnu přihlašovacích údajů uživatele; TESTED
CREATE OR REPLACE PROCEDURE USER_UPDATE_LOGIN(p_user_id USERS.USER_ID%TYPE, p_username USERS.USERNAME%TYPE, p_password USERS.PASSWORD%TYPE) IS
    BEGIN
        UPDATE USERS SET USERNAME = p_username, PASSWORD = p_password WHERE USER_ID = p_user_id;
        COMMIT;
    END;

-- Procedura pro změnu základní informací o uživateli; TESTED
CREATE OR REPLACE PROCEDURE USER_UPDATE_DETAILS(p_user_id USERS.USER_ID%TYPE, p_firstname USERS.FIRST_NAME%TYPE, p_middlename USERS.MIDDLE_NAME%TYPE, p_lastname USERS.LAST_NAME%TYPE, p_email USERS.EMAIL%TYPE) IS
    BEGIN
        UPDATE USERS SET FIRST_NAME = p_firstname, MIDDLE_NAME = p_middlename, LAST_NAME = p_lastname, EMAIL = p_email WHERE USER_ID = p_user_id;
        COMMIT;
    END;

-- Procedura pro přiřazení/odejmutí administrátorských práv uživateli; TESTED
CREATE OR REPLACE PROCEDURE USER_UPDATE_ADMIN(p_user_id USERS.USER_ID%TYPE, p_admin USERS.ADMIN%TYPE) IS
    BEGIN
        UPDATE USERS SET ADMIN = p_admin WHERE USER_ID = p_user_id;
        COMMIT;
    END;

-- Procedura pro změnu ročníku studenta; TESTED
CREATE OR REPLACE PROCEDURE STUDENT_UPDATE_YEAR(p_student_id STUDENTS.STUDENT_ID%TYPE, p_year STUDENTS.YEAR%TYPE) IS
    BEGIN
        UPDATE STUDENTS SET YEAR = p_year WHERE STUDENT_ID = p_student_id;
        COMMIT;
    END;