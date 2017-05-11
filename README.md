There are some pain points in installing the bitcore wallet service *and* making it connect to a node that you control.
(e.g this issue: https://github.com/bitpay/bitcore-wallet-service/issues/643)

I have created this image to solve this.

Installs:
* insight UI
* insight API
* bitcore wallet service
* Mongo DB

Run with:

`docker run --restart=unless-stopped -P -d --network=host -v /root/testnode --name testnet jeshan/bitcore-testnet`

Dockerfile available at:
https://github.com/jeshan/bitcore-testnet
