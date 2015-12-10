FROM centos

# env
ENV STATIC_DIR="/var/www/static"
ENV MEDIA_DIR="/var/www/media"

# dependency
RUN yum update -y
RUN yum install -y epel-release
RUN yum install -y python-pip gcc python-devel yum-utils \
                   mariadb mariadb-libs mariadb-devel
RUN pip install uwsgi
RUN yum-config-manager --enable cr
RUN yum -y install nginx

# directories
RUN mkdir /code
RUN mkdir -p /etc/uwsgi/vassals
RUN mkdir -p $MEDIA_DIR
RUN mkdir -p $STATIC_DIR

# config
ADD /conf/uwsgi.ini /etc/uwsgi/vassals/
ADD /conf/nginx.conf /etc/nginx/conf.d/

# workdir
ADD code/ /code
WORKDIR /code
RUN pip install -r requirements.txt

# expose
VOLUME "/var/www/media"
EXPOSE 8000

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
