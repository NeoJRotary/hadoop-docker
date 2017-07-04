# HADOOP 2.7.3 Cluster in Docker

Build from `openjdk:8-alpine`

### Quick Setup
- Download binary release from [official releases](http://hadoop.apache.org/releases.html) and extract to repository folder
- Delete `hadoop/share/doc` to decrease file size
- Run `docker build -t hadoop .`
- Create new docker network `docker network create --subnet 172.18.0.0/16 hadoop`
- Run two slave container  
`docker run --name hadoop-s1 --net hadoop --ip 172.18.1.1  -e HOSTNAME="slave01" -it hadoop /hadoop.sh`  
`docker run --name hadoop-s2 --net hadoop --ip 172.18.1.2  -e HOSTNAME="slave02" -it hadoop /hadoop.sh`
- Run master container  
`docker run --name hadoop-master --net hadoop --ip 172.18.1.0 -p 50070:50070 -p 8088:8088 -p 19888:19888 -e HOSTNAME="master" -e FORMAT="true" -it hadoop /hadoop.sh  `
- Browse each Web UI for more information  
Namenode : `http://localhost:50070`  
Resourcemanager : `http://localhost:8088`  
JobHistory : `http://localhost:19888/`

### Hadoop Configuration
Please read [docs](https://hadoop.apache.org/docs/r2.7.3/)  

### HOSTS
Setup hosts in `hosts`  
Update hostname/ip in `slaves`  
Update hostname/ip in `core-site.xml` and `hdfs-site.xml`  
Update docker command to your subnet, ip and hostname

### SSH
For quick setup, we pre-generate keys in `ssh` folder. You can update yours or change config files here.
