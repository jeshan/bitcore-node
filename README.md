There are some pain points in installing the bitcore wallet service *and* making it connect to a node that you control.
(e.g this issue: https://github.com/bitpay/bitcore-wallet-service/issues/643)

I have created this image to solve this.

Installs:
* insight UI
* insight API

To run an image for testnet (the default):

`docker run --restart=unless-stopped -d --network=host -v /root/bitcoin-node --name livenet jeshan/bitcore-node`

To run an image for livenet, specify an environment variable *BITCOIN_NETWORK* with value *livenet*:

`docker run --env BITCOIN_NETWORK=livenet --restart=unless-stopped -d --network=host -v /root/bitcoin-node --name livenet jeshan/bitcore-node`

Dockerfile available at:
https://github.com/jeshan/bitcore-node
