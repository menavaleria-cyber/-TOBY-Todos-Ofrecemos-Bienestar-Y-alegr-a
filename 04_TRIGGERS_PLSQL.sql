
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE SEGUIMIENTO ADD (requiere_visita CHAR(1) DEFAULT ''N'' CHECK (requiere_visita IN (''S'', ''N'')))';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1430 THEN
            NULL;
        ELSE
            RAISE;
        END IF;
END;
/


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE LOG_CAMBIOS_SOLICITUD CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE LOG_CAMBIOS_SOLICITUD (
    id_log NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_solicitud NUMBER,
    estado_anterior VARCHAR2(20),
    estado_nuevo VARCHAR2(20),
    fecha_cambio DATE DEFAULT SYSDATE,
    usuario VARCHAR2(50) DEFAULT USER
);

CREATE OR REPLACE TRIGGER TRG_AUDIT_SOLICITUD
AFTER UPDATE OF estado ON SOLICITUD_ADOPCION
FOR EACH ROW
BEGIN
    IF :OLD.estado != :NEW.estado THEN
        INSERT INTO LOG_CAMBIOS_SOLICITUD
            (id_solicitud, estado_anterior, estado_nuevo)
        VALUES
            (:NEW.id_solicitud, :OLD.estado, :NEW.estado);
    END IF;
END;
/


CREATE OR REPLACE TRIGGER TRG_VALIDAR_ANIMAL_NO_DISPONIBLE
BEFORE INSERT ON SOLICITUD_ADOPCION
FOR EACH ROW
DECLARE
    v_estado VARCHAR2(50);
BEGIN
    SELECT estado
    INTO v_estado
    FROM ANIMAL
    WHERE id_animal = :NEW.id_animal;

    IF v_estado = 'No disponible' THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede crear una solicitud para un animal no disponible');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER TRG_SEGUIMIENTO_VISITA
AFTER INSERT ON SEGUIMIENTO
FOR EACH ROW
BEGIN
    IF :NEW.requiere_visita = 'S' THEN
        UPDATE ADOPCION
        SET estado = 'Activa'
        WHERE id_adopcion = :NEW.id_adopcion;
    END IF;
END;
/


CREATE OR REPLACE PROCEDURE SP_REGISTRAR_ADOPCION (
    p_id_solicitud IN NUMBER
)
AS
    v_estado_solicitud VARCHAR2(50);
    v_id_adopcion NUMBER;
BEGIN
    SELECT estado
    INTO v_estado_solicitud
    FROM SOLICITUD_ADOPCION
    WHERE id_solicitud = p_id_solicitud;

    IF v_estado_solicitud != 'Aprobada' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Solo se puede registrar adopción para solicitudes aprobadas');
    END IF;

    SELECT NVL(MAX(id_adopcion), 0) + 1
    INTO v_id_adopcion
    FROM ADOPCION;

    INSERT INTO ADOPCION (id_adopcion, id_solicitud, estado)
    VALUES (v_id_adopcion, p_id_solicitud, 'Activa');

    COMMIT;
END;
/


CREATE OR REPLACE FUNCTION FN_TOTAL_DONADO (
    p_id_refugio IN NUMBER
)
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(monto), 0)
    INTO v_total
    FROM DONACION
    WHERE id_refugio = p_id_refugio;

    RETURN v_total;
END;
/



SELECT trigger_name, status
FROM user_triggers
WHERE trigger_name IN (
    'TRG_AUDIT_SOLICITUD',
    'TRG_VALIDAR_ANIMAL_NO_DISPONIBLE',
    'TRG_SEGUIMIENTO_VISITA'
);

SELECT FN_TOTAL_DONADO(1) AS total_donado_refugio_1
FROM dual;