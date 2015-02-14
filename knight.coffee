# this is the first test of the bbone

b = require 'bonescript'
usbbase = '/sys/class/leds/beaglebone:green:usr'

high = b.HIGH
lo = b.LOW
out = b.OUTPUT

u0 = 'USR0'
u1 = 'USR1'
u2 = 'USR2'
u3 = 'USR3'

uArray = []
uArray.push u0
uArray.push u1
uArray.push u2
uArray.push u3

initMode = ->
	b.pinMode u0, out
	b.pinMode u1, out
	b.pinMode u2, out
	b.pinMode u3, out


setLED = (pinnum, onMode, cb, delay) ->
	setOff = ->
		b.digitalWrite uArray[pinnum], lo
	setOn = ->
		b.digitalWrite uArray[pinnum], high

	if not onMode
		setOff()
	else
		setOn()

	if cb
		setTimeout cb, delay
	return

cleanup = ->
	setLED 0, false
	setLED 1, false
	setLED 2, false
	setLED 3, false
	return


knight = ->
	delayTime = 100
	maxLedNum = 4
	maxInterations = 300
	count = 0
	hiLed = 3
	lowLed = 0
	currLed = 0
	currDirection = 1
	initMode()
	cleanup()

	worker = ->
		count += 1
		if count > maxInterations
			cleanup()
			return

		setLED currLed, false

		currLed += currDirection
		if currLed > hiLed
			currDirection = -1
			currLed = hiLed + currDirection
		else if currLed < lowLed
			currDirection = 1
			currLed = lowLed + currDirection

		setLED currLed, true, worker, delayTime
		return

	worker()
	return

knight()

