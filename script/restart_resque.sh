#!/bin/bash
#
# Stops and then starts resque-pool in either production or development environment
# script/restart_resque.sh [production|development]

ENVIRONMENT=$1
APP_DIRECTORY="/srv/apps/curate_uc"
RESQUE_POOL_PIDFILE="/tmp/scholar-resque-pool.pid"
HOSTNAME=$(hostname -s)

function banner {
    echo -e "$0 ↠ $1"
}

if [ $# -eq 0 ]; then
    echo -e "ERROR: no environment argument [production|development] provided"
    exit 1
fi

if [ $ENVIRONMENT != "production" ] && [ $ENVIRONMENT != "development" ]; then
    echo -e "ERROR: environment argument must be either [production|development] most likely this will be development for local machines and production otherwise"
    exit 1
fi

banner "killing resque-pool"
[ -f $RESQUE_POOL_PIDFILE ] && {
    PID=$(cat $RESQUE_POOL_PIDFILE)
    kill -9 $PID
}
sleep 10

banner "starting resque-pool"
bundle exec resque-pool --daemon --environment $ENVIRONMENT --config $APP_DIRECTORY/config/resque-pool.yml --pidfile $RESQUE_POOL_PIDFILE --stdout $APP_DIRECTORY/log/resque-pool.stdout.log --stderr $APP_DIRECTORY/log/resque-pool.stderr.log start