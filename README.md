# HADOOP 2.7.3 Cluster in Docker

Build from `openjdk:8-alpine`

### Quick Setup
- Download binary release from [official releases](http://hadoop.apache.org/releases.html) and extract to repository folder
- Delete `hadoop/share/doc` to decrease file size
- Run `docker build -t hadoop .`
- Create new docker network `docker network create --subnet 172.18.0.0/16 hadoop`
- Run two datanodes  
`docker run --name hadoop-n2 --net hadoop --ip 172.18.1.2 -e -it -d hadoop`  
`docker run --name hadoop-n3 --net hadoop --ip 172.18.1.3 -e -it -d hadoop`
- Run core namenode  
`docker run --name hadoop-n1 --net hadoop --ip 172.18.1.1 -e ROLE="namenode" -p 50070:50070 -p 8088:8088 -p 19888:19888 -it hadoop`
- Browse each Web UI for more information  
Namenode : `http://localhost:50070`  
Resourcemanager : `http://localhost:8088`  
JobHistory : `http://localhost:19888/`

### ENV VAR
- ROLE : set "namenode" for core namenode. Default is empty.
- MODE : set "ENV" for ENV mode. Default is empty.  
(About ENV mode, see HOSTS part below)
- HOSTS : be used in ENV mode. Default is empty.
- DNSNAMESERVER : change the DNS settings in `hdfs-site.xml` and `mapred-site.xml`. Default is "default".

### Hadoop Configuration
System will auto-setup configuration files by `slaves`. ( or you can just hard-coding your files )  
First one will be core namenode.  
Second one will be secondary namenode.  
  
Read [hadoop docs/r2.7.3](https://hadoop.apache.org/docs/r2.7.3/)  for detail.

### HOSTS
Default system will overwrite `/etc/hosts` by your `hosts` file. Don't forget to change `slaves` also.    
  
If you set `-e MODE="ENV"`, you also have to set `-e HOSTS="HOST1,HOST2,HOST3"`. According to `$HOSTS`, system create `slaves` and configure hadoop by it.    
In this case, system skips overwritting `/etc/hosts`. It is recommend to also set docker hostname `-h HOST1` in docker command. Docker will change settings in `/etc/hosts` to your hostname instead container id. 

For example, we setup by docker's container DNS hostname :  
`docker run --name hadoop-n1 --net hadoop --ip 172.18.1.1 -h hadoop-n1.hadoop -e ROLE="namenode" -e MODE="ENV" -e HOSTS="hadoop-n1.hadoop,hadoop-n2.hadoop,hadoop-n3.hadoop" -p 50070:50070 -p 8088:8088 -p 19888:19888 -it hadoop`

### SSH
For quick setup, we pre-generate keys in `ssh` folder. You can generate yours and update the config.
