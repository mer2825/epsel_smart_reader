# Manual de Usuario - Epsel Smart Reader

Bienvenido al manual de usuario del sistema de lectura inteligente de medidores de Epsel S.A.

Este sistema se compone de dos partes principales:
1.  **El Panel Web de Administración:** Para el personal de jefatura, accesible desde cualquier navegador web.
2.  **La Aplicación Móvil:** Para los trabajadores de campo, instalable en dispositivos Android.

---

## 1. Manual del Jefe (Panel Web)

El panel web permite gestionar trabajadores, asignar tareas y monitorear el progreso de las lecturas.

### 1.1. Acceso al Panel

1.  Abra un navegador web (como Chrome, Edge, etc.).
2.  Navegue a la siguiente URL: [https://epsel-smart-reader.web.app](https://epsel-smart-reader.web.app)
3.  Se le presentará una pantalla de inicio de sesión.

### 1.2. Inicio de Sesión

1.  Ingrese sus credenciales de **Jefe** (correo y contraseña) proporcionadas por el administrador.
2.  Haga clic en el botón "ACCEDER AL DASHBOARD".
3.  Si las credenciales son correctas, accederá al panel de control principal.

### 1.3. Crear un Nuevo Trabajador

1.  En el panel de control, haga clic en la tarjeta **"Técnicos"**.
2.  Será redirigido a la pantalla de "Monitoreo de Campo". Haga clic en el botón flotante azul **"+ Registrar Nuevo"** en la esquina inferior derecha.
3.  Complete el formulario con los datos del nuevo trabajador. **Importante:** La contraseña inicial del trabajador será su número de DNI.
4.  Haga clic en **"GUARDAR"**. El nuevo trabajador será creado y aparecerá en la lista.

### 1.4. Asignar una Tarea (Ruta) a un Trabajador

1.  Desde la pantalla de "Monitoreo de Campo", haga clic en la fila del trabajador al que desea asignarle una tarea.
2.  Se abrirá el formulario de "Asignación de Tareas" con los datos del trabajador ya cargados.
3.  Complete los detalles de la ruta (Localidad, Calle, Sector, etc.).
4.  Seleccione una **fecha** para la asignación.
5.  Haga clic en **"GUARDAR"**. La tarea será asignada y el trabajador podrá verla en su aplicación móvil.

---

## 2. Manual del Trabajador (Aplicación Móvil)

La aplicación móvil permite a los trabajadores de campo ver sus tareas asignadas y registrar las lecturas de los medidores.

### 2.1. Instalación de la Aplicación

1.  La aplicación se distribuye a través de un archivo de instalación `.apk`.
2.  Transfiera el archivo `app-release.apk` a su dispositivo Android.
3.  Abra el archivo en su dispositivo y siga las instrucciones para instalar la aplicación. Es posible que deba otorgar permisos para instalar aplicaciones de fuentes desconocidas.

### 2.2. Inicio de Sesión

1.  Abra la aplicación "Epsel Smart Reader".
2.  Seleccione el rol "Trabajador".
3.  Ingrese las credenciales proporcionadas por su jefe de zona:
    *   **Correo:** Su correo electrónico corporativo.
    *   **Contraseña:** Su número de **DNI**.
4.  Haga clic en "Iniciar sesión".

### 2.3. Ver y Realizar Tareas

1.  Al iniciar sesión, verá una lista de sus **"Tareas Asignadas"**. Cada tarjeta representa una ruta de lectura.
2.  **Toque la tarjeta de la tarea** que desea realizar.
3.  Se abrirá una pantalla con la lista de **suministros (medidores)** que debe leer en esa ruta.
4.  **Toque el suministro** que va a leer.
5.  Se abrirá la pantalla del escáner con la cámara activada.

### 2.4. Capturar y Guardar una Lectura

1.  Apunte la cámara al número del medidor, asegurándose de que esté bien enfocado dentro del recuadro.
2.  Presione el botón **"CAPTURAR LECTURA"**.
3.  Aparecerá un diálogo de confirmación con el número detectado por el sistema.
    *   Si el número es correcto, haga clic en **"CONFIRMAR"**.
    *   Si el número es incorrecto, haga clic en **"REINTENTAR"** y capture la foto de nuevo.
4.  Al confirmar, la aplicación guardará la lectura en el sistema y usted volverá a la lista de suministros.

---
Fin del Manual.
