#!/bin/bash

#Autor: Adrian Ledesma Bello
#Link: https://www.canalhacker.com

function logo {
  echo -e "\e[37m _______      \e[34m                                                  _              _  ________                \e[m"
  echo -e "\e[37m!   ____!      >><<       NAL     N       ====       L       \e[34m {}\\            // 0        0  $        $       "
  echo -e "\e[37m!  |         ==    ==     N \L    N     >>    <<     L       \e[34m {} \\          //  0        0  &        &       "
  echo -e "\e[37m!  |        >>!!!!!!<<    N  \L   N    ==!!!!!!==    L       \e[34m {}  \\   /\   //   0][][][][0  $        $       "
  echo -e "\e[37m!  |____   ==        ==   N   \L  N   >>        <<   L       \e[34m {}   \\  ||  //    0        0  &        &       "
  echo -e "\e[37m!_______! ==          ==  N    \LAN  >>          <<  LLLLLLL \e[34m {}    \\//\\//     0        0    WWAALL   WWAALL"
  echo -e "\e[m"
  echo
  echo "You shoud add this script on boot"
}

#logo

###########################################################
code='apxvodkefoskjvbakcjnkjvcdsavicjklsdfihhvkjsxksfslajd' #### CHANGE THIS RANDOM STRING (You can put whathever you want, but must be random and long)
###########################################################



export DISPLAY=:0.0 ### For zenity on boot
export XAUTHORITY=/home/d3n50/.Xauthority #### You mus put here the output of $(echo $XAUTHORITY) For zenity on boot ### CHANGE THIS

declare -a whitelist;
declare -a blacklist;

whitelist=(192.168.233.254 192.168.233.2) #### Add trusted IPs
blacklist=() #### Add untrusted IPs

white=$(echo ${whitelist[*]} | wc -w)
black=$(echo ${balcklist[*]} | wc -w)


########## CLEAN IPTABLES WHEN IS EXECUTED

iptab="yes" ##### Change this if you want

if [ "$iptab" == "yes" ];then

	iptables -F
	iptables -t nat -F
	iptables -X

fi

############ CHECK IF TCPDUMP IS RUNNING

if [ $(ps -aux | grep 'tcpdump -npi any -A -s0 -l' | grep -v 'grep' | wc -c) -gt 5 ];then

		kill $(ps -aux | grep 'tcpdump -npi any -A -s0 -l' | grep -v 'grep' | awk '{print $2}')

fi

############ CHECK IF SOME CONNECTION IS EXECUTING COMMAND IN YOUR COMPUTER (only work for non cipher connections)

echo > /root/.Res_tcp
chmod 700 /root/.Res_tcp

while true;do

	sleep 4
	result=''

	if [ $(ps -aux | grep 'tcpdump -npi any -A -s0 -l' | grep -v 'grep' | wc -c) -lt 5 ];then

		tcpdump -npi any -A -s0 -l > /root/.Res_tcp &

	fi

	if [ $(cat -v /root/.Res_tcp | grep $code | wc -c) -gt 10 ];then

		result=$(cat -v /root/.Res_tcp | grep $code -B 20 | grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | grep 'IP' | tail -n 1 | awk -F "IP" '{print $2}'| awk -F ":" '{print $1}')

	fi

	echo > /root/.Res_tcp

########## CHECK IF SOME ESTABLISHED CONNECTION IS DONE (no in HTTP or HTTPS ports)

	IPs=$(netstat --numeric-hosts -t | grep ESTABLISHED | grep -v "localhost\|Active Internet connections\|Proto Recv\|http\|::1:\|127.0.0.1" | head -n 1)
	ip2=$(echo $IPs | awk '{print $5}' | awk -F ":" '{print $1}')

	if [ ! -z "$IPs" ] && [ -z "$(echo -n ${whitelist[*]} | grep $ip2)" ] && [ -z "$(echo -n ${blacklist[*]} | grep $ip2)" ] || [ ! -z "$result" ] && [ "$(echo $result | awk '{print $1}' | cut -f 1,2,3,4 -d '.')" != '127.0.0.1' ];then

		if [ -z "$result" ];then

			ip1=$(echo $IPs | awk '{print $4}' | awk -F ":" '{print $1}')
			zenity --question --ellipsize --text="ESTABLISHED CONNECTION: \n<span background=\"yellow\" font=\"12\"><b><span color=\"black\">  ¿ Block connection:</span> <span color=\"blue\">$ip1</span><span color=\"black\">  --->  </span><span color=\"red\">$ip2 </span><span color=\"black\">?  </span></b></span>"

		else

			ip1=$(echo $result | awk '{print $1}' | cut -f 1,2,3,4 -d '.')
			ip2=$(echo $result | awk '{print $3}' | cut -f 1,2,3,4 -d '.')
			zenity --question --timeout 10 --ellipsize --text="BE CAREFUL, SOMEONE ON YOUR COMPUTER:\n<span background=\"yellow\" font=\"12\"><b><span color=\"black\">  ¿ Block connection:</span> <span color=\"blue\">$ip1</span><span color=\"black\">  --->  </span><span color=\"red\">$ip2 </span><span color=\"black\">?  </span></b></span>\n<b>In 10 Seconds, the ip: $ip2 will be blocked</b>"

		fi

		if [ $? == 1 ];then

			let white=$white+1
			whitelist[$white]=$ip2

		else

			iptables -A INPUT --source $ip2 -j DROP
			let black=$black+1
			blacklist[$black]=$ip2
			zenity --info --ellipsize --text="<span background=\"red\" font=\"12\"><b>La ip $ip está bloqueada</b></span>"

		fi

#	echo "WHITE LIST ${whitelist[*]}"
#	echo "BLACK LIST ${blacklist[*]}"

	fi

done
