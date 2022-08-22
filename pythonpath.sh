#!/usr/env sh
#
# pythonpath.sh         # Add this to .bashrc
#
# Sets up PYTHONPATH for executing CrowPi scripts from a shell.
#
# https://stackoverflow.com/a/49418778
join() { local d=$1 s=$2; shift 2 && printf %s "$s${@/#/$d}"; }
PP=$(join ":" \
    "$HOME/CrowPi/Drivers/Adafruit_Python_CharLCD/build/lib/" \
    "$HOME/CrowPi/Drivers/Adafruit_Python_DHT/build/lib.linux-armv7l-cpython-39/" \
    "$HOME/CrowPi/Drivers/Adafruit_Python_GPIO/build/lib/" \
    "$HOME/CrowPi/Drivers/Adafruit_Python_LED_Backpack/build/lib/" \
    "$HOME/CrowPi/Drivers/luma.led_matrix/build/lib/" \
    "$HOME/CrowPi/Drivers/luma.core/build/lib/")
export PYTHONPATH=${PYTHONPATH:+$PYTHONPATH:}$PP
echo $PYTHONPATH
