#!python

__author__ = "DMcG"
__date__ = "$Jun 23, 2015 10:27:29 AM$"

import socket
import time
import os

from io import BytesIO

SERVER = os.getenv("SERVER", "127.0.0.1")
SERVER_PORT = int(os.getenv("SERVER_PORT", 3001))
SERVER_DELAY = int(os.getenv("SERVER_DELAY", 60))
SERVER_OPTION = int(os.getenv("SERVER_OPTION", 0))

udpSocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
udpSocket.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

def send():
    xmls = [
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>",
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><note><to>Jani</to><from>Tove</from><heading>Reminder</heading><body>Roger</body></note>"
    ]
    

    i = 0
    
    while True:
        xml = xmls[i]
        i = (i + 1) % len(xmls)
        
        memoryStream = BytesIO()
        memoryStream.write(str.encode(xml))
        data = memoryStream.getvalue()
        
        udpSocket.sendto(data, (SERVER, SERVER_PORT))
        print("Sent {}. {} bytes".format(xml.__class__.__name__, len(data)))
        time.sleep(SERVER_DELAY)

send()
