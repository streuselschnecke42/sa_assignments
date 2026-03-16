logging session and saving after
```bash
script session01.log # start logging
# do something
exit # stop loggin and save script
```

loggin to an exisitng .log file
```bash
script -a session01.log
# do something
exit
```

1. Ensure that the server is up to date and all packages are at their latest versions.
```bash
sudo apt update && sudo apt upgrade
```

2. Inspect the server and try to figure out details on it (version, filesystem, ports open, services running, users available).
```bash
neofetch
hostnamectl
cat /etc/hosts
cat /etc/resolv.conf | grep -v '#'
nslookup apache.org
head -3 /etc/passwd
cat /etc/nsswitch.conf
echo $HOME
env
uptime

# ports on system
cat /etc/services
# open ports: https://www.geeksforgeeks.org/linux-unix/ways-to-find-out-list-of-all-open-ports-in-linux/
ss -lntu

# services running
service --status-all

# user stuff
whoami
sudo whoami
id
groups
users
```

3. Install the MariaDB database server. Ensure that it works by doing a SELECT statement showing the version of the database. Write in the report if you followed a guide, make it as a reference.
```bash
# https://linuxcapable.com/how-to-install-mariadb-on-ubuntu-linux/
sudo apt install mariadb-server mariadb-client -y
mariadb --version

# even needed??? no right?
sudo systemctl status mariadb
# if not active: sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl status mariadb
# should i?
sudo mysql_secure_installation
```

4. Install the Apache web server. Write in the report if you followed a guide, make it as a reference.
```bash
# https://ubuntu.com/tutorials/install-and-configure-apache#2-installing-apache
sudo apt install apache2
apache2 --version
```

5. Replace the default web page with your own saying "Hello World".
```bash
# https://ubuntu.com/tutorials/install-and-configure-apache#3-creating-your-own-website
sudo mkdir /var/www/hampter/
cd /var/www/hampter/
ls
touch index.html
nano index.html
# page content
```
```html
<html>
<head>
  <title> Hello World </title>
</head>
<body>
  <p> Hello World
</body>
</html>
```

6. Enable cgi on your web server.
```bash
# https://www.slingacademy.com/article/enable-cgi-scripts-apache-ubuntu/#step-2:-enabling-cgi-module

# make it autostart and start webserver
sudo systemctl enable apache2
sudo systemctl start apache2

# enable cgi module
sudo a2enmod cgi
sudo systemctl restart apache2
```

7. Write a cgi script `info.bash` that prints out useful details on your server and its status. You may choose what to print out but it should be at least 5 different items saying something on your server.

- need to do
```bash
chmod +x info.bash
```
- script has to be in /usr/lib/cgi-bin/ or /var/www/ ????
- accessed through http://myserver/cgi-bin/info.bash or ???

info.bash
```bash
#!/usr/bin/env bash

echo "Content-type: text/plain"
echo ""

echo "=============================== System Info ==============================="
echo "Current user   : $(whoami)"
echo "Groups         : $(groups)"
echo "Uptime         : $(uptime -p)"
echo "System up since: $(uptime -s)"
echo ""

echo "=============================== Memory Info ==============================="
# echo "$(free -h)"
echo "Total    : $(free -h | awk 'NR==2 {print $2}')"
echo "In use   : $(free -h | awk 'NR==2 {print $3}')"
echo "Avaliable: $(free -h | awk 'NR==2 {print $7}')"

echo "=============================== Open Ports ==============================="
echo "$(ss -lntu)"
echo ""

echo "=============================== WELCOME BACK ==============================="
echo ""
neofetch

```

setting virtual host config file (domain name e.g.)
https://ubuntu.com/tutorials/install-and-configure-apache#4-setting-up-the-virtualhost-configuration-file

8. Write a script `backup.bash` and save it in your home directory. It should create a file `backup.tar.gz` containing the web files in `/var/www` and essential configuration from `/etc/apache2`.