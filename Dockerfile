
FROM node:4.4.7-slim

RUN apt-get update && apt-get install -y \
  g++ \
  libzmq3-dev \
  make \
  python

EXPOSE 3001 3232 6667 8333 18333
HEALTHCHECK --interval=5s --timeout=5s --retries=10 CMD pidof bitcoind

WORKDIR /root/bitcoin-node
COPY bitcore-node ./
RUN npm config set package-lock false && npm install

RUN apt-get purge -y \
  g++ make python gcc && \
  apt-get autoclean && \
  apt-get autoremove -y

RUN rm -rf \
  node_modules/bitcore-node/test \
  node_modules/bitcore-node/bin/bitcoin-*/bin/bitcoin-qt \
  node_modules/bitcore-node/bin/bitcoin-*/bin/test_bitcoin \
  node_modules/bitcore-node/bin/bitcoin-*-linux64.tar.gz \
  /root/.npm \
  /root/.node-gyp \
  /tmp/* \
  /var/lib/apt/lists/*

ENTRYPOINT sed -i -- "s/\"testnet\"/\"${BITCOIN_NETWORK}\"/g" ./bitcore-node.json && \
  NODE_CONFIG_DIR=/root/config ./node_modules/.bin/bitcore-node start

VOLUME /root/bitcoin-node/data
