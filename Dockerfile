FROM manous/centos7
MAINTAINER "Ousmane SANOGO" <sanoousmane@gmail.com>

ENV OPENERP_SERVER /etc/odoo/openerp-server.conf
ENV ODOO_VERSION 9.0
ENV ODOO_RELEASE 20171229

RUN yum install -y python-pip xorg-x11-fonts-75dpi xorg-x11-fonts-Type1 nodejs npm git libpng libX11 libXext libXrender wget
RUN wget -O /tmp/wkhtmltox.rpm https://downloads.wkhtmltopdf.org/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-centos7-amd64.rpm && \
    yum localinstall -y /tmp/wkhtmltox.rpm

RUN wget --no-check-certificate -O /tmp/odoo.rpm https://nightly.odoo.com/${ODOO_VERSION}/nightly/rpm/odoo_${ODOO_VERSION}c.${ODOO_RELEASE}.noarch.rpm && \
    yum localinstall -y /tmp/odoo.rpm && \
    rm -rf /tmp/odoo.rpm

COPY ./entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]

COPY ./openerp-server.conf /etc/odoo/

RUN mkdir -p /mnt/extra-addons

RUN chown odoo /etc/odoo/openerp-server.conf && \
    chown -R odoo:odoo /var/lib/odoo && \
    chown -R odoo: /mnt/extra-addons

VOLUME [ "/var/lib/odoo", "/mnt/extra-addons" ]

EXPOSE 8069 8071

USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]