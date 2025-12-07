FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y \
    nginx \
    openssl && \
    rm -rf /var/lib/apt/lists/*


RUN mkdir -p /etc/nginx/ssl


RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=DE/ST=Baden-Wurttemberg/L=Stuttgart/O=42/OU=42/CN=tndreka.42.fr"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]