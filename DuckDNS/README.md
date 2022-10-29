DuckDNS se trata de un servicio de DNS dinámico que nos permitirá asignar un dominio ,fácilmente memorizable, a nuestra IP pública.
Se trata de una herramienta muy util si tu operadora cambia tu IP pública con frecuencia.
Su funcionamiento es sencillo, se da de alta un subdominio [subdominio].duckdns.org
Posteriormente see desplegará un contenedor asociado a ese dominio que cada 5 minutos (configurable) realizará una consulta a los servdores de DuckDNS
informando sobre la IP actual. De esta manera cada vez que la operadora cambie tu IP, con un downtime máximo de 5 minutos volverás a poder acceder a tu dominio.

Enlace: www.duckdns.org
