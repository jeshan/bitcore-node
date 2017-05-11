# bitcore-testnet
Image to run a bitcoin wallet service that connects to testnet using bitcore

Installs:
* insight UI
* insight API
* bitcore wallet service

Run with:

`docker run --restart=unless-stopped -P -d --network=host -v /root/testnode --name testnet jeshan/bitcore-testnet`

