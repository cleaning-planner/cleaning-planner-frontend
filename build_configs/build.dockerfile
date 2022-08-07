FROM node:16-alpine as build-image

WORKDIR /app

COPY . .

RUN npm install yarn \
    && yarn install --production \
    && yarn build


FROM nginx:1.21.3-alpine

COPY --from=build-image /app/build /www/data/app

RUN rm /etc/nginx/conf.d/*.conf
COPY ./build_configs/nginx.conf /etc/nginx/conf.d/app.conf

CMD nginx -g 'daemon off;'