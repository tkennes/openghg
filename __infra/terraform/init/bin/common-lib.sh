#!/usr/bin/env bash
######################################################################
# Common Libraries for the Databricks scripts. This file should NOT be
# executed on its own, but rather be sourced from the scripts that
# want to use the common functions
######################################################################

######################
# Output and Logging
######################
# ANSI color codes
readonly LIGHT_GREEN='\033[1;32m'
readonly WHITE='\033[1;37m'
readonly LIGHT_CYAN='\033[1;36m'
readonly YELLOW='\033[1;33m'
readonly LIGHT_RED='\033[1;31m'
readonly NO_COLOR='\033[0m'

readonly LOGGING_ENABLED=${EHBO_LOGGING:-1}
readonly LOGGING_DATESTAMP=${EHBO_LOGGING_DATESTAMP:-0}

log::add_date() {
  while IFS= read -r line; do
    printf '%s %s\n' "$(date)" "$line";
  done
}

log::exec() {
  if [[ ${LOGGING_ENABLED} -eq 1 ]]; then
    "$@"
  else
    "$@" >/dev/null
  fi
}

log::print() {
  # Enable verbose output when set.
  if [[ ${LOGGING_ENABLED} -eq 1 ]]; then
    if [[ ${LOGGING_DATESTAMP} -eq 1 ]]; then
      echo $2 -e "$1" | log::add_date
    else
      echo $2 -e "$1"
    fi
  fi
}

log::wait_until() {
  log::notice "$1" -n

  local f="$2"

  while "$f"; do
    sleep 2
    log::print "." -n
  done
  log::print " Done."
}

log::action() {
  log::print "${WHITE}--->${NO_COLOR} $1" "${@:2}"
}

log::ok() {
  log::print "${LIGHT_GREEN}[OK]${NO_COLOR} $1" "${@:2}"
}

log::input() {
  log::print "${WHITE}[INPUT]${NO_COLOR} $1" "${@:2}"
}

log::notice() {
  log::print "${LIGHT_CYAN}[NOTICE]${NO_COLOR} $1" "${@:2}"
}

log::warning() {
  log::print "${YELLOW}[WARNING]${NO_COLOR} $1" "${@:2}"
}

log::error() {
  log::print "${LIGHT_RED}[ERROR]${NO_COLOR} $1" "${@:2}"
}

log::always() {
  echo -e "${LIGHT_RED}${*}${NO_COLOR}"
}

log::strip_colors() {
  sed $1 "s,\x1B\[[0-9;]*[a-zA-Z],,g"
}


####################
# Common Functions
####################
datestamp() {
  date +%Y%m%d
}

datetimestamp() {
  date +%Y%m%d%H%M%S
}
