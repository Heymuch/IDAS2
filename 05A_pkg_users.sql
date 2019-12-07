CREATE OR REPLACE PACKAGE PKG_USER AS
    -- ||| FUNKCE
    -- Funkce pro vytvoření nového uživatele
    -- @return ID nového uživatele
    FUNCTION NEW(p_username USERS.USERNAME%TYPE, p_password USERS.PASSWORD%TYPE,
        p_firstname USERS.FIRST_NAME%TYPE, p_middlename USERS.MIDDLE_NAME%TYPE, p_lastname USERS.LAST_NAME%TYPE,
        p_email USERS.EMAIL%TYPE, p_status USERS.STATUS_ID%TYPE) RETURN USERS.USER_ID%TYPE;

    -- Funkce pro přihlášení uživatele na základě jeho přihlašovacích údajů
    -- @return ID přihlášeného uživatele při přihlašení, jinak NULL
    FUNCTION LOGIN(p_username USERS.USERNAME%TYPE, p_password USERS.PASSWORD%TYPE) RETURN USERS.USER_ID%TYPE;

    -- Funkce vrací záznam o uživateli se vstupním ID
    -- @return cursor
    FUNCTION GET_USER(p_user_id USERS.USER_ID%TYPE) RETURN SYS_REFCURSOR;

    -- Funkce vrací všechny záznamy o uživatelých
    -- @return cursor
    FUNCTION GET_ALL RETURN SYS_REFCURSOR;


    -- ||| PROCEDURY
    -- Procedura pro změnu stavu uživatele (0: Neaktivní, 1: Aktivní)
    PROCEDURE UPDATE_STATUS(p_user_id USERS.USER_ID%TYPE, p_status USERS_STATUS.STATUS_ID%TYPE);

    -- Procedura pro změnu přihlašovacích údajů uživatele
    PROCEDURE UPDATE_LOGIN(p_user_id USERS.USER_ID%TYPE, p_username USERS.USERNAME%TYPE, p_password USERS.PASSWORD%TYPE);

    -- Procedura pro úpravu ostatních informací o uživateli
    PROCEDURE UPDATE_DETAILS(p_user_id USERS.USER_ID%TYPE,
        p_firstname USERS.FIRST_NAME%TYPE, p_middlename USERS.MIDDLE_NAME%TYPE, p_lastname USERS.LAST_NAME%TYPE,
        p_email USERS.EMAIL%TYPE);

    -- Procedura pro přídání/odebrání administrátorské role
    PROCEDURE UPDATE_ADMIN(p_user_id USERS.USER_ID%TYPE, p_admin USERS.ADMIN%TYPE);
END;



CREATE OR REPLACE PACKAGE BODY PKG_USER AS
    FUNCTION NEW(p_username USERS.USERNAME%TYPE, p_password USERS.PASSWORD%TYPE,
            p_firstname USERS.FIRST_NAME%TYPE, p_middlename USERS.MIDDLE_NAME%TYPE, p_lastname USERS.LAST_NAME%TYPE,
            p_email USERS.EMAIL%TYPE, p_status USERS.STATUS_ID%TYPE) RETURN USERS.USER_ID%TYPE IS

            v_id USERS.USER_ID%TYPE;
        BEGIN
            INSERT INTO USERS(USERNAME, PASSWORD, FIRST_NAME, MIDDLE_NAME, LAST_NAME, EMAIL, STATUS_ID)
                VALUES (p_username, p_password, p_firstname, p_middlename, p_lastname, p_email, p_status);
            COMMIT;
            SELECT USER_ID INTO v_id FROM USERS WHERE USERNAME = p_username;
            RETURN v_id;
            --EXCEPTION WHEN OTHERS THEN RETURN NULL;
        END;

    FUNCTION LOGIN(p_username USERS.USERNAME%TYPE, p_password USERS.PASSWORD%TYPE) RETURN USERS.USER_ID%TYPE IS
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

    FUNCTION GET_USER(p_user_id USERS.USER_ID%TYPE) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM VW_USERS WHERE USER_ID = p_user_id;
        RETURN v_cursor;
        --EXCEPTION WHEN OTHERS THEN RETURN NULL;
    END;

    FUNCTION GET_ALL RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM VW_USERS;
        RETURN v_cursor;
    END;

    PROCEDURE UPDATE_STATUS(p_user_id USERS.USER_ID%TYPE, p_status USERS_STATUS.STATUS_ID%TYPE) IS
    BEGIN
        UPDATE USERS SET STATUS_ID = p_status WHERE USER_ID = p_user_id;
        COMMIT;
    END;

    PROCEDURE UPDATE_LOGIN(p_user_id USERS.USER_ID%TYPE, p_username USERS.USERNAME%TYPE, p_password USERS.PASSWORD%TYPE) IS
    BEGIN
        UPDATE USERS SET USERNAME = p_username, PASSWORD = p_password WHERE USER_ID = p_user_id;
        COMMIT;
    END;

    PROCEDURE UPDATE_DETAILS(p_user_id USERS.USER_ID%TYPE,
        p_firstname USERS.FIRST_NAME%TYPE, p_middlename USERS.MIDDLE_NAME%TYPE, p_lastname USERS.LAST_NAME%TYPE,
        p_email USERS.EMAIL%TYPE) IS
        BEGIN
            UPDATE USERS SET FIRST_NAME = p_firstname, MIDDLE_NAME = p_middlename, LAST_NAME = p_lastname, EMAIL = p_email WHERE USER_ID = p_user_id;
            COMMIT;
        END;

    PROCEDURE UPDATE_ADMIN(p_user_id USERS.USER_ID%TYPE, p_admin USERS.ADMIN%TYPE) IS
        BEGIN
            UPDATE USERS SET ADMIN = p_admin WHERE USER_ID = p_user_id;
            COMMIT;
        END;
END;

