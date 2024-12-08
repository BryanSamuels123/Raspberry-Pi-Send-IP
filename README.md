# Raspberry Pi4b workaround to not having a static IP on UNT campus & How to connect with USRP X310. 
- When using the Raspberry Pi on campus, it may sometimes be assigned a different IP address which makes it difficult to ssh or VNC into it (I prefer VNC). A free workaround that I found is to utilize google sheets’ capabilities.


## Creating the Google Sheets Script
1. Navigate to [Google Sheets](sheets.google.com)
    - If prompted to login/create an account, follow those directions, then move to step 2. 
2. Click “Blank Spreadsheet”

3. Select “Extensions”>”Apps Script” at the top of the page.
    - This will take you to a new page

4. Click the “+” (plus) button on the left side of the page where next to the “Files” section, click new script, and give the script a name.

5. Paste in the code from [SendIP Script](/sendIP.gs)

6. Save the code and click "Deploy">"New Deployment" at the top of the page. Follow any further directions that popup, and save the URL it gives you. That URL is the address that the post request will go to in the following section.


## Creating the Startup script

1. Open a terminal on the Rasberry Pi and create a new bash script 'startUp.sh'.

2. Open the new file in the text editor of your choice (I Prefer Nano) and paste in the code from [StartUp Script](/startUp.sh).

3. Change the URL in the code to the URL that you received in the previous section.

4. Save the file, and in the terminal make the file executable with
   ```
   chmod +x /path/to/startUp.sh
   ```


## Creating the System Service File
It is neccessary to create a system process that runs on boot for the raspberry pi.

1. In the terminal execute the command:
    - ```
      sudo nano /etc/systemd/system/startup-script.service
      ```

2. Paste in the code from [StartUp Service Config](/startUp.service), and change the "User" and "ExecStart" fields to match your username and path to the startUp.sh file, respectively.

3. Save and exit the file.

## Enable and Start the Service:

In the terminal execute the following commands to enable and start the new startup service.

1. ```
   sudo systemctl daemon-reload
   ```

2. ```
   sudo systemctl enable startup-script.service
   ```

3. ```
   sudo systemctl start startup-script.service
   ```

- Check the status of the service:
```
sudo systemctl status startup-script.service
```

Now, when the Raspberry Pi restarts, it will send the IP Address to the google sheet that you created earlier allowing you to always have access to its IP address to ssh or use VNC.



# Connect the USRP-X310 to the Raspberry Pi.

## Download the Necessary Dependencies
Our Raspberry Pi uses a debian based operating system. Other operating systems will have similar commands to the following but with a different package manager.

### Download GNURadio Companion:
Update the Packages and Package Manager:
- ```
  sudo apt update
  sudo apt upgrade -y
  ```

Install GNURadio
- ```
  sudo apt install -y gnuradio
  ```


Verify Installation
- ```
  gnuradio-companion --version
  ```



### Download UHD (USRP Hardware Driver)
``` 
sudo apt-get install libuhd-dev uhd-host
```



## Make Ethernet Connection
(assuming the USRP-X310 is assembled, configured, and ready to be used).
 
1. Connect the USRP X310 via ethernet (802.3-Ethernet) 
2. Your raspberry pi either uses DHCP or NetworkManager as the daemon process that handles connections.
    1. Our setup uses NetworkManager, but DHCP should have an equivalent command. 
3. Execute the command
   ```
   nmcli c add type ethernet ifname eth0 con-name USRP-X310 ip4 192.168.10.1/24
   ```
    - This command adds an ethernet connection interface of the name “USRP-X310” with an IPv4 address of 192.168.10.1/24 (X310 default address with /24 subnet mask).

Verify the connection
- ```
  uhd_find_devices
  ```



