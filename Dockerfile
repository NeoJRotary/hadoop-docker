FROM openjdk:8-alpine

RUN apk add --no-cache bash
# for ps cmd
RUN apk add --no-cache procps
# ssh server
RUN apk add --no-cache openssh

COPY hadoop-2.7.3 /hadoop

ENV USER root
ENV HADOOP_HOME /hadoop
ENV HADOOP_PREFIX $HADOOP_HOME
ENV HADOOP_MAPRED_HOME $HADOOP_HOME
ENV HADOOP_COMMON_HOME $HADOOP_HOME
ENV HADOOP_HDFS_HOME $HADOOP_HOME
ENV HADOOP_YARN_HOME $HADOOP_HOME
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin

COPY hadoop-env.sh $HADOOP_CONF_DIR/
COPY slaves $HADOOP_CONF_DIR/
COPY core-site.xml $HADOOP_CONF_DIR/
COPY hdfs-site.xml $HADOOP_CONF_DIR/
COPY yarn-site.xml $HADOOP_CONF_DIR/
COPY mapred-site.xml $HADOOP_CONF_DIR/

EXPOSE 50010 50020 50070 50075 50090 8020 9000
EXPOSE 10020 19888
EXPOSE 8030 8031 8032 8033 8040 8042 8088

COPY ssh /etc/ssh
COPY ssh/authorized_keys /root/.ssh/
COPY ssh/id_rsa /root/.ssh/
COPY ssh/id_rsa.pub /root/.ssh/
RUN chmod 600 /etc/ssh/*
RUN chown root:root /etc/ssh/*
RUN chmod 600 /root/.ssh/*
RUN chown root:root /root/.ssh/*

COPY .bash_profile /root/
COPY .profile /root/
COPY hosts /
COPY hadoop.sh /
RUN chmod +x /hadoop.sh
RUN chmod +x /$HADOOP_HOME/sbin/*.sh
CMD  ["/hadoop.sh"]
