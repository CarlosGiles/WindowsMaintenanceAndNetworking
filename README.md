![portadatech](https://github.com/user-attachments/assets/31950491-d37c-43a1-986f-71525fc1c0a4)

# 🛠️ Design Document: Script de Mantenimiento y Configuración de Red

**Autor:** Carlos  
**Fecha:** 01/04/2025  
**Versión:** 1.0  
**Nombre del archivo principal:** `Net-Tools-And-Support.bat`

---

## 1. 📌 Objetivo

El propósito de este script es automatizar tareas de mantenimiento de red y limpieza de archivos temporales en estaciones de trabajo con sistema operativo Windows. Incluye opciones para liberar recursos del sistema, gestionar direcciones IP y enviar informes automáticos por correo electrónico a un administrador o equipo técnico.

---

## 2. 🧱 Alcance y funcionalidades

Este script de línea de comandos ofrece las siguientes opciones desde un menú interactivo:

| Opción | Funcionalidad |
|--------|----------------|
| 1 | Eliminar archivos temporales del sistema (`C:\Windows\Temp`) |
| 2 | Eliminar archivos temporales del usuario (`%LOCALAPPDATA%\Temp`) |
| 3 | Configurar IP dinámica por DHCP para la interfaz `Wi-Fi` |
| 4 | Asignar IP estática para red doméstica (`192.168.1.200`) |
| 5 | Asignar IP estática para red de oficina (`192.168.100.200`) |
| 6 | Vaciar la papelera de reciclaje del sistema |
| 7 | Salir del script, generando y enviando un log por correo electrónico |

---

## 3. 🧰 Estructura del script

### 3.1 Variables
- `%LOGDIR%`: Ruta del directorio `logs\YYYY-MM-DD`
- `%LOGFILE%`: Archivo `mantenimiento_log_YYYY-MM-DD_HH-MM.txt` dentro de `%LOGDIR%`

### 3.2 Validación
Se valida que el usuario ingrese un número entre `1` y `7` usando `findstr`.

### 3.3 Registro de eventos
Cada acción realizada por el usuario se registra con fecha y hora en el archivo de log correspondiente.

### 3.4 Organización de logs
Los logs se almacenan automáticamente en una carpeta por día:
```
logs\
└── 2025-04-01\
    └── mantenimiento_log_2025-04-01_10-30.txt
```

### 3.5 Envío de correo
Al finalizar el script, se ejecuta un bloque de PowerShell que:
- Lee el contenido del log
- Adjunta el archivo
- Envía el mensaje vía SMTP con cuerpo y firma

---

## 4. 📩 Requisitos para envío de correo

- Cuenta de correo con autenticación SMTP habilitada
- Clave de aplicación o contraseña segura
- Proveedor SMTP (Office365, Gmail, etc.)
- Permisos para ejecutar PowerShell desde Batch

> **Nota:** La configuración SMTP está embebida en el script. Se recomienda almacenar las credenciales de forma segura.

---

## 5. ⚙️ Personalización recomendada

- Cambiar el nombre de interfaz (`Wi-Fi`, `Ethernet`) si es necesario.
- Configurar la dirección y puerto del servidor SMTP de acuerdo con el proveedor.
- Usar variables de entorno para proteger credenciales en ambientes multiusuario.

---

## 6. 🧪 Ejemplo de ejecución

**Inicio del script:**
```
==============================================
        MANTENIMIENTO Y CONFIGURACION DE RED
==============================================
[1] Eliminar archivos temporales ...
[7] Salir
Selecciona una opcion (1-7):
```

**Correo recibido:**
```
Asunto: Log de mantenimiento - 01/04/2025 10:35:20

[01/04/2025 10:22:15] Eliminados archivos de C:\Windows\Temp
[01/04/2025 10:25:02] Script finalizado y log enviado por correo

---
Este log fue generado automáticamente por el sistema de mantenimiento.
```

---

## 7. 🔧 Seguridad y buenas prácticas

- Se recomienda ejecutar el script con privilegios de administrador.
- Validar que PowerShell no esté restringido por políticas de grupo.
- Mantener el script en una ubicación protegida contra escritura no autorizada.
- Registrar eventos críticos en un sistema de monitoreo adicional si aplica.

---

## 8. 🧭 Futuras mejoras (opcional)

- Opciones para modificar tipos de cuentas (estándar y administrador).
- Integración con herramientas de monitoreo (Zabbix, Nagios, Power BI).
- Logs en formato JSON para procesamiento automatizado.
- Firma digital del script para garantizar integridad.
- Panel de control visual con Dash o PowerShell GUI.
- Adaptar a variables de entorno.
