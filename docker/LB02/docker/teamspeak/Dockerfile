FROM debian:jessie

#Unterhalter des Dokumentes
MAINTAINER Leandro Götzer

#ENV steht für Environment. Hier wird die Codierung definiert und die Teamspeak Version aktualisiert.
ENV TS_VERSION LATEST
ENV LANG C.UTF-8

#Zuerst werden Updates gemacht
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install bzip2 wget ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    #Hier wird ein Benutzer mit dem Benutzernamen teamspeak3 hinzugefügt
    && useradd -M -s /bin/false --uid 1000 teamspeak3 \
    #Danach wird ein Ordner data erstellt
    && mkdir /data \
    #Hier übernimmt der Benutzer teamspeak3 den Ordner als Owner
    && chown teamspeak3:teamspeak3 /data

#Kopieren der Scripts, welche im selben Ordner liegen müssen wie das Dockerfile
COPY get-version.sh /get-version
COPY start-teamspeak3.sh /start-teamspeak3

#Ports von der Virtuellen Maschine nach aussen öffnen
EXPOSE 9987/udp 10011 30033 41144

USER teamspeak3
VOLUME /data
WORKDIR /data
CMD ["/start-teamspeak3"]
