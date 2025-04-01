@echo off
setlocal enabledelayedexpansion
title Script de Mantenimiento y Configuracion de Red
color 57

REM Formato de fecha para el log: YYYY-MM-DD
for /f "tokens=2 delims==." %%I in ('"wmic os get localdatetime /value"') do set "dt=%%I"
set "YYYY=!dt:~0,4!"
set "MM=!dt:~4,2!"
set "DD=!dt:~6,2!"
set "LOGFILE=%~dp0mantenimiento_log_!YYYY!-!MM!-!DD!.txt"

:MENU
cls
echo.
echo  ==============================================
echo         MANTENIMIENTO Y CONFIGURACION DE RED
echo  ==============================================
echo.
echo  [1] Eliminar archivos temporales (C:\Windows\Temp)
echo  [2] Eliminar archivos temporales locales (%LOCALAPPDATA%\Temp)
echo  [3] Liberar y renovar IP (Asignar IP dinamica por DHCP)
echo  [4] Asignar IP estatica - Hogar (192.168.1.200)
echo  [5] Asignar IP estatica - Oficina (192.168.100.200)
echo  [6] Vaciar Papelera de reciclaje
echo  [7] Salir
echo.
set /p opcion=Selecciona una opcion (1-7): 

echo %opcion% | findstr /r "^[1-7]$" >nul || (
    echo Opcion no valida. Intentalo de nuevo.
    pause
    goto MENU
)

if "%opcion%"=="1" goto BorrarTempWindows
if "%opcion%"=="2" goto BorrarTempLocal
if "%opcion%"=="3" goto DHCP
if "%opcion%"=="4" goto Hogar
if "%opcion%"=="5" goto Oficina
if "%opcion%"=="6" goto VaciarPapelera
if "%opcion%"=="7" goto SALIR

:BorrarTempWindows
cls
echo Eliminando archivos temporales de C:\Windows\Temp ...
rd /s /q "C:\Windows\Temp" 2>nul
mkdir "C:\Windows\Temp"
echo Archivos temporales de Windows eliminados.
echo [%date% %time%] Eliminados archivos de C:\Windows\Temp >> %LOGFILE%
pause
goto MENU

:BorrarTempLocal
cls
echo Eliminando archivos temporales locales en %LOCALAPPDATA%\Temp ...
rd /s /q "%LOCALAPPDATA%\Temp" 2>nul
mkdir "%LOCALAPPDATA%\Temp"
echo Archivos temporales locales eliminados.
echo [%date% %time%] Eliminados archivos de %LOCALAPPDATA%\Temp >> %LOGFILE%
pause
goto MENU

:DHCP
cls
echo Configurando IP dinamica por DHCP ...
netsh interface ip set address name="Wi-Fi" source=dhcp
netsh interface ip set dns name="Wi-Fi" source=dhcp
ipconfig /release
ipconfig /renew
ipconfig /all
netsh interface ip set dns name="Wi-Fi" static 192.168.1.250
echo IP dinamica configurada.
echo [%date% %time%] Configurada IP por DHCP en Wi-Fi >> %LOGFILE%
pause
goto MENU

:Hogar
cls
echo Asignando IP estatica para Hogar: 192.168.1.200 ...
netsh interface ip set address name="Wi-Fi" static 192.168.1.200 255.255.255.0 192.168.1.254
netsh interface ip set dns name="Wi-Fi" static 192.168.1.250
echo IP estatica de Hogar asignada correctamente.
echo [%date% %time%] Asignada IP estatica Hogar en Wi-Fi >> %LOGFILE%
pause
goto MENU

:Oficina
cls
echo Asignando IP estatica para Oficina: 192.168.100.200 ...
netsh interface ip set address name="Ethernet" static 192.168.100.200 255.255.255.0 192.168.100.1
netsh interface ip set dns name="Ethernet" static 8.8.8.8
echo IP estatica de Oficina asignada correctamente.
echo [%date% %time%] Asignada IP estatica Oficina en Ethernet >> %LOGFILE%
pause
goto MENU

:VaciarPapelera
cls
echo Vaciando la papelera de reciclaje ...
powershell -command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"
echo Papelera de reciclaje vaciada.
echo [%date% %time%] Papelera de reciclaje vaciada >> %LOGFILE%
pause
goto MENU

:SALIR
echo Enviando log por correo...
powershell -ExecutionPolicy Bypass -Command ^
"$from = 'tucorreo@empresa.com'; ^
 $to = 'destinatario@empresa.com'; ^
 $subject = 'Log de mantenimiento - %date%'; ^
 $body = 'Adjunto el log generado por el script de mantenimiento.'; ^
 $smtpServer = 'smtp.office365.com'; ^
 $smtpPort = 587; ^
 $user = 'tucorreo@empresa.com'; ^
 $pass = ConvertTo-SecureString 'TU_CONTRASENA_O_CLAVE_APP' -AsPlainText -Force; ^
 $cred = New-Object System.Management.Automation.PSCredential($user, $pass); ^
 Send-MailMessage -From $from -To $to -Subject $subject -Body $body -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential $cred -Attachments '%LOGFILE%'"

echo [%date% %time%] Script finalizado y log enviado por correo >> %LOGFILE%
echo Script finalizado. Presiona una tecla para cerrar...
pause
exit
