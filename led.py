import RPi
import RPi.GPIO as GPIO
import time

led = 18

GPIO.setmode(RPi.GPIO.BCM)

GPIO.setup(led, GPIO.OUT)

for x in range(5):
    GPIO.output(led, True)
    time.sleep(2)
    GPIO.output(led, False)
    time.sleep(2)

GPIO.cleanup()