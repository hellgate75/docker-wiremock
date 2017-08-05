#!/bin/bash

function set_crontab_task() {
  CRON_MINS="$1"
  CRON_HOUR="$2"
  if [[ -z "$CRON_HOUR" ]]; then
    CRON_MINS=15
  else
    CRON_MINS="*"
  fi
  if [[ -z "$CRON_MINS" ]]; then
    CRON_MINS=15
  else
    CRON_HOUR="*"
  fi
  if ! [[ -z "$(echo $CRON_MINS | grep ',')" ]]; then
    IFS=",";for minute in $CRON_MINS; do
      if ! [[ -z "$(echo $CRON_HOUR | grep ',')" ]]; then
        IFS=",";for hour in $CRON_HOUR; do
          echo "$minute $hour	* * *	$3    $4" >> /etc/crontab
        done
      else
        echo "$minute $CRON_HOUR	* * *	$3    $4" >> /etc/crontab
      fi
    done
  else
    if ! [[ -z "$(echo $CRON_HOUR | grep ',')" ]]; then
      IFS=",";for hour in $CRON_HOUR; do
        echo "$CRON_MINS $hour	* * *	$3    $4" >> /etc/crontab
      done
    else
      echo "$CRON_MINS $CRON_HOUR	* * *	$3    $4" >> /etc/crontab
    fi
  fi
  if ! [[ -e /var/spool/cron/crontabs/root  ]]; then
    ln -s /etc/crontab /var/spool/cron/crontabs/$3
  fi
}
if [[ $# -lt 3 ]]; then
  echo "Usage: set-crontab-job mm hh user cmd"
  echo "Insufficient number of parameters : $#"
  exit 1
fi
echo "Setup job for crontab on user $3 : $4 at mm: $1, hh: $2 ..."
echo "$(set_crontab_task "$1" "$2" "$3" "$4")"
