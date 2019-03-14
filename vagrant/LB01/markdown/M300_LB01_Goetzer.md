# LB01 von Leandro Götzer

## Auftrag
Unser Auftrag ist es, eine VM automatisiert aufzusetzten mit einem Vagrant File.
Dazu müssen wir Services aussuchen die wir installieren und konfigurieren mitels Vagrant File.

### Meine Idee für die LB01
Ich will zwei Server Aufsetzten.
Als erster Server dachte ich mir mache ich einen TeamSpeak Server.
Da ich TeamSpeak kenne, finde ich dies eine gute Idee.
Zudem will ich einen zweiten Server noch installieren.
Dabei dachte ich mir, dass ich mein TeamSpeak Server auf einer Webseite veröffentliche.
Dazu installiere ich einen Apache2 Server mit einer Webseite in der Infos von unserem TeamSpeak Server vorhanden sind.

### Informationen
[1]: https://docs.google.com/document/d/1M-aswL3k4uI-_MYO8RLX7ExAFEzVJkUoqjAOLj9gtyY/edit
[2]: https://guides.github.com/features/mastering-markdown/
[3]: https://bscw.tbz.ch/bscw/bscw.cgi/25833849
[4]: https://github.com/ask-yo-girl-about-me/M300-Services.git
[5]: https://wiki.ubuntuusers.de/TeamSpeak-Server/
[6]: https://wiki.ubuntuusers.de/Apache2/

Alle Unterlagen befinden sich im [BSCW-M300][3] Folder. Noch mehr Informationen finden sie im [Lernjournal][1] vom M300.
Dieses Dokument wurde mit [Markdown][2] geschrieben

### Nützliche Links
* [TBZ][1]
* [Mastring Markdown][2]
* [BSCW][3]
* [Mein Repository][4]
* [TeamSpeak Installation][5]
* [Apache2][6]

##Vorbereitung
---
Zuerst suchte ich mir meine Dienste aus die ich per Vagrant installieren will heraus.
Meine Idee war es einen Teamspeak Server und dazu einen Überwachungsserver zu installieren.
Ich Installierte beide Server zuerst manuell in Virtuallbox, um zu schauen was man alles machen kann und ich weiss das es läuft.
Dan fand ich heraus, dass der Überwachungsserver zu schwierig im Vagrant wird, Darum wählte ich als zweiten Server einen Apache2 Server in dem Infos von unserem TeamSpeak Server enthalten sind.

Als Vorbereitung oder absicherung installierte ich den TeamSpeak und den Apache Server einmal manuell. Um zu sehen welche befehle ich alles brauche und auf was ich alles achten muss.

##Installation
---
Grundsätzlivch machten ich die Installation nach der Seite Wiki.Ubuntuusers.de.

Aber es gab einige Stolpersteine:
 * Netzwerkeinstellungen damit man von einem anderen Gerät darauf zugreiffen kann.
 * Neustarten der VM wären dem ausführen der VM
 * Updaten der Server

###konfigurieren der VM (TeamSpeak)


###Installieren von TeamSpeak Server

##Testing
---
-
