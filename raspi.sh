!/usr/bin/env bash
#
# raspi.sh
#
# run this with "sudo bash raspi.sh"
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
apt-get install build-essential python3-dev python3-smbus python3-pip python3-pil libfreetype6-dev libjpeg-dev libopenjp2-7 libtiff5 liblircclient-dev -y
apt clean -y

# Install Luma.LED_Matrix: Display driver for MAX7219, WS2812
# https://luma-led-matrix.readthedocs.io/en/latest/install.html
pip3 install --upgrade --force-reinstall pip setuptools
usermod -a -G spi,gpio pi
python3 -m pip install --upgrade luma.led_matrix

# Clone CrowPi drivers and examples and run /setup.py in some directories.
PI=/home/pi
rm -rf $PI/CrowPi
git -C $PI clone https://github.com/Elecrow-RD/CrowPi.git
git -C $PI/CrowPi/Drivers clone https://github.com/adafruit/Adafruit_Python_GPIO.git
# TODO: $PI/CrowPi/Drivers directories w/ setup.py cannot have spaces
# TODO: special case: do NOT run setup.py in luma diretories
# TODO: special case: DHT needs --force-pi
SETUP=`find $PI/CrowPi/Drivers/ \
    \( -name "setup.py" -type f \) -print \
    |grep -iv "luma" \
    |xargs -I {} dirname {}`
for D in $SETUP; do
    cd $D
    flag=''
    if [[ "$D" == *"DHT"* ]]; then
	flag='--force-pi'
    fi
    python3 setup.py install $flag
done

# Install CircuitPython for RaspberryPi.
# https://learn.adafruit.com/circuitpython-on-raspberrypi-linux/installing-circuitpython-on-raspberry-pi
pip3 install --upgrade adafruit-python-shell

# Echo messages for after reboot.
TODO='
    python3 blinkatest.py :
    sudo pip3 install adafruit-circuitpython-dotstar :
    sudo apt-get install emacs -y :'
python3 <<EOF
for s in [s.strip() for s in """$TODO""".split(':') if s]:
    print(f'After reboot, "{s}"')
EOF

# Install CircuitPython DotStar after reboot
# https://docs.circuitpython.org/projects/dotstar/en/latest/
# Install emacs after reboot and set it to the git core.editor
sleep 5s

# RaspberryPi Blinka installer script.
wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/raspi-blinka.py
python3 raspi-blinka.py

# REBOOT...

# After reboot, run "sudo pip3 install adafruit-circuitpython-dotstar"
# and anything else in $TODO
