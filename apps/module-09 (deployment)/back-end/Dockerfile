FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

ENV MONGODB_USERNAME='<change me>'
ENV MONGODB_PASSWORD='<change me>'
ENV MONGO_HOST='<change me>'

CMD ["npm", "start"]