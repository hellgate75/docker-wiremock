#!/bin/bash

function download_file() {
  if [[ -z "$(echo $2|grep -i 'https://')" ]]; then
    curl -L -o $1 $2
    return "$?"
  else
    curl -sSL -o $1 $2
    return "$?"
  fi
}

function import_data() {
  VALUE="$(cat /root/.zookeeper/data/$1)"
  KEY="/$(echo $1| sed 's/\./\//g')"
  echo "KEY: $KEY VALUE: $VALUE"
  zkCli.sh create "$KEY"
  zkCli.sh set "$KEY" "$VALUE"
  return "$?"
}

if ! [[ -e /root/.zookeeper-config-data ]]; then
  if ! [[ -z "$ZOOKEEPER_CONFIGURATION_DATA_TARGZ_URL" ]]; then
    download_file /root/zookeeper-data.tgz $ZOOKEEPER_CONFIGURATION_DATA_TARGZ_URL
    export URL_EXIT_CODE="$?"
    if [[ "0" == "$URL_EXIT_CODE" ]]; then
      echo "URL archive configuration data recovered succesfully!!"
      if [[ -e /root/zookeeper-data.tgz ]]; then
        echo "Decompressing configuration in data pump folder /root/.zookeeper/data ..."
        mkdir /root/.zookeeper/data
        tar -xf /root/zookeeper-data.tgz -C /root/.zookeeper/data
        rm -f /root/zookeeper-data.tgz
        echo "Start data import from folder /root/.zookeeper/data ..."
        FILE_LIST="$(ls /root/.zookeeper/data/)"
        if ! [[ -z "$FILE_LIST" ]]; then
          COUNTER=1
          for file in `ls /root/.zookeeper/data`; do
            if ! [[ -z "$file"  ]]; then
              echo "Importing configuration file : $file"
              IMPORT_DT="$(import_data $file)"
              echo "$IMPORT_DT"
              let COUNTER++
            fi
          done
          echo "Imported configuration items : $COUNTER"
          touch /root/.zookeeper-config-data
        else
          echo "No configuration file present in folder : /root/data"
        fi
      else
        echo "Archive file not present on file sistem, something went wrong retrieving archive configuration data from URL : $ZOOKEEPER_CONFIGURATION_DATA_TARGZ_URL"
      fi
    else
      echo "Error [$URL_EXIT_CODE] retrieving archive configuration data from URL : $ZOOKEEPER_CONFIGURATION_DATA_TARGZ_URL"
    fi
  fi
else
  echo "Zookeeper configuration data already deployed!!"
fi
