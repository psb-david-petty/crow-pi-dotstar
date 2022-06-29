#!/usr/bin/env sh
#
# raspi.sh
#
# run this with "sudo sh -x raspi.sh"
#

# Check whether 'sudo raspi-config' has been run.
read -p "Have you completed \"sudo raspi-config\" [Y/n]? " yn
msg="raspi-config: Advanced > Expand Filesystem and Interface > SSH, SPI, & I2C."
case "$yn" in
    n*) echo "$msg"; exit ;;
    N*) echo "$msg"; exit ;;
esac

# Update raspbian.
dpkg --configure -a
apt full-upgrade -y
apt-get update -y
apt autoremove -y
apt-get upgrade -y

# Install Python.
apt-get install build-essential python3-dev python3-smbus python3-pip python3-pil liblircclient-dev -y
apt clean -y

# Clone CrowPi drivers and examples.
git clone https://github.com/Elecrow-RD/CrowPi.git
# cd CrowPi/Drivers
# DID NOT run `sudo python3 setup.py install` in each directory

# Install CircuitPython for RaspberryPi.
# https://learn.adafruit.com/circuitpython-on-raspberrypi-linux/installing-circuitpython-on-raspberry-pi
# https://gallaugher.com/makersnack-installing-circuitpython-on-a-raspberry-pi/
# CircuitPython DotStar
pip3 install --upgrade setuptools
pip3 install --upgrade adafruit-python-shell

echo "After roboot, run \"python3 blinkatest.py\""
echo "After roboot, run \"sudo pip3 install adafruit-circuitpython-dotstar\""
echo "After roboot, run \"sudo apt-get install emacs -y\""
exit
# Run RaspberryPi Blinka installer script.
wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/raspi-blinka.py
python3 raspi-blinka.py
# REBOOT...

# After reboot, run "sudo pip3 install adafruit-circuitpython-dotstar" and anything else...
