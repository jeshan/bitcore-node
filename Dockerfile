
# Built with:
# docker build -t jeshan/bitcore-node .

# Run a testnet node:
# docker run --env NETWORK=testnet --restart=unless-stopped -P -d --network=host -v /root/bitcoin-node --name testnet jeshan/bitcore-node

# Run a livenet node:
# docker run --restart=unless-stopped -P -d --network=host -v /root/bitcoin-node --name livenet jeshan/bitcore-node

FROM ubuntu

ARG MONGO_VERSION=3.2
ARG BWS_VERSION=1.15
ARG NODE_VERSION=4.4.7

ENV NETWORK=livenet
LABEL maintainer Jeshan G. BABOOA "j@jeshan.co"

EXPOSE 3001 3232 8333 6667

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/${MONGO_VERSION} multiverse" | tee /etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list

RUN apt-get update && apt-get install -y --allow-unauthenticated mongodb-org libzmq3-dev curl python build-essential checkinstall

ENV NVM_DIR /usr/local/nvm

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
ENV BWS_VERSION ${BWS_VERSION}

RUN npm i -g bitcore-node

WORKDIR /root

RUN bitcore-node create bitcoin-node
#COPY bitcore-node.json bitcoin-node/

WORKDIR /root/bitcoin-node
RUN bitcore-node install insight-ui insight-api web

WORKDIR /root

ADD https://github.com/bitpay/bitcore-wallet-service/archive/v${BWS_VERSION}.tar.gz bws.tar.gz

RUN tar zxf bws.tar.gz

# setup bitcore wallet service
COPY bws-config.js /root/bitcore-wallet-service-${BWS_VERSION}/config.js
RUN cd /root/bitcore-wallet-service-${BWS_VERSION} && npm i

# setup dirs for mongo
RUN mkdir -p /root/mongo-data

ENTRYPOINT sed -i -- "s/livenet/${NETWORK}/g" /root/bitcoin-node/bitcore-node.json && \
  mongod --dbpath /root/mongo-data/ --fork --logpath /root/mongo-data/mongod.log && \
  npm start --prefix /root/bitcore-wallet-service-${BWS_VERSION} && cd /root/bitcoin-node && bitcore-node start

