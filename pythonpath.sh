#!/usr/env sh
#
# pythonpath.sh         # Add this to .bashrc
#
# Sets up PYTHONPATH for executing CrowPi scripts from a shell.
#
# https://stackoverflow.com/a/49418778
join() { local d=$1 s=$2; shift 2 && printf %s "$s${@/#/$d}"; }
PP=$(join ":" \
    "~/CrowPi/Drivers/luma.led_matrix/build/lib/" \
    "~/CrowPi/Drivers/luma.core/build/lib/")
export PYTHONPATH=${PYTHONPATH:+$PYTHONPATH:}$PP
echo $PYTHONPATH
