CREATE OR REPLACE PACKAGE PKG_TIMETABLE AS
    SUBTYPE T_ID IS TIMETABLES.TIMETABLE_ID%TYPE;
    SUBTYPE T_BEGIN IS TIMETABLES."BEGIN"%TYPE;
    SUBTYPE T_END IS TIMETABLEs."END"%TYPE;

    FUNCTION NEW(p_group_id PKG_GROUP.T_ID, p_classroom_id PKG_CLASSROOM.T_ID, p_begin T_BEGIN, p_end T_END) RETURN T_ID;

    FUNCTION GET_ALL RETURN SYS_REFCURSOR;

    FUNCTION GET_BY_GROUP(p_group_id PKG_GROUP.T_ID) RETURN SYS_REFCURSOR;

    FUNCTION GET_BY_CLASSROOM(p_classroom_id PKG_CLASSROOM.T_ID) RETURN SYS_REFCURSOR;

    PROCEDURE REMOVE(p_timetable_id T_ID);

    PROCEDURE UPDATE_BEGIN(p_timetable_id T_ID, p_begin T_BEGIN);

    PROCEDURE UPDATE_END(p_timetable_id T_ID, p_end T_END);
END;

CREATE OR REPLACE PACKAGE BODY PKG_TIMETABLE AS
    FUNCTION NEW(p_group_id PKG_GROUP.T_ID, p_classroom_id PKG_CLASSROOM.T_ID, p_begin T_BEGIN,
                 p_end T_END) RETURN T_ID AS
        v_id T_ID;
    BEGIN
        INSERT INTO TIMETABLES(GROUP_ID, CLASSROOM_ID, "BEGIN", "END")
        VALUES (p_group_id, p_classroom_id, p_begin, p_end)
        RETURNING TIMETABLE_ID INTO v_id;
        COMMIT;
        RETURN v_id;
    END;

    FUNCTION GET_ALL RETURN SYS_REFCURSOR AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM VW_TIMETABLES;
        RETURN v_cursor;
    END;

    FUNCTION GET_BY_GROUP(p_group_id PKG_GROUP.T_ID) RETURN SYS_REFCURSOR AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM VW_TIMETABLES WHERE GROUP_ID = p_group_id;
        RETURN v_cursor;
    END;

    FUNCTION GET_BY_CLASSROOM(p_classroom_id PKG_CLASSROOM.T_ID) RETURN SYS_REFCURSOR AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM VW_TIMETABLES WHERE CLASSROOM_ID = p_classroom_id;
        RETURN v_cursor;
    END;

    PROCEDURE REMOVE(p_timetable_id T_ID) AS
    BEGIN
        DELETE TIMETABLES WHERE TIMETABLE_ID = p_timetable_id;
        COMMIT;
    END;

    PROCEDURE UPDATE_BEGIN(p_timetable_id T_ID, p_begin T_BEGIN) AS
    BEGIN
        UPDATE TIMETABLES SET "BEGIN" = p_begin WHERE TIMETABLE_ID = p_timetable_id;
        COMMIT;
    END;

    PROCEDURE UPDATE_END(p_timetable_id T_ID, p_end T_END) AS
    BEGIN
        UPDATE TIMETABLES SET "END" = p_end WHERE TIMETABLE_ID = p_timetable_id;
        COMMIT;
    END;
END;