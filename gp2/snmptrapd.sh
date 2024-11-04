#!/bin/bash

MIB_OPTIONS="-M +./mibs -m ALL"

set -x
sudo snmptrapd $MIB_OPTIONS -f -Lo -C -c /home/vagrant/gp2/snmptrapd.p2.conf 
