# Setup Hadoop using BASH Script on Debian GNU/Linux
This script was wrote for and tested on Debian GNU/Linux. Although it should work on Debian based distros like Ubuntu but it has only been tested on pure Debian.

## Installing Git
Switch to root 
```bash
su
```
Install git
```bash
apt install git
```
## Cloning the repo
Switch to normal user
```bash
su <non-root-username>
```
```bash
git clone https://github.com/aquib-sh/setup-hadoop
cd setup-hadoop
```
## Setup Debian Environment for Hadoop
Switch to root 
```bash
su
```
Make `setup_debian.sh` executable and run
```bash
chmod +x setup_debian.sh
./setup_debian.sh
```
You will be prompted to enter the name of non-root user account. Enter the name of the user you want to grant sudo previledge.

## Setup Hadoop
Switch to normal user that you previously entered while prompted
```bash
su <non-root-username>
```
Make `setup_hadoop.sh` executable and run
```bash
chmod +x setup_hadoop.sh
./setup_hadoop.sh
```
## Verify if installation is sucessful
Enter Hadoop directory
```bash
cd hadoop-3.3.4
```
Start all services
```bash
sbin/start-all.sh
```
After a short while all services will start and you can verify via `jps` commands if all the scripts are running
```bash
jps
```
This should give an output similar to below:
```
1539 NameNode  
1988 Jps  
793 SecondaryNameNode  
1037 NodeManager  
957 ResourceManager  
655 DataNode
```