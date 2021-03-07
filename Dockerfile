FROM node:alpine as development

WORKDIR /usr/src/app


ENV NODE_ENV=development
ENV CI=true

RUN npm -g config set user node
RUN npm install --global --unsafe-perm pm2@latest

# RUN apk add --no-cache tree ffmpeg opus pixman cairo pango giflib ca-certificates \
#     && apk add --no-cache --virtual .build-deps python3-dev python3 g++ make gcc .build-deps curl git pixman-dev cairo-dev pangomm-dev libjpeg-turbo-dev giflib-dev \
#     && curl -O https://bootstrap.pypa.io/get-pip.py \
#     && python3 get-pip.py \
#     && pip install --upgrade six awscli awsebcli \
#     && apk del .build-deps

COPY src/package*.json ./

RUN npm install --production && npm ci

COPY src ./

RUN npm run build
RUN chmod -R 0777 .

USER node

CMD ["pm2-runtime", "npm", "--", "run", "dev"]