# TOBY - Todos Ofrecemos Bienestar Y Alegría 🐾

**TOBY** es una plataforma integral para la **Adopción de Mascotas**. El sistema está diseñado para apoyar a refugios, fundaciones y organizaciones de bienestar animal en la gestión técnica y administrativa de animales, adoptantes, voluntarios y procesos de seguimiento.

Este proyecto corresponde a el proyecto del curso de **Bases de Datos 2026-10** (Opción 8: Plataforma de Adopción de Mascotas).

## Descripción del Dominio
El sistema resuelve la falta de control estructurado en los procesos de adopción y gestión de recursos dentro de los refugios. Permite supervisar el estado de cada animal, evaluar solicitudes de manera eficiente y mantener un registro riguroso de donaciones y campañas.

### Actores del Sistema
* **Administrador del refugio:** Encargado de la gestión general, sucursales y reportes.
* **Voluntario:** Apoya en campañas, transporte y cuidado de los animales.
* **Adoptante:** Persona interesada en brindar un hogar a una mascota y participar en entrevistas.
* **Donante:** Realiza aportes económicos a campañas o refugios específicos.
* **Equipo de seguimiento:** Encargado de verificar el bienestar del animal tras la adopción.

---

## Consultas Frecuentes del Sistema
El repositorio incluye soporte para las siguientes operaciones críticas:
1. Listado de animales disponibles filtrados por especie y raza.
2. Consulta de solicitudes por estado (pendiente, aprobada, rechazada).
3. Historial de adopciones por adoptante.
4. Seguimientos post-adopción asociados a casos específicos.
5. Reporte de donaciones por persona, refugio o campaña.

---

## Estructura del Repositorio
Para facilitar la navegación, puedes acceder directamente a los componentes del proyecto:

* **Documentación:**
    * [Documento de Análisis (Entrega 1)](./PRIMERA_ENTREGA.docx.pdf) - Descripción del dominio y requisitos.
    * [Documento de Normalización (Entrega 2)](./DOCUMENTO2_Entrga2.pdf) - Análisis de formas normales (1FN, 2FN, 3FN).
* **Scripts de Base de Datos:**
    * [ 01_CREAR_ESTRUCTURA.sql](./01_CREAR_ESTRUCTURA.sql) - Definición de tablas y restricciones (DDL).
    * [ 02_INSERTAR_DATOS.sql](./02_INSERTAR_DATOS.sql) - Carga de datos de prueba (DML).
    * [ 03_Consultas.sql](./03_Consultas.sql) - Consultas frecuentes y reportes solicitados.
    * [ 04_TRIGGERS_PLSQL.sql](./04_TRIGGERS_PLSQL.sql) - Implementación de lógica de negocio avanzada (Triggers y funciones).
    * [ 05_TRANSACCIONES.sql](./05_TRANSACCIONES.sql) - Control de transacciones y consistencia de datos.

---
## Equipo de Trabajo
| Nombre | Rol | Responsabilidades |
| :--- | :--- | :--- |
| **Kevin Santiago Rico** | Líder | Modelo relacional y requisitos funcionales |
| **Valeria Mena** | Integrante | Documento de análisis y modelo Entidad-Relación |
| **Gabriel Bermúdez** | Integrante | Generación de datos (DML) y validación del modelo |
| **Esteban Hernández** | Integrante | Construcción de script DDL y restricciones |

---

