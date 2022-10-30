#!/bin/bash
echo "Power on..."
etherwake -i [Interfaz desde la que se va a enviar el paquete] [MAC de la interfaz a donde se va a mandar el paquete]
sleep 15 #Tiempo en segundos. Cambiar en función del tiempo que tarde en arrancar la máquina
