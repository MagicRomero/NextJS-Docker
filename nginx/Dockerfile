# Base on offical NGINX Alpine image
FROM nginx:stable-alpine

RUN rm /etc/nginx/conf.d/*

ADD ./default.conf /etc/nginx/conf.d/default.conf

# Expose the listening port
EXPOSE 80

# Launch NGINX
CMD [ "nginx", "-g", "daemon off;" ]