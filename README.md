This script exists to automate the setup of the Ligolo-ng (https://github.com/nicocha30/ligolo-ng) proxy. It requires Ligolo to be in the /opt folder. It requires an IP range to set up a tunnel, but it will accept a specific IP range or a single IP and convert to the IP range of 0/24. 

* Note that the user is pop by default, you need to change it for a different user. * 


Run `sudo chmod +x /opt/liggy/liggy.sh && ln -s /opt/liggy/liggy.sh /usr/local/bin/liggy` to be able to call it as liggy from any directory. 


