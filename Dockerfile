FROM ubuntu:18.04 as builder

# Install any needed packages
RUN apt-get update && apt-get install -y curl git gnupg autoconf make automake g++ libtool

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

WORKDIR /app
COPY . /app/apps

WORKDIR /app/apps
RUN npm install yarn -g
RUN yarn
RUN NODE_ENV=production yarn build

FROM ubuntu:18.04

RUN apt-get update && apt-get -y install nginx

COPY --from=builder /app/apps/packages/apps/build /var/www/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
