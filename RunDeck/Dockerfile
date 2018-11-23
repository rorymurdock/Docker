# Creates a rundeck container using Tomcat8
FROM rundeck/rundeck:SNAPSHOT

USER root

# Install all the stuff needed to run the scripts
RUN apt-get update && \
apt-get install -y \
python3 \
python3-pip && \
pip3 install --upgrade google-api-python-client && \
pip3 install --upgrade oauth2client && \
pip3 install httplib2 && \
export TZ=Australia/Melbourne

ADD realm.properties /home/rundeck/server/config/realm.properties