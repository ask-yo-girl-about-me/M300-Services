# LB02 von Leandro Götzer

## Auftrag
---
Container as a Service

### Meine Idee für die LB01


### Informationen
[1]: https://docs.google.com/document/d/1M-aswL3k4uI-_MYO8RLX7ExAFEzVJkUoqjAOLj9gtyY/edit
[2]: https://guides.github.com/features/mastering-markdown/
[3]: https://bscw.tbz.ch/bscw/bscw.cgi/25833849
[4]: https://github.com/ask-yo-girl-about-me/M300-Services.git
[5]: https://docs.docker.com/samples/library/teamspeak/
[6]: https://docs.docker.com/compose/install/

Alle Unterlagen befinden sich im [BSCW-M300][3] Folder. Noch mehr Informationen finden sie im [Lernjournal][1] vom M300.
Dieses Dokument wurde mit [Markdown][2] geschrieben

### Nützliche Links
* [TBZ][1]
* [Mastring Markdown][2]
* [BSCW][3]
* [Mein Repository][4]
* [TeamSpeak Installation][5]
* [Docker Compose][6]

## Netzwerkplan

![Image](bilder/netzwerkplan.jpeg)

## Vorbereitung
---
Wir werden den gleichen Services wie in der LB01 nehmen.
- TeamSpeak

Das ganze wird wie folgt aussehen. Für das ganze brauchen wir ein Linux System. Mit unserem Vagrantfile, dass unter LB02/docker/teamspeak/Vagrantfile liegt, werden wir unser TeamSpeak und Apache Server installieren. Dort sind alle nötigen einrichtungen gemacht die unser System braucht.

Alle Dateien sind in diesem Repository: https://github.com/ask-yo-girl-about-me/M300-Services.git

Work Directory: M300-Services\docker\LB02

Voraussetzung:
- Virtuelle Maschine mit Linux (M300-Serivces/docker/LB02/docker/teamspeak/Vagrantfile)
- TeamSpeak Ordner (M300-Serivces/docker/LB02/docker/teamspeak/)

Im TeamSpeak Ordner sind alle nötigen Datei die wir brauchen:
- Vagrant
- docker-compose.yml
- Dockerfile
- get-version.sh
- goetz_tool.sh
- start-teamspeak3.sh

Den Ordner "M300-Services\docker\LB02\docker\teamspeak" müssen wir kopieren.
Den Speicherort können Sie eigentlich selber wählen, ausser sie laden das ganze Repository herunter. Bei den Aufgaben müssen Sie dann vielleicht auf die Pfade achten, diese könnten dan vielleicht nicht mehr stimmen. Ich gehe immer vom teamspeak Ordner aus!!!!

## Installations Ablauf
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
cd /vagrant
```
5. Starten von goetz-tool.sh
```
./goetz-tool.sh
```
6. Nun Schritt eins bis 2 starten (3. optional)
![Image](bilder/goetztool.png)
Schritt 1. Buildet das Image mit unserem Dockerfile
Schritt 2. Startet das Docker-Compose File aus
Schritt 3. Zeig uns das Log an falls nötig

Mit diesem Tool kann man das Image gerade Builden und starten, ohne etwas einzugeben.

Hier zeige ich noch, wie man dies Manuell macht:

1. Nun bilden wir einen Image für unsere Dienste (dies aus dem Grund, dass wir nacher mit Doker-Compose arbeiten können)
```
cd /vagrant
```
```
docker build -t tslb02 .
```
Nun führen wir entweder das Dockerfile aus mit den nötigen Parameter (2.) oder wir führen das Docker-Compose file aus in dem die Parameter enthalten sind (3.)
2. Dockerfile ausführen damit wir dies in userem Image haben
```
docker run -d -e TS3SERVER_LICENSE=accept -p 9987:9987/udp -p 10011:10011 -p 30033:30033 --name=ts3-server tslb02
```
3. Oder wir führen unser Dienst aus per Docker-Compose. In diesem File sind alle nötigen Parameter vorhanden
```
docker-compose up -d
```

## Testing
Sobald die Installation erfolgreicht durchgelaufen ist, können wir das ganze testen. Dies wir per TeamSpeak3 Client auf einem Client getestet. Dafür muss man TeamSpeak3 Installieren.

1. TeamSpeak3 Starten

![Image](bilder/teamspeak.png)

2. Verbindung starten per localhost

![Image](bilder/teamspeak2.png)

![Image](bilder/teamspeak3.png)

So, wenn nun dieses Feld kommt mit den Berechtigungen, war die Verbindung erfolgreich. Hier muss man nurnoch den berechtigungsschlüssel eingeben falls man Administrator ist. Falls man diesen nicht hat, kann man einfach auf Abbrechen und man ist mit dem TeamSpeak Server verbunden.

![Image](bilder/teamspeak4.png)
