# Final stage MUST be named "production" — docker-build targets it.
FROM nginx:alpine AS production
COPY web/nginx.conf /etc/nginx/conf.d/default.conf
COPY web/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
