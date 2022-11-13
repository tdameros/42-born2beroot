KERNEL=$(uname -a)
CPU_PHYSICAL=$(lscpu | grep "Socket(s)" | rev | cut -d ' ' -f1 | rev)
CPU_VIRTUAL=$(lscpu | grep "^CPU(s)" | rev | cut -d ' ' -f1 | rev)
MEM_TOTAL=$(free -m | grep "Mem" | awk '{print $2}')
MEM_USED=$(free -m | grep "Mem" | awk '{print $3}')
MEM_USED_PER=$((100 * $MEM_USED / $MEM_TOTAL))
DISK_TOTAL=$(df -H --total | awk 'END {print $2}')
DISK_USED=$(df -H --total | awk 'END {print $3}')
DISK_USED_PER=$(df -H --total | awk 'END {print $5}')
CPU_USED_PER=$(grep 'cpu ' /proc/stat | awk '{print ($2+$4)*100/($2+$4+$5)}')
LAST_BOOT=$(who -b | rev | cut -d ' ' -f1-2 | rev)
CONNEXIONS_TCP="$(netstat -at | grep "ESTABLISHED" | wc -l) ESTABLISHED"
USER_LOG=$(who | wc -l)
MAC=$(ip link | grep link/ether | awk '{print $2}')
IP=$(hostname -I)
SUDO_COMMANDS=$(expr $(cat /var/log/sudo/sudo.log | wc -l) / 2)
LVM=$(lsblk | grep "lvm" | wc -l)

if [ LVM > 0 ]; then
	LVM_IS_ACTIVE="yes"
else
	LVM_IS_ACTIVE="no"
fi

echo "#Architecture   : ${KERNEL}"
echo "#CPU physical   : ${CPU_PHYSICAL}"
echo "#vCPU           : ${CPU_VIRTUAL}"
echo "#Memory Usage   : ${MEM_USED}/${MEM_TOTAL}MB (${MEM_USED_PER}%)"
echo "#Disk Usage     : ${DISK_USED}/${DISK_TOTAL} (${DISK_USED_PER})"
echo "#CPU load       : ${CPU_USED_PER}%"
echo "#Last boot      : ${LAST_BOOT}"
echo "#LVM use        : ${LVM_IS_ACTIVE}"
echo "#Connexions TCP : ${CONNEXIONS_TCP}"
echo "#User log       : ${USER_LOG}"
echo "#Network        : IP ${IP}(${MAC})"
echo "#Sudo           : ${SUDO_COMMANDS} cmd"
