#!/bin/sh
set -eo pipefail
# logging functions
log() {
	type="$1"; shift
	# accept argument string or stdin
	text="$*"; if [ "$#" -eq 0 ]; then text="$(cat)"; fi
	dt="$(date -R)"
	printf '%s [%s] [Entrypoint]: %s\n' "$dt" "$type" "$text"
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
check_work_dir_valid(){
  dir_name="$1"
  if [ ! -d "/$dir_name" ]
  then
    error "docker running failed! service work directory $dir_name does not exits!"
  fi
}

init_service_user(){
  user_name="$1"
  work_dir_name="$2"
  group_name="$user_name"
  if ! id -u "$group_name" >/dev/null 2>&1; then
    addgroup -S "$group_name"
  fi
  if ! id -u "$user_name" >/dev/null 2>&1; then
    adduser -D -G "$user_name" "$user_name"
    note "system user initialized."
    note "user:group $user_name:$group_name"
    chown -R "$user_name":"$user_name" /"$work_dir_name"
    chmod 1777 /"$work_dir_name"
  fi
}

init_work_dir(){
  echo
  note "work directory check started!"
  work_dir_name="$1"
  check_work_dir_valid "$work_dir_name"
  note "system user create initializing started!"
  service_user_name="$work_dir_name"
  note "user and group name will be the same with work directory name: $work_dir_name as default!"
  init_service_user "$service_user_name" "$work_dir_name"

  note "work directory check done ! "
  note "work directory : /$work_dir_name"
}
_main() {
  is_base=true
  service_jar="$SERVICE_JAR"
  service_name="$SERVICE_NAME"
  work_dir_name=$service_name
  debug="$DEBUG"
  java_opts="-agentlib:jdwp=transport=dt_socket,address=5005,server=y,suspend=n"
  echo
  note "carbon-cloud service [$service_name] initializing started!"
  echo "$@"
  note "debug opt:" $debug

  note "==========================================================="
  security_egd="-Djava.security.egd=file:/dev/./urandom";
  if [ "$service_name" = "carbon-cloud-app" ]
  then
    is_base=true
  else
    is_base=false
  fi
  if [ "$is_base" = true ]
  then
    exec echo "hello carbon cloud!"
  else
    init_work_dir "$work_dir_name"
    echo
    note "welcome to the Carbon Cloud!          have fun~ ^_^) "
    echo java "$java_opts" $security_egd -jar "$service_jar"
    if [ "$debug" = "true" ]
    then
      exec java $java_opts $security_egd -jar /$work_dir_name/$service_jar "$@"
    else
      note "exec " java $security_egd -jar /$work_dir_name/$service_jar "$@"
      exec java $security_egd -jar /$work_dir_name/$service_jar "$@"
    fi
  fi
}
printf "Carbon Cloud"
_main "$@"
