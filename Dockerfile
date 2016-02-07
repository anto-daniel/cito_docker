FROM ubuntu:14.04
MAINTAINER AntoDaniel

#Installation of CITO and dependencies

RUN apt-get update && apt-get install libmysqlclient-dev python-dev python-pip git -y
RUN pip install virtualenv

#Downloading and installing the code.

RUN cd /tmp && git clone https://github.com/CitoEngine/cito_engine
RUN cd /tmp/cito_engine && python setup.py install
RUN cd /opt/
RUN virtualenv /opt/citoengine
CMD source /opt/citoengine/bin/activate
RUN pip install -r /tmp/cito_engine/requirements.txt

#MySQL Installation and Configuration

RUN apt-get update && apt-get install -y debconf-utils \
    && echo mysql-server-5.5 mysql-server/root_password password Cito123 | debconf-set-selections \
    && echo mysql-server-5.5 mysql-server/root_password_again password Cito123 | debconf-set-selections \
    && apt-get install -y mysql-client mysql-server-5.5 -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing \
    && /etc/init.d/mysql start
COPY sample.sh /
COPY create_cito.sql /
COPY citoengine.conf /
RUN /sample.sh
RUN cp /citoengine.conf /opt/citoengine/conf/citoengine.conf

#Initializing the tables and creating an admin account.

CMD source /opt/citoengine/bin/activate
RUN cd /opt/citoengine/app && /etc/init.d/mysql start && python manage.py makemigrations && python manage.py migrate
RUN sh -c '/opt/citoengine/bin/create-django-secret.py > /opt/citoengine/app/settings/secret_key.py'
RUN service mysql start && cd /opt/citoengine/app && python manage.py createsuperuser

#RUN dpkg-reconfigure mysql-server-5.5 


ENTRYPOINT /bin/bash
