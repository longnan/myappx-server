REM ######################################################
REM Update MyAppx Docker Suite 
REM ######################################################
REM ......................................................
call env.bat

set MYAPPX_MIGRATE_EXISTING_DATABASE=true

REM ######################################################
REM Building images...
REM ######################################################
docker-compose -f ../images/myappxserver/docker-compose-test.yml build --build-arg MYAPPX_TAG=%MYAPPX_TAG%

REM ######################################################
REM Recreate Container...
REM ######################################################
docker-compose -p myappx-server -f ../images/myappxserver/docker-compose-test.yml up --force-recreate -d

REM ######################################################
REM List all
REM ######################################################
docker network ls
docker volume ls
docker ps

REM ......................................................
REM ######################################################
REM Finished!
REM ######################################################