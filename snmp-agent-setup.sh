#!/bin/bash

# /etc/hosts
chmod a+r /etc/hosts

# Update SNMP config /cat-touch
sudo apt-get update
sudo apt-get -y install snmpd libsnmp-dev snmp snmp-mibs-downloader unzip
sudo download-mibs

#How to fix net-snmp / snmpwalk errors #https://docs.linuxconsulting.mn.it/notes/net-snmp-errors #https://serverfault.com/questions/936119/snmp-mibs-on-ubuntu-error-in-mibs
sudo wget http://www.iana.org/assignments/ianaippmmetricsregistry-mib/ianaippmmetricsregistry-mib -O /usr/share/mibs/iana/IANA-IPPM-METRICS-REGISTRY-MIB
sudo wget http://pastebin.com/raw.php?i=p3QyuXzZ -O /usr/share/mibs/ietf/SNMPv2-PDU
sudo wget http://pastebin.com/raw.php?i=gG7j8nyk -O /usr/share/mibs/ietf/IPATM-IPMC-MIB

# Unzip the auxiliar data
unzip /home/vagrant/gp2.zip
rm /home/vagrant/gp2.zip
chgrp -f -R vagrant /home/vagrant/gp2
chown -f -R vagrant /home/vagrant/gp2
chmod 555 /home/vagrant/gp2/*.sh

# To have the new MIBs recognized by net-snmp
cat > /etc/snmp/snmp.conf <<EOD
mibs +ALL
EOD

cat > /etc/snmp/snmpd.conf <<EOD

###############################################################################
#
# EXAMPLE.conf:
#   An example configuration file for configuring the Net-SNMP agent ('snmpd')
#   See the 'snmpd.conf(5)' man page for details
#
#  Some entries are deliberately commented out, and will need to be explicitly activated
#
#  SYSTEM INFORMATION
#

####
# First, map the community name (COMMUNITY) into a security name
# (local and mynetwork, depending on where the request is coming
# from):

#       sec.name  source          community
com2sec npublic    0.0.0.0/0       public
com2sec nprivate   0.0.0.0/0       private
com2sec nadminet   0.0.0.0/0       adminet
com2sec npruebamask 0.0.0.0/0	pruebamask

####
# Second, map the security names into group names:

#             	sec.model  sec.name
group gpublic		v1         npublic
group gprivate  	v1         nprivate
group gadminet  	v1         nadminet
group gpruebamask	v1	npruebamask

rwuser admin authPriv .iso

###
# Third, create a view for us to let the groups have rights to:
#           incl/excl subtree                          				mask
#view todo	included	.iso
#view todo	excluded	.iso.org.dod.internet.mgmt.mib-2.snmp  
#view protocolos	included  	.iso.org.dod.internet.mgmt.mib-2.interfaces  
#view protocolos	included  	.iso.org.dod.internet.mgmt.mib-2.ip  
#view protocolos	included  	.iso.org.dod.internet.mgmt.mib-2.snmp  
#view protocolos included	.iso.org.dod.internet.mgmt.mib-2.icmp  
#view protocolos	included 	.iso.org.dod.internet.mgmt.mib-2.tcp  
#view protocolos	included  	.iso.org.dod.internet.mgmt.mib-2.udp  
#view sistema    included  	.iso.org.dod.internet.mgmt.mib-2.system 
#view mascara	included	.iso.org.dod.internet.mgmt.mib-2.interfaces.ifTable.ifEntry.0.2		0xff:a0
view todo	included	.1.3.6.1.2.1 
view todo	excluded	.1.3.6.1.2.1.11  
view protocolos	included  	.1.3.6.1.2.1.2 
view protocolos	included  	.1.3.6.1.2.1.4 
view protocolos included	.1.3.6.1.2.1.5 
view protocolos	included 	.1.3.6.1.2.1.6  
view protocolos	included  	.1.3.6.1.2.1.7  
view protocolos	included  	.1.3.6.1.2.1.11 
view sistema    included  	.1.3.6.1.2.1.1 
view mascara	included	.1.3.6.1.2.1.2.2.1.0.2 0xff:a0 
                   

####
# Finally, grant the 2 groups access to the 1 view with different
# write permissions:

#                context sec.model sec.level match  read   write  notif
access gpublic		""	v1	noauth	exact	todo		todo		none
access gprivate		""      v1      noauth	exact  	sistema		sistema    	none
access gadminet		""      v1      noauth  exact  	protocolos	protocolos    	none
access gpruebamask	""	v1	noauth  exact  	mascara		none	 	none

###############################################################################
# System contact information
#

# It is also possible to set the sysContact and sysLocation system
# variables through the snmpd.conf file:

#  Note that setting these values here, results in the corresponding MIB objects being 'read-only'
#  See snmpd.conf(5) for more details
#sysLocation    University of Alcala
#sysContact     Me <me@gestionderedes.uah>
                                                 # Application + End-to-End layers
sysServices    72


#
#  Process Monitoring
#
                               # At least one  'mountd' process
proc  mountd
                               # No more than 4 'ntalkd' processes - 0 is OK
proc  ntalkd    4
                               # At least one 'sendmail' process, but no more than 10
proc  sendmail 10 1

#  Walk the UCD-SNMP-MIB::prTable to see the resulting output
#  Note that this table will be empty if there are no "proc" entries in the snmpd.conf file


#
#  Disk Monitoring
#
                               # 10MBs required on root disk, 5% free on /var, 10% free on all other disks
disk       /     10000
disk       /var  5%
includeAllDisks  10%

#  Walk the UCD-SNMP-MIB::dskTable to see the resulting output
#  Note that this table will be empty if there are no "disk" entries in the snmpd.conf file


#
#  System Load
#
                               # Unacceptable 1-, 5-, and 15-minute load averages
load   12 10 5

#  Walk the UCD-SNMP-MIB::laTable to see the resulting output
#  Note that this table *will* be populated, even without a "load" entry in the snmpd.conf file



###############################################################################
#
#  ACTIVE MONITORING
#

                                    #   send SNMPv1  traps
#trapsink     10.0.123.2 public
                                    #   send SNMPv2c traps
#trap2sink    10.0.123.2 public
                                    #   send SNMPv2c INFORMs
#informsink   10.0.123.2 public

#authtrapenable 1

#  Note that you typically only want *one* of these three lines
#  Uncommenting two (or all three) will result in multiple copies of each notification.


#
#  Event MIB - automatically generate alerts
#
                                   # Remember to activate the 'createUser' lines above
iquerySecName   internalUser       
rouser          internalUser
                                   # generate traps on UCD error conditions
#defaultMonitors          yes
                                   # generate traps on linkUp/Down

EOD

sudo service snmpd stop
sudo service snmpd start


