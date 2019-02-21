CREATE TABLE TRAZABILIDAD (
 STATUS VARCHAR2(2) NOT NULL,
 MENSAJE  VARCHAR2(500) NOT NULL);

CREATE TABLE DEPART (
 DEPT_NO  NUMBER(2) NOT NULL,
 DNOMBRE  VARCHAR2(14),
 LOC      VARCHAR2(14) ) ;

INSERT INTO DEPART VALUES (10,'CONTABILIDAD','SEVILLA');
INSERT INTO DEPART VALUES (20,'INVESTIGACION','MADRID');
INSERT INTO DEPART VALUES (30,'VENTAS','BARCELONA');
INSERT INTO DEPART VALUES (40,'PRODUCCION','BILBAO');
COMMIT;

CREATE OR REPLACE TRIGGER eliminar_registro_previo
    BEFORE DELETE
    ON DEPART
    FOR EACH ROW
BEGIN
    INSERT INTO TRAZABILIDAD VALUES('OK', 'Preparado para eliminar : ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') || ' el registro con nombre : ' || :OLD.DNOMBRE);
END;

CREATE OR REPLACE TRIGGER eliminar_registro_despues
    AFTER DELETE
    ON DEPART
    FOR EACH ROW
DECLARE
    e_protegido EXCEPTION;   
BEGIN
    IF (:OLD.DEPT_NO = 10) THEN
        RAISE e_protegido;
    END IF;
    INSERT INTO TRAZABILIDAD VALUES('OK', 'Eliminado : ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') || ' el registro con nombre : ' || :OLD.DNOMBRE);
EXCEPTION
    WHEN e_protegido THEN
        RAISE_APPLICATION_ERROR(-20000, 'Protegido');
END;

CREATE OR REPLACE TRIGGER insertar_registro
    BEFORE INSERT
    ON DEPART
    FOR EACH ROW
DECLARE
    e_protegido EXCEPTION;   
BEGIN
    IF (:NEW.DEPT_NO = 10) THEN
        RAISE e_protegido;
    END IF;
    INSERT INTO TRAZABILIDAD VALUES('OK', 'Insertado : ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') || ' el registro con nombre : ' || :NEW.DNOMBRE);
EXCEPTION
    WHEN e_protegido THEN
        RAISE_APPLICATION_ERROR(-20000, 'No se puede hacer inserción');
END;

CREATE OR REPLACE TRIGGER actualizar_registro
    BEFORE UPDATE
    ON DEPART
    FOR EACH ROW
DECLARE
    e_protegido EXCEPTION;   
    e_noupdate EXCEPTION; 
BEGIN
    IF (:NEW.DEPT_NO = 10) THEN
        RAISE e_protegido;
    END IF;
    IF (:NEW.DEPT_NO = :OLD.DEPT_NO AND :NEW.DNOMBRE = :OLD.DNOMBRE AND :NEW.LOC = :OLD.LOC) THEN
        RAISE e_noupdate;
    END IF;
    INSERT INTO TRAZABILIDAD VALUES('OK', 'Actualizado el registro con número : ' || :NEW.DEPT_NO);
    IF (:NEW.DEPT_NO <> :OLD.DEPT_NO) THEN 
        INSERT INTO TRAZABILIDAD VALUES('OK', 'Actualizado previo : ' || :OLD.DEPT_NO || ' por el nuevo : ' || :NEW.DEPT_NO);
    END IF;
    IF (:NEW.DNOMBRE <> :OLD.DNOMBRE) THEN 
        INSERT INTO TRAZABILIDAD VALUES('OK', 'Actualizado previo : ' || :OLD.DNOMBRE || ' por el nuevo : ' || :NEW.DNOMBRE);
    END IF;
    IF (:NEW.LOC <> :OLD.LOC) THEN 
        INSERT INTO TRAZABILIDAD VALUES('OK', 'Actualizado previo : ' || :OLD.LOC || ' por el nuevo : ' || :NEW.LOC);
    END IF;
EXCEPTION
    WHEN e_protegido THEN
        RAISE_APPLICATION_ERROR(-20000, 'No se puede hacer actualización. Registro protegido');
    WHEN e_noupdate THEN
        RAISE_APPLICATION_ERROR(-20000, 'No hay valores nuevos para actualizar');
END;