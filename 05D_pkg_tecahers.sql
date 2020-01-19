CREATE OR REPLACE PACKAGE PKG_TEACHER AS
    -- +================================================================================================================
    -- | Aliasy
    SUBTYPE T_ID IS TEACHERS.TEACHER_ID%TYPE;
    -- +----------------------------------------------------------------------------------------------------------------

    -- +================================================================================================================
    -- | Funkce / Procedury

    -- Funkce pro vytvoření nového učitele.
    -- @param p_user_id ID uživatele
    -- @return ID nově vytvořeného uživatele
    FUNCTION NEW(p_user_id PKG_USER.T_ID) RETURN T_ID;

    -- Funkce pro zjištění, zdali uživatel je učitelem.
    -- @param p_user_id ID uživatele
    -- @return true pokud je uživatel učitelem, jinak false
    FUNCTION IS_TEACHER(p_user_id PKG_USER.T_ID) RETURN BOOLEAN;

    -- Funkce vrátí všechny registrované učitele.
    FUNCTION GET_ALL RETURN SYS_REFCURSOR;

    -- Funkce vrátí záznam o daném učiteli.
    -- @param p_teacher_id ID učitele
    -- @return CURSOR
    -- @throws Exception pokud neexistuje učitel s daným ID
    FUNCTION GET_BY_ID(p_teacher_id T_ID) RETURN SYS_REFCURSOR;

    FUNCTION GET_BY_USER(p_user_id PKG_USER.T_ID) RETURN SYS_REFCURSOR;
    -- +----------------------------------------------------------------------------------------------------------------
END;

CREATE OR REPLACE PACKAGE BODY PKG_TEACHER AS
    -- @TODO kontrola jestli uživatel není již učitelem
    FUNCTION NEW(p_user_id PKG_USER.T_ID) RETURN T_ID AS
        v_id T_ID;
    BEGIN
        INSERT INTO TEACHERS(USER_ID) VALUES (p_user_id) RETURNING TEACHER_ID INTO v_id;
        COMMIT;
        RETURN v_id;
    END;

    FUNCTION IS_TEACHER(p_user_id PKG_USER.T_ID) RETURN BOOLEAN AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM TEACHERS WHERE USER_ID = p_user_id;
        RETURN (v_count = 1);
    END;

    FUNCTION GET_ALL RETURN SYS_REFCURSOR AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM VW_TEACHERS;
        RETURN v_cursor;
    END;

    FUNCTION GET_BY_ID(p_teacher_id T_ID) RETURN SYS_REFCURSOR AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM VW_TEACHERS WHERE TEACHER_ID = p_teacher_id;
        RETURN v_cursor;
    END;

    FUNCTION GET_BY_USER(p_user_id PKG_USER.T_ID) RETURN SYS_REFCURSOR AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM VW_TEACHERS WHERE USER_ID = p_user_id;
        RETURN v_cursor;
    END;
END;