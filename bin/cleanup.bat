REM ######################################################
REM Cleanup MyAppx Docker Suite
REM ######################################################
REM ......................................................
call env.bat

REM ######################################################
REM Stopping and removing containers...
REM ######################################################
docker-compose -p myappx-server -f ../images/myappxserver/docker-compose.yml down -v

docker-compose -f ../images/traefik/docker-compose.yml down -v
docker-compose -f ../images/portainer/docker-compose.yml down -v
docker-compose -f ../images/greenmail/docker-compose.yml down -v
docker-compose -f ../images/pgadmin4/docker-compose.yml down -v
docker-compose -f ../images/pgsql/docker-compose.yml down -v

REM ###### Prune all stopped containers
docker container prune -f

REM ######################################################
REM Removing data volume...
REM ######################################################
docker volume rm myappx_portainer_data
docker volume rm myappx_pgsql_data
docker volume rm myappx_pgadmin_data

REM ###### Prune all unused volumes 
docker volume prune -f

REM ######################################################
REM Removing network...
REM ######################################################
docker network rm myappx-net

REM ######################################################
REM List all
REM ######################################################
docker ps
docker volume ls
docker network ls

REM ......................................................
REM ######################################################
REM Cleanup Finished!
REM ######################################################