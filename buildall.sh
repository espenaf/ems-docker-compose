#!/bin/bash
# requires sbt, lein, mvn, docker, docker-compose
mkdir -p code
cd code
git clone git@github.com:espenaf/ems-redux.git
cd ems-redux
git checkout TDC
sbt appmgr:packageBin
# target/appmgr
cd ..
git clone git@github.com:espenaf/submitit-redux.git
cd submitit-redux
git checkout SOS
lein uberjar
# target/submitit-1.0.SOS-standalone.jar
cd ..
git clone git@github.com:espenaf/cake-redux.git
cd cake-redux
git checkout SOS
mvn install -Dmaven.test.skip
# target/cake-redux-1.0.SOS-jar-with-dependencies.jar
cd ..
git clone git@github.com:espenaf/javazone-web-api.git
cd javazone-web-api
git checkout TDC
mvn install -Dmaven.test.skip
# target/javazone-web-api-1.0-SOS-appmgr.zip
cd ../..
# Dockerize
sudo docker build -t ems-postgresql postgres
cp -R code/ems-redux/target/appmgr ems/ems
sudo docker build -t ems ems
rm -rf ems/ems
cp code/cake-redux/target/cake-redux-1.0.SOS-jar-with-dependencies.jar cake/cake-redux.jar
sudo docker build -t cake cake
rm cake/cake-redux.jar
mkdir -p api/api
unzip code/javazone-web-api/target/javazone-web-api-1.0-TDC-appmgr.zip -d api/api
sudo docker build -t api api
rm -rf api/api
cp code/submitit-redux/target/submitit-1.0.SOS-standalone.jar submittit/submitit.jar
sudo docker build -t submitit submittit
rm submittit/submitit.jar
echo "Now run docker-compose -f compose/docker-compose.yml up"