-- ||| USERS_STATUS
INSERT INTO USERS_STATUS (STATUS_ID, NAME) VALUES (0, 'Neaktivní');
INSERT INTO USERS_STATUS (STATUS_ID, NAME) VALUES (1, 'Aktivní');
COMMIT;

-- ||| USERS
INSERT INTO USERS (USERNAME, PASSWORD, FIRST_NAME, MIDDLE_NAME, LAST_NAME, EMAIL, STATUS_ID, ADMIN) VALUES ('vrana', 'ucitel', 'Daniel', 'Marek', 'Vrána', 'vrana@upce.cz', 1, 0);
INSERT INTO USERS (USERNAME, PASSWORD, FIRST_NAME, MIDDLE_NAME, LAST_NAME, EMAIL, STATUS_ID, ADMIN) VALUES ('hejduk', 'qwertz', 'Jiří', null, 'Hejduk', 'st11111@student.upce.cz', 1, 0);
INSERT INTO USERS (USERNAME, PASSWORD, FIRST_NAME, MIDDLE_NAME, LAST_NAME, EMAIL, STATUS_ID, ADMIN) VALUES ('zalesky', 'wasd', 'Zdeněk', null, 'Záleský', 'st22222@student.upce.cz', 1, 0);
INSERT INTO USERS (USERNAME, PASSWORD, FIRST_NAME, MIDDLE_NAME, LAST_NAME, EMAIL, STATUS_ID, ADMIN) VALUES ('novak', 'qwertz', 'Petr', 'Milan', 'Novák', 'st33333@student.upce.cz', 0, 0);
INSERT INTO USERS (USERNAME, PASSWORD, FIRST_NAME, MIDDLE_NAME, LAST_NAME, EMAIL, STATUS_ID, ADMIN) VALUES ('admin', 'heslo', 'Jan', null, 'Bedna', 'admin@upce.cz', 1, 1);
COMMIT;