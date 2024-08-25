#!/bin/bash

# Iniciar el servicio cron en segundo plano
service cron start
service ssh start

# Ejecutar otros comandos si es necesario

# Mantener el contenedor en ejecución
exec "$@"
