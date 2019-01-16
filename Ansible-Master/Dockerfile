# docker build --build-arg nodes=int
FROM ubuntu:18.10
ARG nodes

# Disable ssh key checking
# Don't do this in prod please
ENV ANSIBLE_HOST_KEY_CHECKING false

RUN apt-get update 
RUN apt-get install -qq openssh-server python unzip net-tools iputils-ping ansible nano
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Add test servers into ansible hosts file
RUN echo '[nodes]' >> /etc/ansible/hosts
RUN echo 'ansible-node-[1:'$nodes']' >> /etc/ansible/hosts

RUN mkdir /root/.ssh/
RUN ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
RUN ssh-keygen -y -f /root/.ssh/id_rsa >> /root/.ssh/id_rsa.pub

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]