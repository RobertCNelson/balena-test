#!/bin/bash
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
export SERID="$(hexdump -e '8/1 "%c"' /sys/bus/i2c/devices/0-0050/eeprom -n 28 | cut -b 25-28 | tr 'A-Z' 'a-z')"
: "${PORTAL_SSID:=BeagleBone-$SERID}"
: "${PORTAL_PASSPHRASE:=BeagleBone}"
: "${APSLEEP:=120}"
: "${APTIMEOUT:=360}"
: "${APFORCE:=}"

export APLED=/sys/class/leds/beaglebone:green:usr0

echo "start.sh on $SERID"

function ap {
  while true; do
    # ip route | grep default
    # nmcli -t g | grep full
    wget --spider http://google.com > /dev/null 2>&1
    # iwgetid -r
    if [ $? -ne 0 ] || [ "x$APFORCE" != "x" ]; then
      printf 'Starting WiFi Connect\n'
      echo timer > $APLED/trigger
      echo "$PORTAL_SSID:$PORTAL_PASSPHRASE"
      timeout $APTIMEOUT ./wifi-connect -s "$PORTAL_SSID" -p "$PORTAL_PASSPHRASE"
      echo heartbeat > $APLED/trigger
      wget --spider http://google.com > /dev/null 2>&1
      if [ $? -eq 0 ]; then
        # Sleep a bit longer after connecting
        sleep 600
      fi
    else
      printf 'Skipping WiFi Connect\n'
    fi
    sleep $APSLEEP
  done
}

ap &

/opt/bb-code-server/start.sh &

sleep infinity

