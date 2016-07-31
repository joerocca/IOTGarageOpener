import socket
import json
from functions import *

UDP_IP = "192.168.25.28"
UDP_PORT = 10000

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))


try:
        while True:
                data, addr = sock.recvfrom(1024) # buffer size is 1024 bytes
                jsonObject = json.loads(data)
                print "Received data from {0}: {1}".format(addr, jsonObject["signal"])

                if int(jsonObject["signal"]) == 1:
                        print "On Signal"
                        ipOfSender = addr[0]
                        portOfSender = addr[1]
                        sendMessage(sock , ipOfSender, portOfSender)
                        toggleGarageDoor()
                else:
                        print "Off Signal"


except KeyboardInterrupt:
        GPIO.cleanup()
