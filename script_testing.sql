-- ||| Vložení nového uživatele
DECLARE
    v_var USERS.USER_ID%TYPE;
BEGIN
    v_var := USER_NEW('admin', 'heslo', 'Jan', '', 'Bedna', 'admin@upce.cz', 1);
    DBMS_OUTPUT.PUT_LINE('NEW USER: ' || v_var);
end;

-- ||| Nastavení uživateli administrátorská práva
BEGIN
    USER_UPDATE_ADMIN(8, 1);
end;

-- ||| Přihlášení uživatele do systému
DECLARE
    v_var USERS.USER_ID%TYPE;
BEGIN
    v_var := USER_LOGIN('hejduk', 'qwertz');
     DBMS_OUTPUT.PUT_LINE('LOGIN USER: ' || v_var);
end;

DECLARE
    v_var USERS.USER_ID%TYPE;
BEGIN
    v_var := USER_LOGIN('nothing', 'nothing');
     DBMS_OUTPUT.PUT_LINE('LOGIN USER: ' || v_var);
end;