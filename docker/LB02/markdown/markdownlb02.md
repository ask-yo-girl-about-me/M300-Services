# LB01 von Leandro Götzer

## Auftrag
---


### Meine Idee für die LB01


### Informationen
[1]: https://docs.google.com/document/d/1M-aswL3k4uI-_MYO8RLX7ExAFEzVJkUoqjAOLj9gtyY/edit
[2]: https://guides.github.com/features/mastering-markdown/
[3]: https://bscw.tbz.ch/bscw/bscw.cgi/25833849
[4]: https://github.com/ask-yo-girl-about-me/M300-Services.git
[5]: https://docs.docker.com/samples/library/teamspeak/
[6]: https://hub.docker.com/_/httpd
[7]: https://docs.docker.com/compose/install/

Alle Unterlagen befinden sich im [BSCW-M300][3] Folder. Noch mehr Informationen finden sie im [Lernjournal][1] vom M300.
Dieses Dokument wurde mit [Markdown][2] geschrieben

### Nützliche Links
* [TBZ][1]
* [Mastring Markdown][2]
* [BSCW][3]
* [Mein Repository][4]
* [TeamSpeak Installation][5]
* [Apache Installation][6]
* [Docker Compose][7]

## Vorbereitung
---
Wir werden die gleichen Services wie in der LB01 nehmen.
- Apache
- TeamSpeak

## TeamSpeak und Apache
---
Das ganze wir wie folgt aussehen. Wir das ganze brauchen wir ein Linux System. Mit unserem Vagrantfile, dass unter LB02/docker/Vagrantfile liegt, werden wir unser TeamSpeak und Apache Server installieren. Dort sind alle nötigen einrichtungen gemacht die unser System braucht.

## Installation
---
1. Vagrantfile ausführen
```
vagrant up
```
2. Wenn die VM fertig eingerichtet ist, per SSH mit der VM verbinden
```
vagrant SSH
```
4. In das richtige Verzeichnis wechseln, indem die Docker Files sind
```
cd /vagrant/teamspeak/
```
3. Nun bilden wir einen Image für unsere Dienste (dies aus dem Grund, dass wir nacher mit Doker-Compose arbeiten können)
```
docker build -t tslb02 .
```

Nun führen wir entweder das Dockerfile aus mit den nötigen Parameter (4.) oder wir führen das Docker-Compose file aus in dem die Parameter enthalten sind (5.)

4. Dockerfile ausführen damit wir dies in userem Image haben
```
docker run -p 9987:9987/udp -p 10011:10011 -p 30033:30033 -e TS3SERVER_LICENSE=accept "imagename"
```
5. Nun führen wir unser Dienst aus per Docker-Compose. In diesem File sind alle nötigen Parameter vorhanden
```
docker-compose run
```
### Konfigurieren der VM (WebServer)




### Installieren von WebServer


## Testing


## Wichtige Befehle!!!

# Infos für Docker
---

```
- vb.name = "TeamSpeak-Server
```

Netzwerkeinstellugnen sollten ungefair so aussehen:

| Namen        | Protokoll | Host-IP | Host-Port | Gast-IP  | Gast-Port |
| :-----------:|:---------:|:-------:|:---------:|:--------:|:---------:|
|      |       | 0.0.0.0 |      | -        |        |
| |        | 0.0.0.0 |    | -        |        |
