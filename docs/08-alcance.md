# Alcance y límites de la documentación

## Procedencia

La documentación y los scripts se organizan a partir de los comandos, resultados y capturas compartidos en la sesión de construcción. Las capturas son originales; las referencias Cisco y las secuencias PowerShell son reconstrucciones documentales, no exports completos ni una transcripción byte a byte. No se afirma haber ejecutado desde este repositorio una instalación nueva.

La comprobación del código del repositorio es estática y no reemplaza pruebas sobre las VMs. Los exports reales deben incorporarse antes de cerrar el requisito de running-configs. Los diagramas describen el diseño y no son capturas del proyecto GNS3.

## Límites del laboratorio

- El enlace 203.0.113.0/30 es de documentación; simula IP públicas dentro del laboratorio.
- La VPN observada negocia DES/SHA1. Es criptografía heredada para reproducir este entorno de evaluación, no una configuración apta para producción.
- La VPN se autentica por PSK compartida; los permisos de aplicaciones se basan en AD al entrar al Jump.
- El administrador del FortiGate accedió por HTTP debido a fallos TLS de la VM evaluativa; esta administración no debe exponerse fuera del laboratorio.
- Los certificados son autofirmados. Las capturas contienen avisos de confianza del navegador; no prueban una cadena PKI pública validada.
- RDS se usa en evaluación. El comando para PerUser no acredita CAL instaladas ni elimina requisitos de licenciamiento.
- Caja almacena datos en localStorage de Firefox en Jump. No hay base de datos independiente ni garantías de durabilidad de producción.
- La publicación RemoteApp por grupos no demuestra una restricción completa de ejecución de programas o del escritorio. El bloqueo SSH sí tiene regla explícita por SID y una prueba asociada.
- La regla Windows cubre TCP/22. No se afirma protección frente a SSH en puertos alternativos; la política FortiGate hacia Web limita los servicios autorizados.
- Los usuarios de dominio de la demostración no equivalen a los usuarios locales de Ubuntu con los que se instaló strongSwan.
- No se verificó una topología de VMnet exportada; debe impedir puentes que eviten el firewall.
- Una captura posterior muestra el portal inaccesible. Su resolución debe confirmarse antes de grabar, sin invalidar las pruebas previas fechadas.
- FortiGate mostró reloj desincronizado. Corregirlo para una demostración con fecha/hora coherentes.

## Integridad académica

La tarea es individual. El estudiante debe revisar los archivos, entender las configuraciones y grabar personalmente la demostración de su entorno. No se incluyen resultados generados como si provinieran del laboratorio ni se sustituyen exports faltantes por salidas simuladas. Las instrucciones de entrega y el uso de herramientas de asistencia deben respetar las normas del docente.
