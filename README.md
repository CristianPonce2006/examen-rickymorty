# Rick and Morty Dex - Examen Práctico DAM

**Institución:** Escuela Especializada en Ingeniería ITCA-FEPADE, MEGATEC La Unión  
**Carrera:** Técnico en Ingeniería de Desarrollo de Software  
**Materia:** Desarrollo de Aplicaciones Móviles (DAM)  
**Evaluación:** Tercer Examen Práctico  
**Docente Facilitador:** Ing. Eduardo Vásquez  

---

## 👥 Integrantes del Equipo

- Kelvin Eduardo Cienfuegos Martínez

---

## 📱 Descripción de la Aplicación

Aplicación móvil desarrollada en Flutter para la exploración del universo y catálogo de personajes de la serie animada **Rick and Morty**, consumiendo en tiempo real la API pública oficial (`https://rickandmortyapi.com/api`).

Implementa arquitectura limpia por capas, autenticación simulada (login), gestión de estado reactivo mediante `Provider` y persistencia local de favoritos con `shared_preferences`.

---

## 🚀 Funcionalidades y Cumplimiento de Rúbrica

- **Login Screen:** Pantalla de autenticación interdimensional (usuario: `admin`, clave: `12345`).
- **RF-01 (Catálogo de personajes):** Carga inicial de la primera página desde la API por HTTP con nombre, imagen remota, estado e indicador de color, y especie.
- **RF-02 (Detalle y navegación):** Pantalla de detalle individual con imagen destacada, nombre, estado, y 4 datos adicionales: género, especie, origen del personaje y ubicación actual.
- **RF-03 (Búsqueda por nombre):** Buscador reactivo dentro de los personajes cargados en la página actual (case-insensitive), aviso explícito de alcance en la interfaz y mensaje informativo en caso de no encontrar coincidencias.
- **RF-04 (Paginación):** Barra de paginación inferior con botones *Anterior* y *Siguiente*, indicador de página actual y total de páginas (`Pág X de Y`), y bloqueo automático de botones en los límites (primera y última página).
- **RF-05 (Favoritos persistentes):** Marcado y desmarcado de favoritos en catálogo y detalle con persistencia de IDs en `shared_preferences`. Pantalla dedicada `FavoritesScreen` para consultar la lista de favoritos.
- **RF-06 (Estados de interfaz):** Indicador de progreso de carga (`CircularProgressIndicator`), estado vacío si no hay coincidencias y manejo de errores de conexión con botón de *"Reintentar"*.
- **RT-01 / RT-02:** Deserialización segura `fromJson`, llamadas bajo HTTPS, permiso `INTERNET` en Android y fallbacks visuales ante fallas de carga de imagen remota.

---

## 💻 Instrucciones para Ejecutar

```bash
flutter pub get
flutter test
flutter run
```
