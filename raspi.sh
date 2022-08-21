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

set -x
cd $HOME

# Update raspbian.
dpkg --configure -a
apt full-upgrade -y
apt-get update -y
apt autoremove -y
apt-get upgrade -y

# Install Python.
apt-get install build-essential python3-dev python3-smbus python3-pip python3-pil libfreetype6-dev libjpeg-dev libopenjp2-7 libtiff5 liblircclient-dev -y
apt clean -y

# Install Luma.LED_Matrix: Display driver for MAX7219, WS2812
# https://luma-led-matrix.readthedocs.io/en/latest/install.html
pip3 install --upgrade --force-reinstall pip setuptools
usermod -a -G spi,gpio pi
python3 -m pip install --upgrade luma.led_matrix

# Clone CrowPi drivers and examples.
git clone https://github.com/Elecrow-RD/CrowPi.git
SETUP='
    CrowPi/Drivers/Adafruit_Python_CharLCD/
    CrowPi/Drivers/Adafruit_Python_DHT/
    CrowPi/Drivers/Adafruit_Python_LED_Backpack/
    CrowPi/Drivers/RFID/SPI-Py/'
for D in $SETUP; do
    cd $HOME/$D
    flag=''
    if [[ "$D" == *"DHT"* ]]; then
	flag='--force-pi'
    fi
    python3 setup.py install $flag
done

# Install CircuitPython for RaspberryPi.
# https://learn.adafruit.com/circuitpython-on-raspberrypi-linux/installing-circuitpython-on-raspberry-pi
pip3 install --upgrade adafruit-python-shell

# Install CircuitPython DotStar
# https://docs.circuitpython.org/projects/dotstar/en/latest/
# Echo messages for after reboot.
echo "After roboot, run \"python3 blinkatest.py\""
echo "After roboot, run \"sudo pip3 install adafruit-circuitpython-dotstar\""
echo "After roboot, run \"sudo apt-get install emacs -y\""
sleep 5s

# RaspberryPi Blinka installer script.
wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/raspi-blinka.py
python3 raspi-blinka.py

# REBOOT...

# After reboot, run "sudo pip3 install adafruit-circuitpython-dotstar" and anything else...
