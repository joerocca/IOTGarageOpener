import socket
import RPi.GPIO as GPIO
import time

LedPin = 7

GPIO.setmode(GPIO.BOARD)
GPIO.setup(LedPin, GPIO.OUT)
GPIO.output(LedPin, GPIO.HIGH)


def sendMessage(sock, ipAddress, port):
        MESSAGE = "Message for device."
        sock.sendto(MESSAGE, (ipAddress, port))

def toggleGarageDoor():
        GPIO.output(LedPin, GPIO.LOW)
        time.sleep(0.25)
        GPIO.output(LedPin, GPIO.HIGH)
