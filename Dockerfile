FROM mhart/alpine-node

WORKDIR /usr/src/app

COPY src/package*.json ./

RUN npm install

COPY ./src .

RUN npm run build

CMD ["npm", "run", "dev"]