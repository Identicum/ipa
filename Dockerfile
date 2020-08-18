FROM identicum/centos-apache:latest

RUN yum -y update && \
    yum -y install mod_ssl && \
    rm -f /etc/httpd/conf.d/autoindex.conf

# Server global parameters
RUN sed -i 's/^#ServerName.*/ServerName ipa.identicum.com/' /etc/httpd/conf/httpd.conf && \
    sed -i 's/^ServerAdmin.*/ServerAdmin ipa@identicum.com/' /etc/httpd/conf/httpd.conf

# add mod_auth_openidc
RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/h/hiredis-0.12.1-2.el7.x86_64.rpm -O /tmp/hiredis.rpm && \
    yum localinstall -y /tmp/hiredis.rpm && \
    rm -f /tmp/hiredis.rpm && \
    wget https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.4.0/cjose-0.6.1.5-1.el7.x86_64.rpm -O /tmp/cjose.rpm && \
    yum localinstall -y /tmp/cjose.rpm && \
    rm -f /tmp/cjose.rpm && \
    wget https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.4.3/mod_auth_openidc-2.4.3-1.el7.x86_64.rpm -O /tmp/mod_auth_openidc.rpm && \
    yum localinstall -y /tmp/mod_auth_openidc.rpm && \
    rm -f /tmp/mod_auth_openidc.rpm

COPY conf/ /etc/httpd/conf.d/
COPY html/ /var/www/html/

RUN mkdir /etc/httpd/conf.ipa/ && \
    echo " " >> /etc/httpd/conf/httpd.conf && \
    echo "# Load IPA config files" >> /etc/httpd/conf/httpd.conf && \
    echo "IncludeOptional conf.ipa/*.conf" >> /etc/httpd/conf/httpd.conf

EXPOSE 443
