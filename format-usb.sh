#!/bin/bash

## Check if root are running the script.
if [ "$UID" != 0 ]
then
	echo "You must be root to manipulate this files."
	exit
fi

## Check if dosfstools is installed
if [ -e /sbin/mkfs.vfat ]
then
	echo "Dependencies installed."
else
	echo "You must install \"dosfstools\" package to use this script."
fi

## Some variables
usbs=$(fdisk -l | cut -d ' ' -f 1 | grep '/dev/sd[b-z]' | wc -l)
num=1
num2=0
numlet=1
number=0
usb=( [1]=$usb1 [2]=$usb2 [3]=$usb3 [4]=$usb4 [5]=$usb5 )
exi=false
selec=false

function exiting {
	echo "Exiting..."
	exit
}

## Function that displays the menu
function message {
	if [ "$usbs" == 0 ]
	then
		echo "There's no usb's connected."
		exit
	else
		echo "Options:"
	fi
	echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	until [[ "$number" == "$usbs" ]]; do
		if [ "$usbs" == 1 ]
		then
			usb1=$(sed -n '1,1p' /tmp/format-usb.txt)
			number=$(($number + 1))
			echo "1) $usb1"
		elif [ "$usbs" == 2 ]
		then
			usb1=$(sed -n '1,1p' /tmp/format-usb.txt)
			usb2=$(sed -n '2,2p' /tmp/format-usb.txt)
			number=$(($number + 2))
			echo "1) $usb1"
			echo "2) $usb2"
		elif [ "$usbs" == 3 ]
		then
			usb1=$(sed -n '1,1p' /tmp/format-usb.txt)
			usb2=$(sed -n '2,2p' /tmp/format-usb.txt)
			usb3=$(sed -n '3,3p' /tmp/format-usb.txt)
			number=$(($number + 3))
			echo "1) $usb1"
			echo "2) $usb2"
			echo "3) $usb3"
		elif [ "$usbs" == 4 ]
		then
			usb1=$(sed -n '1,1p' /tmp/format-usb.txt)
			usb2=$(sed -n '2,2p' /tmp/format-usb.txt)
			usb3=$(sed -n '3,3p' /tmp/format-usb.txt)
			usb4=$(sed -n '4,4p' /tmp/format-usb.txt)
			number=$(($number + 4))
			echo "1) $usb1"
			echo "2) $usb2"
			echo "3) $usb3"
			echo "4) $usb4"
		else
			usb1=$(sed -n '1,1p' /tmp/format-usb.txt)
			usb2=$(sed -n '2,2p' /tmp/format-usb.txt)
			usb3=$(sed -n '3,3p' /tmp/format-usb.txt)
			usb4=$(sed -n '4,4p' /tmp/format-usb.txt)
			usb5=$(sed -n '5,5p' /tmp/format-usb.txt)
			number=$(($number + 5))
			echo "1) $usb1"
			echo "2) $usb2"
			echo "3) $usb3"
			echo "4) $usb4"
			echo "5) $usb5"
		fi
	done
	echo "$(($usbs + 1))) Exit."
	unset number
}

clear

## Principal loop
until [[ "$exi" == true ]]; do
	ls -l /dev/disk/by-label | grep sd[b-z] | cut -d ' ' -f 10 > /tmp/format-usb.txt ## Put the list of connected usb's to /tmp/format-usb.txt
	until [[ "$selec" == true ]];do
		message
		read -p "Pick an option : " op
		if [ "$usbs" == 1 ] ## Menu options
		then
			if [ "$op" == 1 ]
			then
				usbtra=$usb1
				selec=true
			elif [ "$op" -gt "$(($usbs + 1))" ]
			then
				echo "Invalid number."
			else
				exiting
			fi
		elif [ "$usbs" == 2 ]
		then
			if [ "$op" == 1 ]
			then
				usbtra=$usb1
				selec=true
			elif [ "$op" == 2 ]
			then
				usbtra=$usb2
				selec=true
			elif [ "$op" -gt "$(($usbs + 1))" ]
			then
				echo "Invalid number."
			else
				exiting
			fi
		elif [ "$usbs" == 3 ]
		then
			if [ "$op" == 1 ]
			then
				usbtra=$usb1
				selec=true
			elif [ "$op" == 2 ]
			then
				usbtra=$usb2
				selec=true
			elif [ "$op" == 3 ]
			then
				usbtra=$usb3
				selec=true
			elif [ "$op" -gt "$(($usbs + 1))" ]
			then
				echo "Invalid number."
			else
				exiting
			fi
		elif [ "$usbs" == 4 ]
		then
			if [ "$op" == 1 ]
			then
				usbtra=$usb1
				selec=true
			elif [ "$op" == 2 ]
			then
				usbtra=$usb2
				selec=true
			elif [ "$op" == 3 ]
			then
				usbtra=$usb3
				selec=true
			elif [ "$op" == 4 ]
			then
				usbtra=$usb4
				selec=true
			elif [ "$op" -gt "$(($usbs + 1))" ]
			then
				echo "Invalid number."
			else
				exiting
			fi
		elif [ "$usbs" == 5 ]
		then
			if [ "$op" == 1 ]
			then
				usbtra=$usb1
				selec=true
			elif [ "$op" == 2 ]
			then
				usbtra=$usb2
				selec=true
			elif [ "$op" == 3 ]
			then
				usbtra=$usb3
				selec=true
			elif [ "$op" == 4 ]
			then
				usbtra=$usb4
				selec=true
			elif [ "$op" == 5 ]
			then
				usbtra=$usb5
				selec=true
			elif [ "$op" -gt "$(($usbs + 1))" ]
			then
				echo "Invalid number."
			else
				exiting
			fi
		else
			echo "Invalid number."
		fi
	done
	until [[ "$sal" == true ]]; do ## The format loop
		read -p "Are you sure that you want to format $usbtra? (Will be used the \"vfat 32\" format) (yes/no/exit) : " res
		case $res in
			[Yy]* ) 
			read -p "Introduce the new usb's name: " nom
			echo "Starting formating..."
			umount /dev/disk/by-label/$usbtra
			mkfs.vfat -F 32 -n $nom /dev/disk/by-label/$usbtra
			echo "Usb formated."
			sal=true;;
			[Ee]* )
			exiting ;;
			* ) 
			sal=true;;
		esac
	done
	unset exi
	unset sal
	unset selec
done
rm /tmp/format-usb.txt
