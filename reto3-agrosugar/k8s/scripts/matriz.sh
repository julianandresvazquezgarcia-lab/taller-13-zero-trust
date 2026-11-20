

#!/usr/bin/env bash

probar() {
  origen="$1"
  destino="$2"
  puerto="$3"

  if kubectl -n agrosugar exec "$origen" -- python -c 'import socket,sys; socket.create_connection((sys.argv[1],int(sys.argv[2])),4).close()' "$destino" "$puerto" >/dev/null 2>&1
  then
    echo "$origen -> $destino:$puerto PERMITIDO"
  else
    echo "$origen -> $destino:$puerto NO CONECTA"
  fi
}

probar sensor-autorizado mqtt-broker 1883
probar sensor-autorizado db-transaccional 5432
probar sensor-intruso mqtt-broker 1883
probar sensor-intruso db-transaccional 5432
