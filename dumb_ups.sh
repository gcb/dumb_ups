#!/bin/env sh

set -eou pipefail

# verbose/debug:
#set -x

# test:
# DUMB_UPS_IF_NAME=wlp1s0 DUMB_UPS_LOCK_FILE=test.lock ./dumb-ups.sh


# if you have a dumb UPS, just connect the router/switch on
# mains (without battery back up), so the network link
# works as a mains power indicator.
#
#
#(move as DONE: in the versions)
# TODO: grace period (we don't want to shutdown on every power hiccup)
# TODO: cancel shutdown if network/power is restored.
# TODO: log everything to syslog/journald
# TODO: run as a systemd-something that triggers evern few seconds?
# TODO: run as a systemd-networkd event when if down... initial research says systemdick is useless for this.
#       maybe check https://gitlab.com/craftyguy/networkd-dispatcher
# TODO: dry-run?
# TODO: verbose?


# input: DUMB_UPS_IF_NAME env var. defaults to eth0.
# input: DUMB_UPS_LOCK_FILE env var. defaults to /run/lock/dumb_ups_shutdown. set to /run/user/<PID>/lock/... as needed.


#v1.2
# FIX: carrier loss means interface is "up". wtf.
#      3: ethf0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT
# DROP: USE_WIFI flag.
_dumb_ups_event_ifdown() {
	local readonly LOCKFILE="${1:-/run/lock/dumb_ups_shutdown}"
	if [ ! -e "${LOCKFILE}" ]; then
		touch "${LOCKFILE}"
		echo "Starting shutdown."
		# TODO: use whatever systemdick uses for this now?
		/bin/shutdown --poweroff +2 "Assumed power loss (lost network link '${IFNAME}')."
	#else echo "Already issued shutdown."
	fi
}

_dumb_ups_monitor() {
	local readonly IFNAME="$1"
	local readonly LOCKFILE="$2"
	while true; do
		# NOTE: not sure what is nomaster/novf, but i *think* it might reduce the odd chance of
		#       having VM ifs show up here unintended?
		local readonly IFSTATE=$(nice /usr/bin/ip link show dev "${IFNAME}" up nomaster novf)
		if [ "${IFSTATE}" == "" ]; then
			echo "Interface was never UP, ignoring."
			# TODO: what being "down" really means? in which case it doesn't show up on ip link show up???
			#_dumb_ups_event_ifdown "${LOCKFILE}"
		else
			#echo "Interface UP. Checking."
			if [[ "${IFSTATE}" == *"state DOWN"* ]]; then # check for "NO-CARRIER" instead?
				#echo "Interface State is DOWN."
				_dumb_ups_event_ifdown "${LOCKFILE}"
			#else echo "Interface UP."
			fi
		fi
		break
	done
}

#v1.1
# DONE: quiet

#v1
# DONE: shutdown when network goes down

# v0
# DONE parse inputs from env
# DONE monitor network
# DONE wifi?

# MAIN:
_dumb_ups_monitor \
	${DUMB_UPS_IF_NAME:-eth0} \
	"${DUMB_UPS_LOCK_FILE:-/run/lock/dumb_ups_shutdown}"
