FROM gmathieu/node-browsers:4.0.1 AS build

COPY package.json /usr/angular-workdir/
WORKDIR /usr/angular-workdir

RUN npm install

COPY ./ /usr/angular-workdir
RUN npm run build

FROM nginx:alpine

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# support running as arbitrary user which belogs to the root group
RUN chmod -R g+rwx /var/cache/nginx /var/run /var/log /var/log/nginx /usr/share/nginx/html/*

COPY --from=build  /usr/angular-workdir/dist/dcx-customer-portal-ui /usr/share/nginx/html/dcx-customer-portal-ui

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]