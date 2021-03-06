FROM mhart/alpine-node

WORKDIR /usr/src/app

ENV NPM_CONFIG_PREFIX=/usr/src/app/.npm-global
ENV PATH=$PATH:/usr/src/app/.npm-global/bin
ENV NODE_ENV=development
ENV CI=true

RUN addgroup -g 1000 -S node && \
    adduser -u 1000 -S node -G node

RUN mkdir ./.npm-global \
    && npm config set prefix '/usr/src/app/.npm-global' \
    && echo "export PATH=/usr/src/app/.npm-global/bin:$PATH" >> /usr/src/app/.profile 
RUN source /usr/src/app/.profile

RUN chown -R node $(npm config get prefix) && chown -R node .
RUN apk add --no-cache tree ffmpeg opus pixman cairo pango giflib ca-certificates \
    && apk add --no-cache --virtual .build-deps python3-dev python3 g++ make gcc .build-deps curl git pixman-dev cairo-dev pangomm-dev libjpeg-turbo-dev giflib-dev \
    && curl -O https://bootstrap.pypa.io/get-pip.py \
    && python3 get-pip.py \
    && pip install --upgrade six awscli awsebcli \
    && apk del .build-deps


COPY src/package*.json .

RUN npm install && npm ci

COPY src .

RUN chown -R node . && chmod 0755 -R .

USER node
