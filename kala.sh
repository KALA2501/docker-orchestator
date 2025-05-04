#!/bin/bash

echo "🚀 Bienvenida a KALA.sh - Orquestadora de microservicios 🧠"

PS3="¿Qué quieres hacer hoy, Alanis?: "

options=(
  "💣 Reiniciar TODO (limpieza total + build + up)"
  "🔧 Reconstruir solo FRONTEND"
  "🔧 Reconstruir solo USUARIOS-SERVICE"
  "🚀 Solo levantar (docker-compose up)"
  "⛔ Apagar (docker-compose down)"
  "❌ Salir"
)

select opt in "${options[@]}"
do
  case $REPLY in
    1)
      echo "🧼 Apagando y limpiando todo..."
      docker compose down --volumes --remove-orphans --rmi all
      docker system prune -a --volumes -f
      echo "🔨 Recompilando todo desde cero..."
      docker compose build --no-cache
      echo "🚀 Levantando servicios..."
      docker compose up
      break
      ;;
    2)
      echo "🔧 Recompilando solo el frontend..."
      docker compose down -v
      docker compose build --no-cache frontend
      docker compose up
      break
      ;;
    3)
      echo "🔧 Recompilando solo el servicio de usuarios..."
      docker compose down -v
      docker compose build --no-cache usuarios-service
      docker compose up
      break
      ;;
    4)
      echo "🚀 Levantando servicios sin build..."
      docker compose up
      break
      ;;
    5)
      echo "⛔ Apagando servicios..."
      docker compose down
      break
      ;;
    6)
      echo "👋 ¡Hasta luego, Alanis!"
      break
      ;;
    *)
      echo "❗ Opción inválida, intenta de nuevo"
      ;;
  esac
done
