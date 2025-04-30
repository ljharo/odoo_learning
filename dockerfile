FROM debian:stable-slim

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# Configuración básica
ENV LANG en_US.UTF-8
ENV ODOO_VERSION 18.0
ENV ODOO_RC /etc/odoo/odoo.conf

# Argumentos de construcción
ARG TARGETARCH
ARG ODOO_RELEASE=20250428
ARG ODOO_SHA=952a8f7148a7652809546ee7acdc2d66c09e04d9

# Instalar dependencias principales
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dirmngr \
        fonts-noto-cjk \
        gnupg \
        libldap2-dev \
        libpq-dev \
        libsasl2-dev \
        libssl-dev \
        node-less \
        npm \
        python3-dev \
        python3-pip \
        python3-wheel \
        python3-venv \
        python3-setuptools \
        python3-num2words \
        python3-phonenumbers \
        python3-pyldap \
        python3-qrcode \
        python3-renderpm \
        python3-slugify \
        python3-vobject \
        python3-watchdog \
        python3-xlrd \
        python3-xlwt \
        xz-utils && \
    rm -rf /var/lib/apt/lists/*

# Instalar wkhtmltopdf
RUN if [ -z "${TARGETARCH}" ]; then \
        TARGETARCH="$(dpkg --print-architecture)"; \
    fi; \
    case ${TARGETARCH} in \
        "amd64") WKHTMLTOPDF_ARCH=amd64 && WKHTMLTOPDF_SHA=967390a759707337b46d1c02452e2bb6b2dc6d59 ;; \
        "arm64") WKHTMLTOPDF_SHA=90f6e69896d51ef77339d3f3a20f8582bdf496cc ;; \
        "ppc64le" | "ppc64el") WKHTMLTOPDF_ARCH=ppc64el && WKHTMLTOPDF_SHA=5312d7d34a25b321282929df82e3574319aed25c ;; \
    esac && \
    curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_${WKHTMLTOPDF_ARCH}.deb && \
    echo "${WKHTMLTOPDF_SHA} wkhtmltox.deb" | sha1sum -c - && \
    apt-get update && \
    apt-get install -y --no-install-recommends ./wkhtmltox.deb && \
    rm -rf /var/lib/apt/lists/* wkhtmltox.deb

# Instalar PostgreSQL client
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ noble-pgdg main' > /etc/apt/sources.list.d/pgdg.list && \
    GNUPGHOME="$(mktemp -d)" && \
    export GNUPGHOME && \
    repokey='B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8' && \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${repokey}" && \
    gpg --batch --armor --export "${repokey}" > /etc/apt/trusted.gpg.d/pgdg.gpg.asc && \
    gpgconf --kill all && \
    rm -rf "$GNUPGHOME" && \
    apt-get update && \
    apt-get install --no-install-recommends -y postgresql-client && \
    rm -f /etc/apt/sources.list.d/pgdg.list && \
    rm -rf /var/lib/apt/lists/*

# Instalar rtlcss
RUN npm install -g rtlcss

# Instalar Odoo desde nightly builds
RUN curl -o odoo.deb -sSL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb && \
    echo "${ODOO_SHA} odoo.deb" | sha1sum -c - && \
    apt-get update && \
    apt-get -y install --no-install-recommends ./odoo.deb && \
    rm -rf /var/lib/apt/lists/* odoo.deb

# Configurar entorno Odoo
RUN mkdir -p /mnt/extra-addons && \
    chown -R odoo:odoo /mnt/extra-addons && \
    mkdir -p /var/lib/odoo && \
    chown -R odoo:odoo /var/lib/odoo

# Copiar archivos de configuración
COPY ./entrypoint.sh /
COPY ./odoo.conf /etc/odoo/
COPY ./wait-for-psql.py /usr/local/bin/wait-for-psql.py

RUN chown odoo:odoo /etc/odoo/odoo.conf && \
    chmod +x /entrypoint.sh && \
    chmod +x /usr/local/bin/wait-for-psql.py

# Volúmenes y puertos
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]
EXPOSE 8069 8071 8072

# Usuario y punto de entrada
USER odoo
ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]