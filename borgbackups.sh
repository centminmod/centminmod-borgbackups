#!/bin/bash
VER='0.1'
#####################################################
# set locale temporarily to english
# due to some non-english locale issues
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
######################################################
# addons/borgbackups.sh setup for Centminmod.com
# written by George Liu (eva2000) centminmod.com
######################################################
DT=$(date +"%d%m%y-%H%M%S")
BORG_DEBUG='n'

# space separated list of directories to keep borg
# incremental deduplicated backups for
BORG_BACKUPTARGETS='/root/.ssh /root/tools /root/centminlogs /usr/local/nginx/conf /usr/local/nginx/conf/conf.d /etc/centminmod'

# where borgbackups.sh logs get saved
BORG_BACKUPLOGS='/home/borgbackups-logs'

# where your backups get stored with encryption
BORG_REPO='/home/borgbackups'

# your desired borg encryption passphrase if left blank
# passphrase will be auto generated for you and you'll
# need this passphrase to access your borg backups
# auto generated passphrase is saved to 
# /root/.config/borg/pp
BORG_PASSPHRASE=''

# set borgbackup to reserve additional free space in
# gigabytes to prevent running out of disk space
BORG_ADDITIONAL_FREESPACE='4G'

# exclude directories from borg backup
# space separated list
# https://borgbackup.readthedocs.io/en/stable/usage/create.html
BORG_EXCLUDE_DIRS='/home/nginx/domains/*/log /home/nginx/domains/*/backup'

# borg prune how long to keep backups before removal
BORG_KEEP_HOURLY='24'
BORG_KEEP_DAILY='7'
BORG_KEEP_WEEKLY='4'
BORG_KEEP_MONTHLY='12'

CENTMINLOGDIR='/root/centminlogs'
DIR_TMP='/svr-setup'
SCRIPT_DIR=$(readlink -f $(dirname ${BASH_SOURCE[0]}))

NICE=$(which nice)
NICEOPT='-n 12'
IONICE=$(which ionice)
IONICEOPT='-c2 -n7'
######################################################
# Setup Colours
black='\E[30;40m'
red='\E[31;40m'
green='\E[32;40m'
yellow='\E[33;40m'
blue='\E[34;40m'
magenta='\E[35;40m'
cyan='\E[36;40m'
white='\E[37;40m'

boldblack='\E[1;30;40m'
boldred='\E[1;31;40m'
boldgreen='\E[1;32;40m'
boldyellow='\E[1;33;40m'
boldblue='\E[1;34;40m'
boldmagenta='\E[1;35;40m'
boldcyan='\E[1;36;40m'
boldwhite='\E[1;37;40m'

Reset="tput sgr0"      #  Reset text attributes to normal
                       #+ without clearing screen.

cecho ()                     # Coloured-echo.
                             # Argument $1 = message
                             # Argument $2 = color
{
message=$1
color=$2
echo -e "$color$message" ; $Reset
return
}

###########################################
shopt -s expand_aliases
for g in "" e f; do
    alias ${g}grep="LC_ALL=C ${g}grep"  # speed-up grep, egrep, fgrep
done

CENTOSVER=$(awk '{ print $3 }' /etc/redhat-release)

if [ ! -d "$CENTMINLOGDIR" ]; then
  mkdir -p "$CENTMINLOGDIR"
fi

if [ ! -d "$BORG_BACKUPLOGS" ]; then
  mkdir -p "$BORG_BACKUPLOGS"
fi

if [ ! -d "$BORG_REPO" ]; then
  mkdir -p "$BORG_REPO"
fi

if [ "$CENTOSVER" == 'release' ]; then
    CENTOSVER=$(awk '{ print $4 }' /etc/redhat-release | cut -d . -f1,2)
    if [[ "$(cat /etc/redhat-release | awk '{ print $4 }' | cut -d . -f1)" = '7' ]]; then
        CENTOS_SEVEN='7'
    fi
fi

if [[ "$(cat /etc/redhat-release | awk '{ print $3 }' | cut -d . -f1)" = '6' ]]; then
    CENTOS_SIX='6'
fi

# Check for Redhat Enterprise Linux 7.x
if [ "$CENTOSVER" == 'Enterprise' ]; then
    CENTOSVER=$(awk '{ print $7 }' /etc/redhat-release)
    if [[ "$(awk '{ print $1,$2 }' /etc/redhat-release)" = 'Red Hat' && "$(awk '{ print $7 }' /etc/redhat-release | cut -d . -f1)" = '7' ]]; then
        CENTOS_SEVEN='7'
        REDHAT_SEVEN='y'
    fi
fi

if [[ -f /etc/system-release && "$(awk '{print $1,$2,$3}' /etc/system-release)" = 'Amazon Linux AMI' ]]; then
    CENTOS_SIX='6'
fi

if [ -f "${SCRIPT_DIR}/inc/custom_config.inc" ]; then
  if [ -f /usr/bin/dos2unix ]; then
    dos2unix -q "inc/custom_config.inc"
  fi
    source "inc/custom_config.inc"
fi

if [ -f "${CONFIGSCANBASE}/custom_config.inc" ]; then
    # default is at /etc/centminmod/custom_config.inc
  if [ -f /usr/bin/dos2unix ]; then
    dos2unix -q "${CONFIGSCANBASE}/custom_config.inc"
  fi
    source "${CONFIGSCANBASE}/custom_config.inc"
fi

preyum() {
  if [[ ! "$(rpm -ql python36-Cython | grep -v 'not installed')" || ! "$(rpm -ql jq | grep -v 'not installed')" || ! "$(rpm -ql borgbackup | grep -v 'not installed')" || ! "$(rpm -ql libzstd | grep -v 'not installed')" || ! "$(rpm -ql zstd | grep -v 'not installed')" ]]; then
    echo
    echo "install required YUM packages"
    echo
    yum -y install borgbackup libzstd zstd jq python36-Cython
    echo
    echo "installed YUM packages"
  fi
}

setup_borgbackup() {
  if [ -f /usr/bin/borg ]; then
    if [ -z "$BORG_PASSPHRASE" ]; then
      # auto generate borg passphrase if BORG_PASSPHRASE variable is empty
      BORG_PASSPHRASE=$(pwgen -1ny 13)
      echo
      echo "Generated $BORG_PASSPHRASE"
      echo
    fi
    if [ -f /root/.config/borg/pp ]; then
      BORG_PASSPHRASE=$(cat /root/.config/borg/pp)
    fi
    export BORG_PASSPHRASE=$BORG_PASSPHRASE
    export BORG_REPO=$BORG_REPO
    getrepo_location=$(borg info --json | jq -r '.repository.location')
    if [[ "$getrepo_location" != "$BORG_REPO" ]] || [[ ! "$getrepo_location" ]] || [[ "$(echo $getrepo_location | grep -o 'does not exist')" ]]; then
      # https://borgbackup.readthedocs.io/en/stable/usage/init.html
      borg init -e repokey-blake2 "$BORG_REPO" --debug 2>&1 >/dev/null
      echo "$BORG_PASSPHRASE" > /root/.config/borg/pp
      if [ ! "$(grep -w 'BORG_PASSPHRASE=' ~/.bashrc)" ]; then
        echo -e "\nexport BORG_PASSPHRASE=$BORG_PASSPHRASE" >> ~/.bashrc
      fi
      if [ ! "$(grep -w 'BORG_PASSPHRASE=' ~/.bashrc)" ]; then
        echo -e "\nexport BORG_REPO=$BORG_REPO" >> ~/.bashrc
      fi
      # if [ ! "$(grep -w 'borgc' ~/.bashrc)" ]; then
      #   # setup borgc function in /root/.bashrc for shorthand command for creating borg backup
      #   # repos https://borgbackup.readthedocs.io/en/stable/usage/create.html
      #   # usage:
      #   # borgc reponame directoryname
      #   echo -e '\nborgc() {borg create --stats --compression auto,zstd,6 ::$1 $2;}' >> ~/.bashrc;
      # fi
      echo
      echo "Get borg repo info"
      borg info
    fi
  fi
}

run_borgbackup() {
  if [ -f /usr/bin/borg ]; then
    if [ -f /root/.config/borg/pp ]; then
      BORG_PASSPHRASE=$(cat /root/.config/borg/pp)
    fi
    export BORG_PASSPHRASE=$BORG_PASSPHRASE
    export BORG_REPO=$BORG_REPO
    BORG_EXCLUDED=$(for ed in $BORG_EXCLUDE_DIRS; do echo $ed; done | while read e; do echo -n "-e $e "; done)
    for d in ${BORG_BACKUPTARGETS}; do
      if [ -d ${d} ]; then
        DT=$(date +"%d%m%y-%H%M%S")
        reponame=$(basename ${d})
        echo "borgbackup for ${reponame}"
        if [[ "$BORG_DEBUG" ]]; then
          echo "$NICE $NICEOPT $IONICE $IONICEOPT borg create ${BORG_EXCLUDED} --stats --comment ${reponame} --compression auto,zstd,3 ::${reponame}-${DT} $d"
        fi
        $NICE $NICEOPT $IONICE $IONICEOPT borg create ${BORG_EXCLUDED} --stats --comment ${reponame} --compression auto,zstd,3 ::${reponame}-${DT} "$d" | tee /home/borgbackups-logs/${reponame}-borgbackup-${DT}.log
        if [[ "$BORG_DEBUG" ]]; then
          echo "$NICE $NICEOPT $IONICE $IONICEOPT borg prune -v ${BORG_REPO} --prefix ${reponame}- --keep-hourly=${BORG_KEEP_HOURLY} --keep-daily=${BORG_KEEP_DAILY} --keep-weekly=${BORG_KEEP_WEEKLY} --keep-monthly=${BORG_KEEP_MONTHLY} --stats"
        fi
        $NICE $NICEOPT $IONICE $IONICEOPT borg prune -v ${BORG_REPO} --prefix "${reponame}-" --keep-hourly=${BORG_KEEP_HOURLY} --keep-daily=${BORG_KEEP_DAILY} --keep-weekly=${BORG_KEEP_WEEKLY} --keep-monthly=${BORG_KEEP_MONTHLY} --stats | tee /home/borgbackups-logs/prune-${reponame}-borgbackup-${DT}.log
      fi
    done
    if [[ "$BORG_DEBUG" ]]; then
      echo
      echo "borg list"
    fi
    borg list
  fi
}

clean_borgbackup(){
  if [ -f /usr/bin/borg ]; then
    echo
    echo "Clean up and wipe all borgbackup configurations & repos"
    rm -rf /root/.config/borg
    rm -rf /root/.cache/borg
    rm -rf "${BORG_REPO}"
    sed -i '/^export BORG_PASSPHRASE=/d' ~/.bashrc
    sed -i '/^export BORG_REPO=/d' ~/.bashrc
  fi
}

###########################################################################
case $1 in
  install)
starttime=$(TZ=UTC date +%s.%N)
{
    preyum
    setup_borgbackup
} 2>&1 | tee ${CENTMINLOGDIR}/addons-borgbackup-setup-${DT}.log

endtime=$(TZ=UTC date +%s.%N)

INSTALLTIME=$(echo "scale=2;$endtime - $starttime"|bc )
echo "" >> ${CENTMINLOGDIR}/addons-borgbackup-setup-${DT}.log
echo "Total borgbackup Install Time: $INSTALLTIME seconds" >> ${CENTMINLOGDIR}/addons-borgbackup-setup-${DT}.log
  ;;
  backup)
starttime=$(TZ=UTC date +%s.%N)
{
    run_borgbackup
} 2>&1 | tee ${CENTMINLOGDIR}/addons-borgbackup-backuprun-${DT}.log

endtime=$(TZ=UTC date +%s.%N)

INSTALLTIME=$(echo "scale=2;$endtime - $starttime"|bc )
echo "" >> ${CENTMINLOGDIR}/addons-borgbackup-backuprun-${DT}.log
echo "Total borgbackup Backup Time: $INSTALLTIME seconds" >> ${CENTMINLOGDIR}/addons-borgbackup-backuprun-${DT}.log
  ;;
  cleanup)
starttime=$(TZ=UTC date +%s.%N)
{
    clean_borgbackup
} 2>&1 | tee ${CENTMINLOGDIR}/addons-borgbackup-cleanuprun-${DT}.log

endtime=$(TZ=UTC date +%s.%N)

INSTALLTIME=$(echo "scale=2;$endtime - $starttime"|bc )
echo "" >> ${CENTMINLOGDIR}/addons-borgbackup-cleanuprun-${DT}.log
echo "Total borgbackup Cleanup Time: $INSTALLTIME seconds" >> ${CENTMINLOGDIR}/addons-borgbackup-cleanuprun-${DT}.log
  ;;
  *)
    echo
    echo "Usage:"
    echo
    echo "$0 install"
    echo "$0 backup"
    echo "$0 cleanup"
  ;;
esac
exit