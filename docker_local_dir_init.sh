#! /bin/bash
set -eo pipefail
# logging functions
log() {
	type="$1"; shift
	# accept argument string or stdin
	text="$*"; if [ "$#" -eq 0 ]; then text="$(cat)"; fi
	dt="$(date -R)"
	printf '%s [%s] [Carbon Cloud]: %s\n' "$dt" "$type" "$text"
}
note() {
	log Note "$@"
}
warn() {
	log Warn "$@" >&2
}
error() {
	log ERROR "$@" >&2
	exit 1
}

docker_config_load(){
  cat docker-compose.yml | while read line
    do
        if [ "$(echo "$line"| grep ^#)" ]; then
            continue 
        fi
#        echo "$line"
    done
}
init_local_directory(){
  local_base="$1"
  if [ -z "$local_base" ];
  then
      note "local base directory is not defined. Use the default dir ~/CarbonCloud"
      local_base="$HOME/CarbonCloud"
  else
     note "local base directory is defined as $local_base"
  fi
  if [ -d "$local_base" ]; then
      note "Local base dir $local_base existed. Removing content of the $local_base ..."
      if [ -d "$local_base/databases" ]; then
          rm -R "$local_base/databases"
      fi
      if [ -d "$local_base/services" ]; then
          rm -R "$local_base/services"
      fi
  else
      note "Creating local base dir $local_base ..."
      mkdir "$local_base"
  fi
  services_dirs=$(ls -l services |awk '/^d/&&!/docker-base$/ {print $NF}')
  note "services dirs initializing started"
  for service_dir in $services_dirs; do
    mkdir -p "$local_base/services/$service_dir"
  done
  note "services dirs initialized."

  note "initializing mysql local dir..."
  mkdir -p "$local_base/databases/mysql/conf" "$local_base/databases/mysql/db"
  cp ./databases/mysql/my.cnf "$local_base"/databases/mysql/conf/

  note "initializing mongo local dir..."
  mkdir -p "$local_base/databases/mongo/conf" "$local_base/databases/mongo/db" "$local_base/databases/mongo/log"
  cp ./databases/mongo/mongod.conf "$local_base"/databases/mongo/conf/

  note "initializing redis local dir..."
  mkdir -p "$local_base/databases/redis/conf" "$local_base/databases/redis/db"
  cp ./databases/redis/redis.conf "$local_base"/databases/redis/conf/

}
_main(){
  note "Carbon Cloud product"
  sh_work_dir=$(pwd)
  note "Carbon Cloud docker local mounted directory initialing started!"
  note "Shell working directory is: $sh_work_dir"
  echo
  note "Loading docker-compose config file..."

  docker_config_load
  init_local_directory "$1"

  note "Local docker dir initialized."
  note "Welcome to the Carbon Cloud! have fun~ ^_^)"
}
_main "$@"
