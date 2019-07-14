FROM node:10.16.0-alpine as build-env
WORKDIR /app

COPY . .

RUN npm install

FROM node:10.16.0-alpine as test-env
WORKDIR /app
COPY --from=build-env /app .
RUN npm run build

FROM node:10.16.0-alpine as production-env
WORKDIR /app
COPY --from=build-env /app/server.js ./
COPY --from=build-env /app/package.json ./
RUN npm i --only=production
ENTRYPOINT ["npm", "start"]
