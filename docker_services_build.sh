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

check_pom(){
  check_str_arr="$@"

  return_code=2
  for check_str in $check_str_arr ;do
    if [ -n "$check_str" ];
  then
    if [ -f "pom.xml" ]; then
      grep -wq "$check_str" pom.xml && return_code=0 || return_code=1
      else
        note "dir $(pwd) pom.xml not detected, skip~"
    fi

  fi
  done
  echo $return_code
}
check_base(){
  dir_name=${PWD##*/}
  if [ ! "$dir_name" = "carbon-cloud" ]
  then
    error "base directory is detected as $(pwd), can not perform building, sorry please check again."
  fi

  if [ ! -f "pom.xml" ]
  then
    error "base directory is detected as $(pwd), main pom check failed, can not perform building, sorry please check again."
  fi

  main_pom_flag1="<artifactId>carbon-cloud</artifactId>"
  main_pom_flag2="<groupId>cn.carbonface</groupId>"
  main_pom_flag3="<dependencyManagement>"
  pom_check_ret="$(check_pom "$main_pom_flag1" "$main_pom_flag2" "$main_pom_flag3" )"
  if [ "$pom_check_ret" = 0 ]
  then
      note "base checked!"
  else
      error "base directory is detected as $(pwd), main pom check failed, can not perform building, sorry please check again."
  fi
}

build(){
  target_dir="$1"
  docker_sign="docker-maven-plugin"
  if [ -n "$target_dir" ]
  then
      cd "$target_dir"
      if [ "$(check_pom "$docker_sign")" = 0 ]; then
          note "module $target_dir build docker plugin detected. docker build process initializing!"
          mvn clean package docker:build
      fi
      cd ..
  fi

}
_main(){
  echo "Carbon Cloud product"
  cd ..
  check_base
  dirs=$(ls -l |awk '/^d/ {print $NF}')
  for dir in $dirs; do
    build "$dir"
  done
  note "docker build initialized. Welcome to the Carbon Cloud! have fun~ ^_^)"
}
_main