###################
# Dockerfile gitlab
###################

FROM centos:7
MAINTAINER liweiyw@mfhcd.com

RUN yum update -y; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum install -y supervisor logrotate nginx openssh-server \
    git postgresql mysql python python-docutils \
    mariadb-devel libpqxx zlib libyaml gdbm readline redis \
    ncurses libffi libxml2 libxslt libcurl libicu  \
    which sudo passwd tar initscripts cronie nodejs golang-bin golang; yum clean all
RUN yum install -y gcc gcc-c++ make patch pkgconfig cmake \
  glibc-devel community-mysql-devel postgresql-devel \
  zlib-devel libyaml-devel openssl-devel gdbm-devel readline-devel \
  ncurses-devel libffi-devel libxml2-devel libxslt-devel \
  libcurl-devel libicu-devel;yum clean all

# Proxy Setting adding file
#ADD environment /etc/environment

# Add files change permission and run install
RUN sed -i 's/Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers
ADD assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

# Copy more files needed to config and init gitlab
COPY assets/config/ /app/setup/config/
COPY assets/init /app/init
RUN chmod 755 /app/init

# Proxy Setting add empty file
#ADD assets/environment /etc/environment

RUN yum remove -y gcc gcc-c++ patch cmake \
  glibc-devel community-mysql-devel postgresql-devel \
  zlib-devel libyaml-devel openssl-devel gdbm-devel readline-devel \
  ncurses-devel libxml2-devel libxslt-devel \
  libcurl-devel libicu-devel

EXPOSE 22 80 443

VOLUME ["/home/git/data"]
VOLUME ["/var/log/gitlab"]

#WORKDIR /home/git/gitlab
ENTRYPOINT ["/app/init"]

CMD ["app:start"]
