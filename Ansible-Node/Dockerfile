FROM ubuntu:18.10

RUN apt-get update && apt-get install -qq openssh-server python unzip iputils-ping net-tools
RUN mkdir /var/run/sshd
RUN echo 'root:testing' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN mkdir ~/.ssh/
COPY ./id_rsa.pub /root/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
