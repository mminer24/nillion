#!/bin/bash

echo Nillion proba poprawienia na True

payforblock=5360010
block01=payforblock-100
actblock=5867187
blcok02=actblock-100 

#sprawdzenie czy sa dockery
echo Lista dockerow
docker ps -a ;

#Zatrzymanie i skasowanie dokera Nillion
echo Zatrzymanie i skasowanie dokera Nillion
docker stop nillion ;
docker rm -f nillion ;

#wstrzymanie zeby sprawdzic czy nie bylo bledu
sleep 10 ;

#czy sa pliki  do wykasowania
echo Lista plikow w katalogu accuser
ls /root/nillion/accuser ;

#kasowanie 3 plikow accuser.db accuser.db-shm accuser.db-wal w katalogu nillion/accuser
rm /root/nillion/accuser/accuser.db ;
rm /root/nillion/accuser/accuser.db-shm ;
rm /root/nillion/accuser/accuser.db-wal ;

#czy wykasowalo pliki
echo Lista plikow w katalogu accuser po wykasowaniu
ls /root/nillion/accuser ;

#wstrzymanie zeby sprawdzic czy nie bylo bledu
sleep 10 ;

#ponowna inicjalizacja
docker run -v ./nillion/accuser:/var/tmp nillion/retailtoken-accuser:v1.0.1 initialise 

#wstrzymanie zeby mial czas zainicjowac
sleep 30

#uruchomienie dockera przez Blokiem w ktorym Node byl zarejestrowany
docker run -d --name nillion -v $HOME/nillion/accuser:/var/tmp nillion/retailtoken-accuser:v1.0.1 accuse --rpc-endpoint "https://nillion-testnet-rpc.polkachu.com/" --block-start 5362450 && docker logs -f nillion --tail=50

#idealnie by bylo jakby wklejal zmienna payforblock do powyzszej komendy
#--block-start $payforblock

#i tutaj musze zrobic cos zeby w trakcie dzialania komendy sprawdzil czy juz blok na ktorym byl Node zarejestrowany 
#poczekal np 15 sek i przeszedl do nastepnej komendy
#idealnie by bylo jakby sprawdzal i jesli pojawi sie blok - zmienna payforblock - to po 30 sek przechodzil do kolejnej komendy

#zatrzymanie i kasowanie dockera i ponowne uruchomienie z aktualnym blokiem -100
docker stop nillion ; 
docker rm -f nillion ; 
docker run -d --name nillion -v $HOME/nillion/accuser:/var/tmp nillion/retailtoken-accuser:v1.0.1 accuse --rpc-endpoint "https://nillion-testnet-rpc.polkachu.com/" --block-start 5866700 && docker logs -f nillion --tail=50

#idealnie by bylo jakby sprawdzal jaki jest aktualnie blokc z explorera i wklejal w powyzsza komende zmienna actblock
#--block-start $payforblock
