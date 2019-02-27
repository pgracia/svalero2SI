CREATE OR REPLACE TRIGGER depart_disparador
BEFORE INSERT OR DELETE OR UPDATE
ON DEPART
FOR EACH ROW
DECLARE
    e_protegido EXCEPTION;  
    e_noupdate EXCEPTION;
BEGIN
    IF (INSERTING) THEN
        IF (:NEW.DEPT_NO = 10) THEN
            RAISE e_protegido;               
        ELSE
            INSERT INTO TRAZABILIDAD VALUES('OK', 'Insertado : ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') || ' el registro con nombre : ' || :NEW.DNOMBRE);
        END IF;
    END IF;
    IF (UPDATING) THEN
        IF (:NEW.DEPT_NO = 10) THEN
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
        ELSE
            RAISE e_protegido;
        END IF;
    END IF;
    IF (DELETING) THEN       
        IF (:OLD.DEPT_NO = 10) THEN
            RAISE e_protegido;         
        ELSE
            INSERT INTO TRAZABILIDAD VALUES('OK', 'Eliminado : ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') || ' el registro con nombre : ' || :OLD.DNOMBRE);
        END IF;
    END IF;
EXCEPTION
    WHEN e_protegido THEN
        RAISE_APPLICATION_ERROR(-20000, 'No se puede hacer inserción o actualización');
    WHEN e_noupdate THEN
        RAISE_APPLICATION_ERROR(-20000, 'No hay valores nuevos para actualizar');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20000, 'Error desconocido');
END;