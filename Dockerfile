FROM node:10.16.0-alpine as build-env
WORKDIR /app

COPY . .

RUN npm install
RUN npm run build

FROM node:10.16.0-alpine as production-env
WORKDIR /app
COPY --from=build-env /app/server.js ./
COPY --from=build-env /app/package.json ./
RUN npm i --only=production

FROM node:10.16.0-alpine
WORKDIR /app
COPY --from=build-env /app/server.js .
COPY --from=build-env /app/package.json .
COPY --from=production-env /app/node_modules .
ENTRYPOINT ["npm", "start"]
