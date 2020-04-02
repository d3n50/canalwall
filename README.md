canalwall
Linux Firewall Block Connection

#Autor: Adrian Ledesma Bello

#Link: https://www.canalhacker.com

ESPAÑOL

Canalwall nos permite bloquear ips usando las reglas iptables.

Este script detecta las conexiones que se establecen en nuestro ordenador con netstat, obviando las conexiones http y https
debido a que se establecen demasiadas conexiones. Por lo que un supuesto atacante podría acceder a través de esos puertos.

El script también utiliza tcpdump para saber si un determinado código está circulando hacia fuera de nuestro ordenador.
Este código debe ser un string aleatorio, como por ejemplo (algo_random_asdfkjhvkjohskjxcsadjfd). Este código se introduce en
algún archivo sensible (jugoso para un atacante, como /etc/passwd), o creamos un archivo llamado passwords.txt e
introducimos el código (nota: Introducir al principio del archivo).

El codigo también se puede añadir a un archivo ejecutable, por ejemplo:

#mv /usr/bin/id /usr/bin/.id
#echo '#!/bin/bash' > /usr/bin/id
#echo "echo .id '$(echo '"$@";echo -e "\e[8m;30m'$code'\e[28m"')' > /usr/bin/id" ####

Cuando el atacante ejecute el comando "id", se ejecutará el comando "/usr/bin/.id" y se añadirá un "echo $codigo" con color invisible
enviando así el código.

Si un atacante accede a nuestro ordenador por conexión http o https, el script no bloqueará la conexión ni avisará de que se ha establecido ninguna conexión, pero si el atacante ejecuta el comando "id" o abre un archivo con el código en su interior, el script avisará de que alguien ha accedido al ordenador y está viendo tu contenido. En este caso, la conexión se bloqueará a los 10 segundos si no se especifica en la ventana emergente.
