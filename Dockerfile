FROM  nginx

COPY nginx.conf /etc/nginx/nginx.conf

RUN 	mkdir -p /opt/maintenance_service
COPY 	maintenance/* /opt/maintenance_service/
COPY  ./errorPages/* /opt/errorPages/

COPY 	templates/*.j2 /templates/

COPY 	entrypoint.sh /entrypoint.sh
COPY 	tpl.py /tpl.py

ENV   SSL_CERTS_FOR_LIVE True
ENV   NGINX_DNS_RESOLVER 8.8.8.8 8.8.4.4 169.254.169.253
ENV   DNS_RESOLVER false
ENV   ACCESS_CONTROL_ALLOW_ORIGIN *.photobox.com
EXPOSE 	443 80

STOPSIGNAL SIGTERM

CMD ["sh", "/entrypoint.sh"]
