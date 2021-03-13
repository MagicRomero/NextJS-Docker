FROM node:alpine as development

WORKDIR /usr/src/app

ENV NODE_ENV=development
ENV CI=true
ENV MONGO_URL "mongodb://mongo:27017"
ENV DB_NAME points
ENV COL_NAME dataPoints

RUN npm -g config set user node
RUN npm install --global --unsafe-perm pm2@latest

COPY src/package*.json ./

RUN npm install --production && npm ci

COPY src ./

RUN npm run build
RUN chmod -R 0777 .

USER node

CMD ["pm2-runtime", "npm", "--", "run", "dev"]
