#!/bin/bash

get_flash_information() {
	# http://www.bunniestudios.com/blog/?page_id=1022
	while read Device ; do
		DeviceNode="${Device%/*}"
		DeviceName="${DeviceNode##*/}"
		echo -e "\n### ${DeviceName} info:\n"
		find "${DeviceNode}" -maxdepth 1 -type f | while read ; do
			NodeName="${REPLY##*/}"
			echo -e "$(printf "%20s" ${NodeName}): $(cat "${DeviceNode}/${NodeName}" | tr '\n' " ")"
		done

		oem=$(cat ${DeviceNode}/name)
		CardName="${DeviceName}-[${oem//[^a-zA-Z0-9]/_}]"
	done <<< $(find /sys -name oemid)
} # get_flash_information

get_flash_information > card_info.txt
LOGFILE="SD_test_${CardName}_$(date +%Y%m%d_%H%M%S).log"

[[ -d /mnt/sdcard ]] || mkdir -p /mnt/sdcard
mount /dev/mmcblk0p1 /mnt/sdcard
result=$?

if [[ $result -ne 0 ]]; then
	echo "failed to mount SD card. Stopped the test"
	exit 1
fi

cat card_info.txt | tee -a $LOGFILE
rm -f card_info.txt

echo -e "\n\n===============================\n\n" >> $LOGFILE

echo "Start benchmarking ..." | tee -a ${LOGFILE}
echo "Please wait"
echo -e "\n\n1st run\n\n" | tee -a ${LOGFILE}
iozone -e -I -a -s 100M -r 4k -r 16k -r 512k -r 1024k -r 16384k -i 0 -i 1 -i 2 -f /mnt/sdcard/iozone-test.dat | tee -a ${LOGFILE}
echo -e "\n\n===============================\n\n" >> $LOGFILE

echo -e "\n\n2nd run\n\n" | tee -a ${LOGFILE}
iozone -e -I -a -s 100M -r 4k -r 16k -r 512k -r 1024k -r 16384k -i 0 -i 1 -i 2 -f /mnt/sdcard/iozone-test.dat | tee -a ${LOGFILE}
echo -e "\n\n===============================\n\n" >> $LOGFILE

umount /mnt/sdcard
echo "Done" | tee -a ${LOGFILE}
