-- =========================================================
-- ESCENARIO 1: TRANSACCIÓN EXITOSA
-- Descripción: Aprueba una solicitud pendiente, registra la adopción
-- y crea un seguimiento inicial. Si todo sale bien, confirma con COMMIT.
-- =========================================================

DECLARE
    v_id_solicitud   NUMBER;
    v_id_adopcion    NUMBER;
    v_id_seguimiento NUMBER;
BEGIN

    SELECT MIN(sa.id_solicitud)
    INTO v_id_solicitud
    FROM SOLICITUD_ADOPCION sa
    WHERE sa.estado = 'Pendiente'
      AND NOT EXISTS (
          SELECT 1
          FROM ADOPCION a
          WHERE a.id_solicitud = sa.id_solicitud
      );

    UPDATE SOLICITUD_ADOPCION
    SET estado = 'Aprobada'
    WHERE id_solicitud = v_id_solicitud;

    SELECT NVL(MAX(id_adopcion), 0) + 1
    INTO v_id_adopcion
    FROM ADOPCION;

    INSERT INTO ADOPCION (id_adopcion, id_solicitud, estado)
    VALUES (v_id_adopcion, v_id_solicitud, 'Activa');

    SELECT NVL(MAX(id_seguimiento), 0) + 1
    INTO v_id_seguimiento
    FROM SEGUIMIENTO;

    INSERT INTO SEGUIMIENTO (
        id_seguimiento,
        id_adopcion,
        observaciones,
        requiere_visita
    )
    VALUES (
        v_id_seguimiento,
        v_id_adopcion,
        'Primer contacto post-adopción. Animal en buen estado.',
        'N'
    );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Escenario 1 OK - Solicitud ' || v_id_solicitud ||
        ' aprobada. Adopcion ' || v_id_adopcion ||
        ' formalizada con seguimiento ' || v_id_seguimiento || '.'
    );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Escenario 1 - No hay solicitudes Pendientes sin adopcion.');

    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Escenario 1 - Error: ' || SQLERRM);
END;
/

SELECT *
FROM ADOPCION
ORDER BY id_adopcion DESC;

SELECT *
FROM SEGUIMIENTO
ORDER BY id_seguimiento DESC;
-- =========================================================
-- ESCENARIO 2: TRANSACCIÓN CON ROLLBACK
-- Descripción: Intenta registrar una donación con monto negativo.
-- La restricción CHECK de DONACION impide la operación y se hace ROLLBACK.
-- =========================================================

DECLARE
    v_id_donacion NUMBER;
BEGIN

    SELECT NVL(MAX(id_donacion), 0) + 1
    INTO v_id_donacion
    FROM DONACION;

    INSERT INTO DONACION (
        id_donacion,
        id_persona,
        id_refugio,
        monto
    )
    VALUES (
        v_id_donacion,
        1,
        1,
        -500
    );

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Escenario 2 - Transaccion revertida.');
        DBMS_OUTPUT.PUT_LINE('Error capturado: ' || SQLERRM);
END;
/

SELECT *
FROM DONACION
ORDER BY id_donacion DESC;