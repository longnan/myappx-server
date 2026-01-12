REM ######################################################
REM Install MyAppx Docker Suite
REM ######################################################
REM ......................................................
call env.bat

REM ######################################################
REM Creating data volume...
REM ######################################################
docker volume create --name=myappx_portainer_data
docker volume create --name=myappx_pgsql_data
docker volume create --name=myappx_pgadmin_data

REM ######################################################
REM Creating separate docker network...
REM ######################################################
docker network create -d bridge myappx-net

REM ######################################################
REM Building images...
REM ######################################################
docker-compose -f ../images/myappxserver/docker-compose.yml build --build-arg MYAPPX_TAG=%MYAPPX_TAG%

REM ######################################################
REM Starting...
REM ######################################################
docker-compose -f ../images/pgsql/docker-compose.yml up --force-recreate -d
docker-compose -f ../images/traefik/docker-compose.yml up --force-recreate -d
docker-compose -f ../images/greenmail/docker-compose.yml up --force-recreate -d
docker-compose -f ../images/pgadmin4/docker-compose.yml up --force-recreate -d
docker-compose -f ../images/portainer/docker-compose.yml up --force-recreate -d

docker-compose -p myappx-server -f ../images/myappxserver/docker-compose.yml up --force-recreate -d

REM ######################################################
REM List all
REM ######################################################
docker network ls
docker volume ls
docker ps

REM ......................................................
REM ######################################################
REM Setup Finished!
REM ######################################################
