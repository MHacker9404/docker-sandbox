FROM node:alpine

WORKDIR /app

COPY package.json .

RUN yarn install

COPY . .

EXPOSE 80

CMD ["node", "app.js"]