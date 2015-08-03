FROM centos:6.6

RUN yum -y install epel-release
RUN yum -y install salt-minion
RUN yum -y install sudo

ADD example/minion /etc/salt/minion
ADD slslint.sh /usr/bin/slslint
ADD lint.py /usr/lib/python2.6/site-packages/lint.py

CMD python -m lint --stable /srv/salt && slslint
