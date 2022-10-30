![image](https://user-images.githubusercontent.com/22058960/198877232-8686f505-e27d-4e77-ab83-57181429220e.png)

Wake on LAN (WOL, a veces WoL) es un estándar de redes de computadoras Ethernet que permite encender remotamente computadoras apagadas.
Esta funcionalidad está presente en muchas placas base y ha de activarse en la BIOS.
Una vez activada la funcionalidad se puede despertar el equipo de muchas maneras, en este caso vamos a emplear el paquete mágico.
Nos puede servir para conectarnos en remoto a una máquina sin tenerla que tener permanentemente encendida.

Instrucciones para activarlo en Ubuntu:
1. Activar la funcionalidad en la BIOS, en muchas ocasiones bajo las opciones de Power Management. Para cada fabricante se activa de una manera.
2. Ejecutar **sudo ip link show** y analizar cual es la interfaz a través de la cual vas a recibir el paquete.
3. Identificar la MAC de esta interfaz.
4. Ejecutar **sudo ethtool [interfaz elegida]** y ver si la opción "Supports Wake-on" contiene la letra g (compatible con paquete mágico)
5. Si la opción Wake-on tiene una "d" significa que está deshabilitada la funcionalidad. Habrá que ejecutar **sudo ethtool -s [interfaz_elegida] wol g**  
En mi caso voy a emplear una raspberry pi que tengo encendida permanentemente, de tal manera que cuando quiera conectarme al PC lo enciendo remotamente.
Pasos en la Raspberry:
6. Lanzar un ifconfig y seleccionar la interfaz que se va a utilizar para mandar el paquete.
7. etherwake -i [Interfaz del dispositivo local] [MAC en formato 11:22:33:44:55:66]
8. Para mayor comodidad se puede crear un script para encender la máquina (power_on.sh)
