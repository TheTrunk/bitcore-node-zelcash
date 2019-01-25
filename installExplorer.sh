
#!/bin/bash

# install needed dependencies
cd
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential
sudo apt-get install -y libzmq3-dev

# MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.1 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.1.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl enable mongod
sudo service mongod start

#bitcore-node-commercium
cd
git clone -b commercium https://github.com/TheTrunk/bitcore-node-zelcash bitcore-node-commercium
cd bitcore-node-commercium
npm install
cd bin
chmod +x bitcore-node
cp ~/commerciumBitcore/src/commerciumd ~/bitcore-node-commercium/bin
./bitcore-node create mynode
cd mynode

rm bitcore-node.json

cat << EOF > bitcore-node.json
{
  "network": "livenet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api",
    "insight-ui",
    "web"
  ],
  "messageLog": "",
  "servicesConfig": {
      "web": {
      "disablePolling": false,
      "enableSocketRPC": false
    },
    "bitcoind": {
      "sendTxLog": "./data/pushtx.log",
      "spawn": {
        "datadir": "./data",
        "exec": "../commerciumd",
        "rpcqueue": 1000,
        "rpcport": 12020,
        "zmqpubrawtx": "tcp://127.0.0.1:28332",
        "zmqpubhashblock": "tcp://127.0.0.1:28332"
      }
    },
    "insight-api": {
        "routePrefix": "api",
                 "db": {
                   "host": "127.0.0.1",
                   "port": "27017",
                   "database": "commercium-api-livenet",
                   "user": "",
                   "password": ""
          },
          "disableRateLimiter": true
    },
    "insight-ui": {
        "apiPrefix": "api",
        "routePrefix": ""
    }
  }
}
EOF

cd data
cat << EOF > commercium.conf
server=1
whitelist=127.0.0.1
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://127.0.0.1:28332
zmqpubhashblock=tcp://127.0.0.1:28332
rpcport=12020
rpcallowip=127.0.0.1
rpcuser=commercium
rpcpassword=mycommerciumstrongpassword
uacomment=bitcore
mempoolexpiry=24
rpcworkqueue=1100
maxmempool=2000
dbcache=1000
maxtxfee=1.0
dbmaxfilesize=64
showmetrics=0
addnode=explorer.cmm.zelcore.io
EOF

cd ..
cd node_modules
git clone -b commercium https://github.com/TheTrunk/insight-api
git clone -b commerciumhttps://github.com/TheTrunk/insight-ui
cd insight-api
npm install
cd ..
cd insight-ui
npm install
cd ..
cd ..

echo "Explorer is installed"
echo "Then to start explorer navigate to mynode folder and type ../bitcore-node start. Explorer will be accessible on localhost:3001" 