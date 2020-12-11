# Overview
A PrestoDb v0.217 cluster in one box, mainly for testing. 

The choice of v0.217 is to match Athena Engine V2.

The cluster contains
 * hdfs
 * postgres backed hive metastore
 * prestodb 0.217
   * one coordinator (also as a worker)
   * two workers

# Credits
 * The docker-compose.yml is based on 
  https://github.com/big-data-europe/docker-hive 
 * The PrestoDb 0.217 Dockerfile is based on 
    tag 0.215 of https://github.com/shawnzhu/docker-prestodb 
 * The per node configuration file rendering design is based on 
    https://github.com/Lewuathe/docker-presto-cluster/scripts




