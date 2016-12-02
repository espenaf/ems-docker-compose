FROM java:8
ADD ems/ /
RUN mkdir -p /root/ems/binary-storage
ADD ems-prod.conf /root/etc/
ADD passwords.properties /root/etc/
ADD permalinks.json /root/etc/
ADD wait-for-it.sh /
ENV APP_HOME /root
ENV CONSTRETTO_TAGS prod
EXPOSE 8081
EXPOSE 5005
CMD /wait-for-it.sh db:5432 -- /root/bin/jetty
