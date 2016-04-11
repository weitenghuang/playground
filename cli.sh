#!/usr/bin/env bash

set -e

sys_docker="$(which docker)"
export DOCKER_HOST="tcp://$(vagrant ssh-config | grep HostName | awk '{print $2}' | head -n1):2375"

docker() {
  $sys_docker $@
}

main() {
  command="$1"
  case $command in
    "docker")
      shift
      docker "$@"
      ;;
    "get-docker-host")
      echo "tcp://$(vagrant ssh-config | grep HostName | awk '{print $2}' | head -n1):2375/"
      ;;
  esac
}

main "$@"