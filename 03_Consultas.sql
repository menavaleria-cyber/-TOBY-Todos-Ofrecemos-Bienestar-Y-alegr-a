-- ======================================================================
-- CONSULTA #01: Animales disponibles para adopción
-- Descripción: Muestra los animales disponibles junto con su especie, raza y sucursal.
-- Tipo: JOIN + ORDER BY
-- ======================================================================

Select a.id_animal, a.nombre, e.nombre as especie,
    r.nombre as raza, s.nombre as sucursal
From ANIMAL a
Join RAZA r on a.id_raza = r.id_raza
Join ESPECIE e on r.id_especie = e.id_especie
Join SUCURSAL s on a.id_sucursal = s.id_sucursal
Where a.estado = 'Disponible'
Order by a.nombre;

-- ======================================================================
-- CONSULTA #02: Personas con correo mail
-- Descripción: Lista las personas registradas con correo Gmail.
-- Tipo: Consulta básica + funciones texto
-- ======================================================================

Select id_persona, nombres || ' ' || apellidos as nombre_completo,
    documento, correo, telefono
From PERSONA
Where lower(correo) Like '%@mail.com'
Order by apellidos, nombres;

-- ======================================================================
-- CONSULTA #03: Voluntarios disponibles fines de semana
-- Descripción: Muestra voluntarios con disponibilidad los fines de semana.
-- Tipo: INNER JOIN + filtro
-- ======================================================================

Select p.nombres || ' ' || p.apellidos as voluntario,
    p.correo, v.disponibilidad, v.area_apoyo
From VOLUNTARIO v
Join PERSONA p on v.id_persona = p.id_persona
Where upper(v.disponibilidad) Like '%FIN DE SEMANA%'
   OR upper(v.disponibilidad) Like '%FINES DE SEMANA%'
Order by p.apellidos;

-- ======================================================================
-- CONSULTA #04: Top 5 donaciones más altas
-- Descripción: Muestra las donaciones de mayor valor registradas.
-- Tipo: JOIN + FETCH FIRST
-- ======================================================================

Select p.nombres || ' ' || p.apellidos as donante, r.nombre as refugio, d.monto,
    to_char(d.monto, 'FM$999,999,999') as monto_formateado
From DONACION d
Join PERSONA p on d.id_persona = p.id_persona
Join REFUGIO r on d.id_refugio = r.id_refugio
Order by d.monto Desc
FETCH FIRST 5 ROWS ONLY;

-- ======================================================================
-- CONSULTA #05: Solicitudes de adopción registradas
-- Descripción: Muestra todas las solicitudes de adopción con adoptante y animal.
-- Tipo: INNER JOIN 3 tablas
-- ======================================================================

Select sa.id_solicitud, p.nombres || ' ' || p.apellidos as adoptante,
    a.nombre as animal, sa.estado
From SOLICITUD_ADOPCION sa
Join ADOPTANTE ad on sa.id_adoptante = ad.id_adoptante
Join PERSONA p on ad.id_persona = p.id_persona
Join ANIMAL a on sa.id_animal = a.id_animal
Order by sa.id_solicitud;

-- ======================================================================
-- CONSULTA #06: Adopciones y seguimientos
-- Descripción: Muestra las adopciones realizadas junto con su seguimiento.
-- Tipo: JOIN múltiple + LEFT JOIN
-- ======================================================================

Select ad.id_adopcion, p.nombres || ' ' || p.apellidos as adoptante,
    a.nombre as animal, e.nombre as especie, ad.estado as estado_adopcion,
    seg.observaciones
From ADOPCION ad
Join SOLICITUD_ADOPCION sa on ad.id_solicitud = sa.id_solicitud
Join ADOPTANTE apt on sa.id_adoptante = apt.id_adoptante
Join PERSONA p on apt.id_persona = p.id_persona
Join ANIMAL a on sa.id_animal = a.id_animal
Join RAZA rz on a.id_raza = rz.id_raza
Join ESPECIE e on rz.id_especie = e.id_especie
Left Join SEGUIMIENTO seg  on ad.id_adopcion = seg.id_adopcion
Order by ad.id_adopcion;

-- ======================================================================
-- CONSULTA #07: Animales sin solicitudes
-- Descripción: Muestra animales que  tienen solicitudes de adopción pedndientes o sin solicitud.
-- Tipo: LEFT JOIN
-- ======================================================================

Select a.id_animal, a.nombre, e.nombre as especie, r.nombre as raza,
    s.nombre as sucursal
From ANIMAL a
Left Join SOLICITUD_ADOPCION sa on a.id_animal = sa.id_animal
Join RAZA r on a.id_raza = r.id_raza
Join ESPECIE e on r.id_especie = e.id_especie
Join SUCURSAL s on a.id_sucursal = s.id_sucursal
Where sa.id_solicitud IS NULL
   OR sa.estado = 'Pendiente'
Order by e.nombre, a.nombre;

-- ======================================================================
-- CONSULTA #08: Voluntarios que trabajan juntos en campañas
-- Descripción: Muestra pares de voluntarios que participan en la misma campaña.
-- Tipo: SELF JOIN
-- ======================================================================

Select vc1.id_voluntario as voluntario_id, p1.nombres || ' ' || p1.apellidos as voluntario,
    vc2.id_voluntario as compañero_id, p2.nombres || ' ' || p2.apellidos as compañero,
    c.nombre as campaña, vc1.rol as rol_voluntario, vc2.rol as rol_compañero
From VOLUNTARIO_CAMPANIA vc1
Join VOLUNTARIO_CAMPANIA vc2 on  vc1.id_campania = vc2.id_campania
AND vc1.id_voluntario < vc2.id_voluntario
Join VOLUNTARIO v1 on vc1.id_voluntario = v1.id_voluntario
Join PERSONA p1 on v1.id_persona = p1.id_persona
Join VOLUNTARIO v2 on vc2.id_voluntario = v2.id_voluntario
Join PERSONA p2 on v2.id_persona = p2.id_persona
Join CAMPANIA c on vc1.id_campania = c.id_campania
Order by c.nombre, p1.apellidos;

-- ======================================================================
-- CONSULTA #09: Total de animales por especie y estado
-- Descripción: Cuenta los animales agrupados por especie y estado.
-- Tipo: GROUP BY + COUNT
-- ======================================================================

Select e.nombre as especie, a.estado, count(*) as total_animales
From ANIMAL a
Join RAZA r on a.id_raza = r.id_raza
Join ESPECIE e on r.id_especie = e.id_especie
Group by e.nombre, a.estado
Order by e.nombre, a.estado;

-- ======================================================================
-- CONSULTA #10: Voluntarios y horas por campaña
-- Descripción: Calcula el número de voluntarios y horas aportadas por campaña.
-- Tipo: GROUP BY + HAVING
-- ======================================================================

Select c.nombre as campaña, r.nombre as refugio, count(*) as num_voluntarios,
    sum(vc.horas_aportadas) as total_horas
From VOLUNTARIO_CAMPANIA vc
Join CAMPANIA c on vc.id_campania = c.id_campania
Join REFUGIO r on c.id_refugio = r.id_refugio
Group by c.nombre, r.nombre
Having count(*) > 2
Order by num_voluntarios Desc;

-- ======================================================================
-- CONSULTA #11: Estadísticas de donaciones por refugio
-- Descripción: Calcula estadísticas de donaciones registradas por refugio.
-- Tipo: Agregación + LEFT JOIN
-- ======================================================================

Select r.nombre as refugio, count(d.id_donacion) as num_donaciones,
    sum(d.monto) as total_recaudado, ROUND(avg(d.monto), 2) as promedio_donacion,
    min(d.monto) as donacion_minima, max(d.monto) as donacion_maxima
From REFUGIO r
Left Join DONACION d on r.id_refugio = d.id_refugio
Group by r.nombre
Order by total_recaudado Desc Nulls Last;

-- ======================================================================
-- CONSULTA #12: Adopciones y visitas por especie
-- Descripción: Calcula adopciones y visitas agrupadas por especie.
-- Tipo: Agregación + OVER(PARTITION BY)
-- ======================================================================

Select e.nombre as especie, count(Distinct ad.id_adopcion) as total_adopciones,
    count(vi.id_visita) as total_visitas, round(avg(count(vi.id_visita))
          Over(Partition by e.nombre), 1) as promedio_visitas
From ADOPCION ad
Join SOLICITUD_ADOPCION sa on ad.id_solicitud = sa.id_solicitud
Join ANIMAL a on sa.id_animal = a.id_animal
Join RAZA rz on a.id_raza = rz.id_raza
Join ESPECIE e on rz.id_especie = e.id_especie
Left Join VISITA vi on vi.id_solicitud = sa.id_solicitud
Group by e.nombre
Order by total_adopciones Desc;

-- ======================================================================
-- CONSULTA #13: Adoptantes interesados en perros
-- Descripción: Obtiene los adoptantes que han solicitado perros.
-- Tipo: Subconsulta con IN
-- ======================================================================

Select Distinct p.nombres || ' ' || p.apellidos as adoptante, p.correo, apt.tipo_vivienda
From ADOPTANTE apt
Join PERSONA p on apt.id_persona = p.id_persona
Where apt.id_adoptante IN (
    Select sa.id_adoptante
    From SOLICITUD_ADOPCION sa
    Join ANIMAL a on sa.id_animal = a.id_animal
    Join RAZA r on a.id_raza = r.id_raza
    Join ESPECIE e on r.id_especie = e.id_especie
    Where upper(e.nombre) = 'PERRO'
)
Order by adoptante;

-- ======================================================================
-- CONSULTA #14: Refugios con campañas activas
-- Descripción: Muestra refugios que poseen campañas registradas.
-- Tipo: Subconsulta con EXISTS
-- ======================================================================

Select
    r.id_refugio, r.nombre as refugio, r.telefono
From REFUGIO r
Where Exists (
    Select 1
    From CAMPANIA c
    Where c.id_refugio = r.id_refugio
)
Order by r.nombre;

-- ======================================================================
-- CONSULTA #15: Animales con mayor número de vacunas
-- Descripción: Obtiene animales con número de vacunas superior al promedio.
-- Tipo: Subconsulta derivada + HAVING
-- ======================================================================

Select a.id_animal, a.nombre as animal, e.nombre as especie,
    count(av.id_vacuna) as num_vacunas
From ANIMAL a
Join RAZA rz on a.id_raza = rz.id_raza
Join ESPECIE e on rz.id_especie = e.id_especie
Join ANIMAL_VACUNA av on a.id_animal = av.id_animal
Group by a.id_animal, a.nombre, e.nombre
Having count(av.id_vacuna) >= (
    Select avg(total)
    From (
        Select count(*) as total
        From ANIMAL_VACUNA
        Group by id_animal
    )
)
Order by num_vacunas Desc;

-- ======================================================================
-- CONSULTA #16: Resumen de campañas por voluntario
-- Descripción: Muestra voluntarios con más de 10 horas aportadas.
-- Tipo: Subconsulta en FROM
-- ======================================================================

Select p.nombres || ' ' || p.apellidos as voluntario, p.correo,
    resumen.total_campañas, resumen.total_horas
From (
    Select id_voluntario, count(*) as total_campañas, sum(horas_aportadas) as total_horas
    From VOLUNTARIO_CAMPANIA
    Group by id_voluntario
    Having sum(horas_aportadas) > 10
) resumen
Join VOLUNTARIO v on resumen.id_voluntario = v.id_voluntario
Join PERSONA p on v.id_persona = p.id_persona
Order by resumen.total_horas Desc;
-- ======================================================================
-- CONSULTA #17: Personas registradas como adoptantes y voluntarios
-- Descripción: Une adoptantes y voluntarios en una sola lista.
-- Tipo: UNION
-- ======================================================================

Select p.nombres || ' ' || p.apellidos as nombre,
    p.correo, 'Adoptante' as rol
From ADOPTANTE a
Join PERSONA p on a.id_persona = p.id_persona

Union

Select p.nombres || ' ' || p.apellidos as nombre,
    p.correo, 'Voluntario' as rol
From VOLUNTARIO v
Join PERSONA p on v.id_persona = p.id_persona

Order by nombre;

-- ======================================================================
-- CONSULTA #18: Personas que son adoptantes y voluntarios
-- Descripción: Muestra personas registradas simultáneamente como adoptantes y voluntarios.
-- Tipo: INTERSECT
-- ======================================================================

Select p.id_persona, p.nombres || ' ' || p.apellidos as nombre, p.correo
From ADOPTANTE a
Join PERSONA p on a.id_persona = p.id_persona

Intersect

Select p.id_persona, p.nombres || ' ' || p.apellidos as nombre, p.correo
From VOLUNTARIO v
Join PERSONA p on v.id_persona = p.id_persona

Order by nombre;

-- ======================================================================
-- CONSULTA #19: Vista de adopciones exitosas
-- Descripción: Crea una vista con información completa de adopciones completadas.
-- Tipo: VIEW
-- ======================================================================

Create or Replace View VW_ADOPCIONES_EXITOSAS as
Select ad.id_adopcion, p.nombres || ' ' || p.apellidos as adoptante,
    p.correo as correo_adoptante, p.telefono as telefono_adoptante,
    apt.tipo_vivienda, a.nombre as animal, e.nombre as especie,
    rz.nombre as raza, ad.estado as estado_adopcion,
    sa.id_solicitud
From ADOPCION ad
    Join SOLICITUD_ADOPCION sa on ad.id_solicitud = sa.id_solicitud
    Join ADOPTANTE apt on sa.id_adoptante = apt.id_adoptante
    Join PERSONA p on apt.id_persona = p.id_persona
    Join ANIMAL a on sa.id_animal = a.id_animal
    Join RAZA rz on a.id_raza = rz.id_raza
    Join ESPECIE e on rz.id_especie = e.id_especie
    Where ad.estado = 'Finalizada';

-- ======================================================================
-- CONSULTA #20: Consulta de vista de adopciones exitosas
-- Descripción: Consulta la vista de adopciones completadas.
-- Tipo: VIEW
-- ======================================================================

Select * From VW_ADOPCIONES_EXITOSAS
Order by adoptante;

-- ======================================================================
-- CONSULTA #21: Vista resumen de campañas
-- Descripción: Crea una vista resumen de campañas y donaciones.
-- Tipo: VIEW
-- ======================================================================

Create or Replace View VW_RESUMEN_CAMPAÑAS as
Select c.id_campania, c.nombre as campaña, r.nombre as refugio, c.meta_recaudo,
    count(Distinct vc.id_voluntario) as num_voluntarios, sum(vc.horas_aportadas) as total_horas_voluntariado,
    (
        Select sum(d.monto)
        From DONACION d
        Where d.id_refugio = r.id_refugio
    ) as total_donado_al_refugio
From CAMPANIA c
    Join REFUGIO r on c.id_refugio = r.id_refugio
    Left Join VOLUNTARIO_CAMPANIA vc on c.id_campania = vc.id_campania
    Group by c.id_campania, c.nombre, r.nombre, c.meta_recaudo, r.id_refugio;

-- ======================================================================
-- CONSULTA #22: Consulta resumen de campañas
-- Descripción: Consulta la vista resumen de campañas.
-- Tipo: VIEW
-- ======================================================================

Select * From VW_RESUMEN_CAMPAÑAS Order by total_donado_al_refugio Desc Nulls Last;

-- ======================================================================
-- CONSULTA #23: Animales vacunados por especie y vacuna
-- Descripción: Cuenta animales vacunados agrupados por especie y vacuna.
-- Tipo: GROUP BY + JOIN
-- ======================================================================

Select e.nombre    as especie, v.nombre as vacuna, count(*) as animales_vacunados
From ANIMAL_VACUNA av
    Join ANIMAL a on av.id_animal = a.id_animal
    Join RAZA r on a.id_raza = r.id_raza
    Join ESPECIE e on r.id_especie = e.id_especie
    Join VACUNA v on av.id_vacuna = v.id_vacuna
    Group by e.nombre, v.nombre
    Order by e.nombre, animales_vacunados Desc;

-- ======================================================================
-- CONSULTA #24: Adoptantes sin adopciones completadas
-- Descripción: Muestra adoptantes con solicitudes pero sin adopciones completadas.
-- Tipo: Subconsulta con NOT IN
-- ======================================================================

Select Distinct p.nombres || ' ' || p.apellidos as adoptante, p.correo, p.telefono,
    count(sa.id_solicitud) as solicitudes_realizadas
From ADOPTANTE apt
    Join PERSONA p on apt.id_persona = p.id_persona
    Join SOLICITUD_ADOPCION sa on sa.id_adoptante = apt.id_adoptante
    Where apt.id_adoptante Not in (
    Select Distinct sa2.id_adoptante
    From ADOPCION ad2
    Join SOLICITUD_ADOPCION sa2 on ad2.id_solicitud = sa2.id_solicitud
    Where ad2.estado = 'Finalizada'
)
    Group by p.nombres, p.apellidos, p.correo, p.telefono
    Order by solicitudes_realizadas Desc;

-- ======================================================================
-- CONSULTA #25: Direcciones de sucursales
-- Descripción: Muestra la dirección completa de las sucursales registradas.
-- Tipo: INNER JOIN
-- ======================================================================

Select rf.nombre as refugio, s.nombre as sucursal, d.calle || ' #' || d.numero || ', ' ||
    d.barrio || ', ' || d.ciudad as direccion_completa
From SUCURSAL s
    Join REFUGIO rf on s.id_refugio = rf.id_refugio
    Join DIRECCION d on s.id_direccion = d.id_direccion
    Order by rf.nombre, s.nombre;