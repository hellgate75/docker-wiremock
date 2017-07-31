#!/bin/bash
FLAG_WIREMOCK="$(status-wiremock-server)"

netstat -anp

   echo '                    ____' \
&& echo '                   |  _ \            _   _  ' \
&& echo '                   | | | | ___  ___ | | / /___  _  __' \
&& echo '                   | | | |/ _ \/  _|| |/ // _ \| |/ _|' \
&& echo '                   | |_| | (_) | |__| |\ \  __||  ꜥ' \
&& echo '                   |____/ \___/\___/|_| \_\___||__|' \
&& echo "" \
&& echo '/$$      /$$ /$$                     /$$      /$$                     /$$' \
&& echo '| $$  /$ | $$|__/                    | $$$    /$$$                    | $$' \
&& echo '| $$ /$$$| $$ /$$  /$$$$$$   /$$$$$$ | $$$$  /$$$$  /$$$$$$   /$$$$$$$| $$   /$$' \
&& echo '| $$/$$ $$ $$| $$ /$$__  $$ /$$__  $$| $$ $$/$$ $$ /$$__  $$ /$$_____/| $$  /$$/' \
&& echo '| $$$$_  $$$$| $$| $$  \__/| $$$$$$$$| $$  $$$| $$| $$  \ $$| $$      | $$$$$$/' \
&& echo '| $$$/ \  $$$| $$| $$      | $$_____/| $$\  $ | $$| $$  | $$| $$      | $$_  $$' \
&& echo '| $$/   \  $$| $$| $$      |  $$$$$$$| $$ \/  | $$|  $$$$$$/|  $$$$$$$| $$ \  $$' \
&& echo '|__/     \__/|__/|__/       \_______/|__/     |__/ \______/  \_______/|__/  \__/'
echo ""
echo "WireMock Server ($WM_VERSION)"
echo ""
if [[ "yes" == "$WM_USE_SSL" ]]; then
  echo "WireMock Server Console: http://0.0.0.0:$WM_HTTPS_PORT"
else
  echo "WireMock Server Console: http://0.0.0.0:$WM_HTTP_PORT"
fi
echo ""
echo "Server status : $FLAG_WIREMOCK"
echo ""
echo ""
