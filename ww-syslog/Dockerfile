FROM node:carbon

WORKDIR /usr/src/app

COPY package.json ./

COPY index.js ./

RUN npm config set registry http://10.12.74.71:8081/repository/npm-group/

RUN npm install

EXPOSE 514/udp

CMD [ "node", "index.js" ]

# docker build . -t ww-syslog/latest
# docker build . -t asia.gcr.io/gcp-wow-stores-mdm-rfdev-dev/test