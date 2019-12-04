-- ||| Vložení nového uživatele
DECLARE
    v_var USERS.USER_ID%TYPE;
BEGIN
    v_var := IDAS.USER_NEW('admin', 'heslo', 'Jan', '', 'Bedna', 'admin@upce.cz', 1);
    DBMS_OUTPUT.PUT_LINE('NEW USER: ' || v_var);
end;

-- ||| Nastavení uživateli administrátorská práva
BEGIN

end;