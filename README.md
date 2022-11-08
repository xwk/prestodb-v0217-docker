# Overview
A PrestoDb v0.217 cluster in one box, mainly for testing. 

The choice of v0.217 is to match Athena Engine V2.

The cluster contains
 * hdfs
   * one name node
   * two data nodes
 * hive metastore
   * postegres server (as backend)
   * hive metastore server
 * prestodb 0.217
   * one coordinator 
   * two workers

# Start the cluster
```shell script
docker-compose up
```
  The presto cluster listens on port 8080

# Run query
 * use presto cli

  Follow instructions at https://prestodb.io/docs/current/installation/cli.html to get presto cli, then run 
  `presto`, where you can issue queries.

 * use presto python client

  Follow instructions at https://github.com/prestodb/presto-python-client
  Notice, the connection params is as below
`conn=prestodb.dbapi.connect(host='localhost', user='the-user')`
  The user parameter must be set, but the value does not matter
 
 

# Copy files to HDFS
```docker-compose exec namenode /bin/bash```
It will drop you in the shell of the namenode container.
Notice, the definition in docker-compose.yaml have mounted the parent directory
 of current working directory on the host as the /workspace folder in the container.
 Suppose the files you want to import to hdfs is located in the ../data/ folder 
 on your host, then they are available as /workspace/data in the container. If this
 convention does not work for your situation, you can update the docker-compose.yaml
 to suit your situation.
 
 ```
hadoop fs -put /workspace/data /user/
 ```

# Create hive table
Unlike Athena, you can NOT create an external data located on HDFS from Presto.
You have to do that with Hive cli.
```docker-compose exec hive-server /bin/bash```
It will drop you into the hive-server container shell.
In the container shell, run hive client 'beeline'
```
/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000
```  
In the beeline shell, you can issue a CREATE EXTERNAL TABLE ddl query to 
create the table from data you have copied to HDFS.

Add partitions
Some how MSCK REPAIR TABLE ADD PARTITION does not working. I have to use
ALTER TABLE ADD PARTITION to manually add each partition.
      

# Monitoring service status
 * presto http://localhost:8080
 * hdfs http://localhost:50070
 


# Credits
 * The docker-compose.yml is based on 
  https://github.com/big-data-europe/docker-hive 
 * The PrestoDb 0.217 Dockerfile is based on 
    tag 0.215 of https://github.com/shawnzhu/docker-prestodb 
 * The per node configuration file rendering design is based on 
    https://github.com/Lewuathe/docker-presto-cluster/scripts
