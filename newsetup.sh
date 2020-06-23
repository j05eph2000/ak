#/bin/bash
COINNAME='akikcoin'
COIN_DAEMON='akikcoind'
COIN_CLI='akikcoin-cli'
COIN_QT='akikcoin-qt'
COIN_TX='akikcoin-tx'
CONFIG_FILE='akikcoin.conf'
COIN_TGZ='https://github.com/akikblockchain/akikcoin/releases/download/v1.0/akikcoin_ubuntu16.04.zip'
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')

COIN_PORT=19532


#/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your Transcendence  masternodes.  *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [ $DOSETUP = "y" ]  
then
 
apt-get update -y
#DEBIAN_FRONTEND=noninteractive apt-get update 
#DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade
apt install -y software-properties-common 
apt-add-repository -y ppa:bitcoin/bitcoin 
apt-get update -y
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git wget pwgen curl libdb4.8-dev bsdmainutils libdb4.8++-dev \
libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev  libdb5.3++ unzip lib32stdc++6 lib32z1 libzmq5
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test

sudo apt -y install gcc-6
sudo apt -y install g++-6

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6 
sudo apt -y update
sudo apt -y upgrade



fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon -s
echo "/swapfile none swap sw 0 0" >> /etc/fstab




fi

  wget -d $COIN_TGZ
  #export fileid=1gGiqVkJRDvPmhY_5v3_mlcIq617T1euB
  #export filename=bootstrap.zip
  #wget --save-cookies cookies.txt 'https://docs.google.com/uc?export=download&id='$fileid -O- \
  #   | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p' > confirm.txt

  #
  #wget --load-cookies cookies.txt -O $filename \
  #   'https://docs.google.com/uc?export=download&id='$fileid'&confirm='$(<confirm.txt)
  unzip $COIN_ZIP
  chmod +x $COIN_DAEMON
  chmod +x $COIN_CLI
  sudo cp  $COIN_DAEMON /usr/local/bin
  sudo cp  $COIN_CLI /usr/local/bin
  rm -rf $COIN_ZIP
  rm -rf $COIN_CLI
  rm -rf $COIN_DAEMON
  rm -rf $COIN_TX
  rm -rf $COIN_QT


  sudo apt install -y ufw
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw logging on
  echo "y" | sudo ufw enable
  sudo ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc


 ## Setup conf
 IP=$(curl -s4 api.ipify.org)
 mkdir -p ~/bin
 echo ""
 echo "Configure your masternodes now!"
 echo "Detecting IP address:$IP"

echo ""
echo "How many nodes do you want to create on this server? [min:1 Max:20]  followed by [ENTER]:"
read MNCOUNT
  
  

for i in `seq 1 1 $MNCOUNT`; do
  echo ""
  echo "Enter alias for new node"
  read ALIAS  
  echo ""
  echo "Enter port for node $ALIAS"
  read PORT
  echo ""
  echo "Enter masternode private key for node $ALIAS"
  read PRIVKEY
  RPCPORT=$(($PORT*10))
  echo "The RPC port is $RPCPORT"
  ALIAS=${ALIAS}
  CONF_DIR=~/.$COINNAME_$ALIAS

  # Create scripts
  echo '#!/bin/bash' > ~/bin/$COIN_DAEMON_$ALIAS.sh
  echo "$COIN_DAEMON -daemon -conf=$CONF_DIR/$CONFIG_FILE -datadir=$CONF_DIR "'$*' >> ~/bin/$COIN_DAEMON_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/$COIN_CLI_$ALIAS.sh
  echo "$COIN_CLI -conf=$CONF_DIR/$CONFIG_FILE -datadir=$CONF_DIR "'$*' >> ~/bin/$COIN_CLI_$ALIAS.sh
  chmod 755 ~/bin/$COIN_DAEMON_$ALIAS.sh
  chmod 755 ~/bin/$COIN_CLI_$ALIAS.sh
  mkdir -p $CONF_DIR
  #unzip  bootstrap.zip -d $CONF_DIR
  echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> COIN_TEMP
  echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> COIN_TEMP
  echo "rpcallowip=127.0.0.1" >> COIN_TEMP
  echo "rpcport=$RPCPORT" >> COIN_TEMP
  echo "listen=1" >> COIN_TEMP
  echo "server=1" >> COIN_TEMP
  echo "daemon=1" >> COIN_TEMP
  echo "logtimestamps=1" >> COIN_TEMP
  echo "maxconnections=256" >> COIN_TEMP
  echo "masternode=1" >> COIN_TEMP
  echo "" >> COIN_TEMP

  echo "" >> COIN_TEMP
  echo "port=$PORT" >> COIN_TEMP
  echo "masternodeaddr=$IP:$COIN_PORT" >> COIN_TEMP
  echo "masternodeprivkey=$PRIVKEY" >> COIN_TEMP
  echo "addnode=149.28.141.28" >> COIN_TEMP
  echo "addnode=45.77.41.234" >> COIN_TEMP
  echo "addnode=95.217.140.128" >> COIN_TEMP
  echo "addnode=95.217.140.129" >> COIN_TEMP
  echo "addnode=95.217.140.130" >> COIN_TEMP
  echo "addnode=95.217.140.131" >> COIN_TEMP
  echo "addnode=95.217.140.132" >> COIN_TEMP
  sudo ufw allow $PORT/tcp
  mv COIN_TEMP $CONF_DIR/$CONFIG_FILE
  
  
  
  cat << EOF > /etc/systemd/system/$COINNAME_$ALIAS.service
[Unit]
Description=$COINNAME_$ALIAS service
After=network.target
[Service]
User=root
Group=root
Type=forking
ExecStart=/usr/local/bin/$COIN_DAEMON -daemon -conf=$CONF_DIR/$CONFIG_FILE -datadir=$CONF_DIR
ExecStop=/usr/local/bin/$COIN_CLI -conf=$CONF_DIR/$CONFIG_FILE -datadir=$CONF_DIR stop
Restart=always
PrivateTmp=true
TimeoutStartSec=10m
StartLimitInterval=0
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 10
  mv COIN_TEMP $CONF_DIR/$CONFIG_FILE
  systemctl start $COINNAME_$ALIAS.service
  systemctl enable $COINNAME_$ALIAS.service >/dev/null 2>&1


  rm -rf setup.sh

  #(crontab -l 2>/dev/null; echo "@reboot sh ~/bin/wagerrd_$ALIAS.sh") | crontab -
#	   (crontab -l 2>/dev/null; echo "@reboot sh /root/bin/wagerrd_$ALIAS.sh") | crontab -
#	   sudo service cron reload
  
done
