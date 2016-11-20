#!/bin/bash
# requires sbt, lein, mvn, docker, docker-compose
mkdir -p code
cd code
git clone git@github.com:computerlove/ems-redux.git
cd ems-redux
git checkout TDC
sbt appmgr:packageBin
# target/appmgr
cd ..
git clone git@github.com:computerlove/submitit-redux.git
cd submitit-redux
git checkout TDC
lein uberjar
# target/submitit-1.0.TDC-standalone.jar
cd ..
git clone git@github.com:computerlove/cake-redux.git
cd cake-redux
git checkout TDC
mvn install -Dmaven.test.skip
# target/cake-redux-1.0.TDC-jar-with-dependencies.jar
cd ..
git clone git@github.com:computerlove/javazone-web-api.git
cd javazone-web-api
git checkout TDC
mvn install -Dmaven.test.skip
# target/javazone-web-api-1.0-TDC-appmgr.zip
cd ../..
# Dockerize
docker build -t ems-postgresql postgres
cp -R code/ems-redux/target/appmgr ems/ems
docker build -t ems ems
rm -rf ems/ems
cp code/cake-redux/target/cake-redux-1.0.TDC-jar-with-dependencies.jar cake/cake-redux.jar
docker build -t cake cake
rm cake/cake-redux.jar
mkdir -p api/api
unzip code/javazone-web-api/target/javazone-web-api-1.0-TDC-appmgr.zip -d api/api
docker build -t api api
rm -rf api/api
cp code/submitit-redux/target/submitit-1.0.TDC-standalone.jar submittit/submitit.jar
docker build -t submitit submittit
rm submittit/submitit.jar
echo "Now run docker-compose -f compose/docker-compose.yml up"