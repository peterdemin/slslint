FROM centos:6.6

RUN yum -y install epel-release
RUN yum -y install salt-minion
RUN yum -y install sudo

COPY minion /etc/salt/minion
COPY slslint.sh /usr/bin/slslint

CMD slslint
