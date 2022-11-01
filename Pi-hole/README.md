## Pi-hole


Pi-hole es una herramienta bloqueadora de anuncios.
Su funcionamiento es simple: será nuestro servidor de DNS. Se configura nuestro router para que pi-hole resuelva todas las queries DNS.
Pasos para su funcionamiento
1. Levantar el contenedor **docker-compose up -d**         
1.1 Pi-hole utiliza el puerto 80 para levantar el servidor web para consulta de estadísticas y configuraciones. Adicionalmente utiliza el puerto 53 para como puerto de escucha del servidor DNS. Si los puertos estuvieran ocupados tendríamos que resolver el conflicto.                
1.1.1 En verisones de Ubuntu y Fedora se añadió un servicio resolv que entra en conflicto con pi-hole por el puerto 53. (Para más información https://sslhow.com/understanding-etc-resolv-conf-file-in-linux). El servicio se puede deshabilitar mediante **sudo systemctl stop systemd-resolved**        
2. Configurar el router para que apunte a pi-hole como servidor de DNS.
3. Acceso mediante http://[local_ip]/admin/index.php con la contraseña que se indique en el docker-compose.yaml

![image](https://user-images.githubusercontent.com/22058960/198906224-14eefee5-f6d0-4147-9ace-6b5acc27ab26.png)

