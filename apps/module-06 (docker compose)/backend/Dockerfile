FROM node:alpine

WORKDIR /app

COPY package.json .

RUN yarn install

COPY . .

EXPOSE 80

ENV MONGO_USERNAME=root
ENV MONGO_PASSWORD=abcdABCD

ENTRYPOINT ["yarn", "start"]
