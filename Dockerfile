FROM ubuntu:16.04

RUN apt update
RUN apt install -y iputils-ping

RUN ping -c 4  www.bing.com
RUN ping -c 4  www.bing.co.in
RUN ping -c 4  www.bing.co.uk
RUN ping -c 4  www.bing.co.nz
RUN ping -c 4  www.bing.com.ar
RUN ping -c 4  www.bing.co.za
