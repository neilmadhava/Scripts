#!/bin/bash

battery_status=`cat /sys/class/power_supply/BAT1/status`
battery_capacity=`cat /sys/class/power_supply/BAT1/capacity`

#echo "Battery Capacity: $battery_capacity"
#echo "Battery Status: $battery_status"

# for discharge
if [[ $battery_status == "Discharging" && $battery_capacity -le 60 ]]; then
	XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send -u critical -i info 'Plug-in Charger' 'Battery less than 60%'
fi

# for charge
if [[ $battery_status == "Charging" && $battery_capacity -ge 85 ]]; then
	XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send -u critical -i info 'Plug-out Charger' 'Battery more than 85%'
fi
