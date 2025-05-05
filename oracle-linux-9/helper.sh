#!/bin/bash

set -euo pipefail

function up() {
  docker-compose up --build -d
  return 0
}

function down() {
  docker-compose down
  return 0
}

function pause() {
  docker-compose pause
  return 0
}

function unpause() {
  docker-compose unpause
  return 0
}

function start() {
  docker-compose start
  return 0
}

function stop() {
  docker-compose stop
  return 0
}

function restart() {
  down
  start
  return 0
}

function connect() {
  docker exec -it -u i.vostrilov personal-oracle-linux-9 "/bin/bash"
}

function show_help() {
  echo "Usage: $0 [OPTION]"
  echo "Options:"
  echo "  --help     Display this help message"

  echo "  --up       Up cluster"
  echo "  --down     Shutdown cluster"

  echo "  --pause    Pause cluster"
  echo "  --unpause  Unpause cluster"

  echo "  --start    Start cluster"
  echo "  --start    Stop cluster"

  echo "  --connect  Connect to my-oracle-linux-9 container"
}

function main() {
  if [ $# -eq 0 ]; then
    echo "No options provided. Use --help for usage information."
    exit 1
  fi

  local action="$1"
  shift 1

  case "$action" in
    --help)
      show_help
      ;;
    --up)
      up
      ;;
    --down)
      down
      ;;
    --pause)
      pause
      ;;
    --unpause)
      unpause
      ;;
    --start)
      start
      ;;
    --stop)
      stop
      ;;
    --restart)
      restart
      ;;
    --connect)
      connect
      ;;
    *)
      echo "Invalid option: $action"
      echo "Use --help for usage information."
      exit 1
      ;;
  esac

  return 0
}

main "$@"
