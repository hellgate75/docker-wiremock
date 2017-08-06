#!/bin/bash

function set_crontab_task() {
  if ! [[ -e /var/spool/cron/crontabs/root  ]]; then
    ln -s /etc/crontab /var/spool/cron/crontabs/$3
  fi
  echo "set_crontab_task $1 $2 $3 $4"
  CRON_MINS="$1"
  CRON_HOUR="$2"
  if [[ -z "$CRON_HOUR" ]]; then
    CRON_HOUR="*"
  fi
  if [[ -z "$CRON_MINS" ]]; then
    CRON_MINS="*"
  fi
  if ! [[ -z "$(echo $CRON_MINS | grep ',')" ]]; then
    TIME_BLOCKS=""
    export IFS=",";read -ra TIME_BLOCKS <<< "$CRON_MINS"
    for minute in "${TIME_BLOCKS[@]}"; do
      if ! [[ -z "$(echo $CRON_HOUR | grep ',')" ]]; then
        TIME_BLOCKS=""
        export IFS=",";read -ra TIME_BLOCKS <<< "$CRON_HOUR"
        for hour in "${TIME_BLOCKS[@]}"; do
          echo "$minute $hour	* * *	$3    /bin/bash -c $4" >> /var/spool/cron/crontabs/$3
        done
      else
        echo "$minute $CRON_HOUR	* * *	$3    /bin/bash -c $4" >> /var/spool/cron/crontabs/$3
      fi
    done
  else
    if ! [[ -z "$(echo $CRON_HOUR | grep ',')" ]]; then
      TIME_BLOCKS=""
      export IFS=",";read -ra TIME_BLOCKS <<< "$CRON_HOUR"
      for hour in "${TIME_BLOCKS[@]}"; do
        echo "$CRON_MINS $hour	* * *	$3    /bin/bash -c $4" >> /var/spool/cron/crontabs/$3
      done
    else
      echo "$CRON_MINS $CRON_HOUR	* * *	$3    /bin/bash -c $4" >> /var/spool/cron/crontabs/$3
    fi
  fi
}
if [[ $# -lt 3 ]]; then
  echo "Usage: set-crontab-job mm hh user cmd"
  echo "Insufficient number of parameters : $#"
  exit 1
fi
echo "Setup job for crontab on user $3 : $4 at mm: $1, hh: $2 ..."
echo "$(set_crontab_task "$1" "$2" "$3" "$4")"
