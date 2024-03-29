#!python

__author__ = "DMcG"
__date__ = "$Jun 23, 2015 10:27:29 AM$"

import socket
import time
import os

from io import BytesIO

from opendis.DataOutputStream import DataOutputStream
from opendis.dis7 import EntityStatePdu
from opendis.RangeCoordinates import *

SERVER = os.getenv("SERVER", "127.0.0.1")
SERVER_PORT = int(os.getenv("SERVER_PORT", 3001))
SERVER_DELAY = int(os.getenv("SERVER_DELAY", 60))
SERVER_OPTION = int(os.getenv("SERVER_OPTION", 0))

udpSocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
udpSocket.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

gps = GPS() # conversion helper

def buildPDUEntities(option = 0):
    pdus = []
    
    if option == 0:
        pdu = EntityStatePdu()
        pdu.entityID.entityID = 42
        pdu.entityID.siteID = 17
        pdu.entityID.applicationID = 23
        pdu.marking.setString('Igor3d')

         # Entity in Monterey, CA, USA facing North, no roll or pitch
        montereyLocation = gps.llarpy2ecef(deg2rad(36.6),   # longitude (radians)
                                           deg2rad(-121.9), # latitude (radians)
                                           1,               # altitude (meters)
                                           0,               # roll (radians)
                                           0,               # pitch (radians)
                                           0                # yaw (radians)
                                           )

        pdu.entityLocation.x = montereyLocation[0]
        pdu.entityLocation.y = montereyLocation[1]
        pdu.entityLocation.z = montereyLocation[2]
        pdu.entityOrientation.psi = montereyLocation[3]
        pdu.entityOrientation.theta = montereyLocation[4]
        pdu.entityOrientation.phi = montereyLocation[5]
        pdus.append(pdu)
    
    elif option == 1:
        pdu = EntityStatePdu()
        pdu.entityID.entityID = 43
        pdu.entityID.siteID = 17
        pdu.entityID.applicationID = 24
        pdu.marking.setString('Igor3d-b')

         # Entity in Monterey, CA, USA facing North, no roll or pitch
        montereyLocation = gps.llarpy2ecef(deg2rad(36.7),   # longitude (radians)
                                           deg2rad(-121.6), # latitude (radians)
                                           1,               # altitude (meters)
                                           0,               # roll (radians)
                                           0,               # pitch (radians)
                                           0                # yaw (radians)
                                           )

        pdu.entityLocation.x = montereyLocation[0]
        pdu.entityLocation.y = montereyLocation[1]
        pdu.entityLocation.z = montereyLocation[2]
        pdu.entityOrientation.psi = montereyLocation[3]
        pdu.entityOrientation.theta = montereyLocation[4]
        pdu.entityOrientation.phi = montereyLocation[5]
        pdus.append(pdu)

        pdu = EntityStatePdu()
        pdu.entityID.entityID = 44
        pdu.entityID.siteID = 17
        pdu.entityID.applicationID = 24
        pdu.marking.setString('Igor3d-b')

         # Entity in Monterey, CA, USA facing North, no roll or pitch
        montereyLocation = gps.llarpy2ecef(deg2rad(36.8),   # longitude (radians)
                                           deg2rad(-121.6), # latitude (radians)
                                           6,               # altitude (meters)
                                           0,               # roll (radians)
                                           0,               # pitch (radians)
                                           0                # yaw (radians)
                                           )

        pdu.entityLocation.x = montereyLocation[0]
        pdu.entityLocation.y = montereyLocation[1]
        pdu.entityLocation.z = montereyLocation[2]
        pdu.entityOrientation.psi = montereyLocation[3]
        pdu.entityOrientation.theta = montereyLocation[4]
        pdu.entityOrientation.phi = montereyLocation[5]
        pdus.append(pdu)

    
    return pdus

def send():
    pdus = buildPDUEntities(SERVER_OPTION)
    i = 0
    
    while True:
        pdu = pdus[i]
        i = (i + 1) % len(pdus)
        
        memoryStream = BytesIO()
        outputStream = DataOutputStream(memoryStream)
        pdu.serialize(outputStream)
        data = memoryStream.getvalue()
        
        udpSocket.sendto(data, (SERVER, SERVER_PORT))
        print("Sent {}. {} bytes".format(pdu.__class__.__name__, len(data)))
        time.sleep(SERVER_DELAY)

send()
