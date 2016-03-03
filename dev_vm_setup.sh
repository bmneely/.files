#!/bin/bash -f
#---------------------------------------------------------------------------------#
#  name: dev_vm_setup.sh                                                          #
#  Description : Sets up the dev vm after a vagrant up (currently for the         #
#      14.04 project) This is NOT compatible with older 10.04 dev vms             #
#  Usage:  See below                                                              #
#                                                                                 #
#  Propery File configuration:  If you decide to include a property file it       #
#      should be named devXX.properties for this script to automatically          #
#      pull it in.  The property file can contain the following values to         #
#      override:                                                                  #
#         BRANCH - git branch name (DEV-1404)                                     #
#         DATABASE - db schema name on tkboi (kount_gjd)                          #
#         IP - last octet of your ip address (i.e. 89 for dev89.boi.keynetics.com #
#                                                                                 #
#---------------------------------------------------------------------------------#
#Default settings
BRANCH=master
DATABASE=kount_${USER}
IP=`echo ${HOSTNAME} | sed 's/[^0-9]*//g'`
PROPERTYFILE="/home/vagrant/dev.properties"
#parse args
while [[ $# > 0 ]]
do
key="$1"

case $key in
    -b|--branch)
    BRANCH="$2"
    shift # past argument
    ;;
    -d|--database)
    DATABASE="$2"
    shift # past argument
    ;;
    -i|--ip)
    IP="$2"
    shift # past argument
    ;;
    -p|--propertyfile)
    PROPERTYFILE=${2}
    shift # past argument
    ;;
    *)
    echo "USAGE dev_setup.sh [-d schema name] [-i ip octet] [-b branch name] [-p property file]:"
    echo "  -d --database TNS Name for Oracle DB on tkboi(default kount_${USER})"
    echo "  -b --branch Git branch name (defaults to master)"
    echo "  -i --ip Last octet of IP(defaults to number in HOSTNAME - ${IP})"
    echo "  -p --propertyfile Property file for parms to pass in"
    exit 1
    ;;
esac
shift # past argument or value
done
#TODO See if we need to upload a property file
echo "looking for '${PROPERTYFILE}'..."
if [ -f "$PROPERTYFILE" ]; then
  echo "Found property file"
  while read line; do
    export "$line"
    echo "set ${line}"
  done < $PROPERTYFILE
else
  echo "no property file found, using defaults/parms"
fi

if [ ${#IP} -lt 2 ]; then
  echo "IP(${IP}) is too short/missing"
  exit 1
fi

if [ ! -f /home/${USER}/.phing ] ; then
  # Make .phing dir and build.properties file
  mkdir /home/${USER}/.phing
  cd /home/${USER}/.phing/
  # Create phing override file
  echo "BRANCH ${BRANCH}"
  echo "DATABASE ${DATABASE}"
  echo "HOSTNAME dev${IP}.boi.keynetics.com"
  echo "# Log4php file" > build.properties
  echo 'test.logging.config=${user.home}/.phing/log4php.ini' >> build.properties
  echo "# System settings" >> build.properties
  echo "config.settings.host.ip=10.100.7.${IP}" >> build.properties
  echo "config.settings.host.domain=dev${IP}.boi.keynetics.com" >> build.properties
  echo "config.settings.p0f.interface=eth1:${IP}" >> build.properties
  echo "# Oracle Instance" >> build.properties
  echo "config.settings.oracle.user=${DATABASE}" >> build.properties
  echo "config.settings.test.oracle.user=${DATABASE}" >> build.properties
  echo "config.settings.oracle.pass=abc123" >> build.properties
  echo "config.settings.test.oracle.pass=abc123" >> build.properties
  echo "# #config.settings.oracle.scheduler.user=${USER}_rule_scheduler" >> build.properties
  echo "config.settings.oracle.scheduler.user=${DATABASE}" >> build.properties
  echo "#config.settings.oracle.pentaho.user=kount_${USER}_pentaho" >> build.properties
  echo "# #config.settings.oracle.korp.user=korp_${USER}" >> build.properties
  # Create logging override file
  cat << EOF > log4php.ini
[Loggers]
root.level=debug
root.appenders=console, rolling

[console]
class=K_Logger_Appender_Console
layout=K_Logger_Layout_Keynetics
threshold=fatal

[rolling]
class=K_Logger_Appender_DailyFile
datePattern=Ymd
file=/tmp/phing-test-%s.log
layout=K_Logger_Layout_Keynetics

[syslog]
class=K_Logger_Appender_SyslogUdp
host=127.0.0.1
ident=test
facility=LOCAL3
EOF
fi

# Create .gitconfig if it doesn't already exist
if [ ! -f ~${USER}/.gitconfig ]; then
  echo "[user]" > .gitconfig
  echo "    name = ${USER_NAME}" >> .gitconfig
  echo "    email = ${EMAIL}" >> .gitconfig
fi
## Use users fork of Kount repo
CLONE=ssh://git@stash.keynetics.com/kount/kount.git

# Checkout the right branch
mkdir ~/projects; cd ~/projects; git clone $CLONE kount
cd ~/projects/kount; git checkout -b ${BRANCH} remotes/origin/${BRANCH};
#
# # Setup and install apps
# # The apps could be a loop, but meh...
./build-tools/bin/setup_vm.sh $USER;
cd ~/projects/kount/oracle; phing precog;
cd ~/projects/kount/checkout; phing local-install;
cd ~/projects/kount/ris; phing local-install;
cd ~/projects/kount/api; phing local-install;
cd ~/projects/kount/jobs; phing local-install;
cd ~/projects/kount/kaptcha; phing local-install;
cd ~/projects/kount/awc; phing local-install;
cd ~/projects/kount; phing unified-cert;
