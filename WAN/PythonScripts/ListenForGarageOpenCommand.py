from pubnub import Pubnub

pubnub = Pubnub(
		    publish_key = "pub-c-abd756e6-262b-4229-95f2-29a20c1dff51",
		    subscribe_key = "sub-c-15636f2c-5621-11e6-aba3-0619f8945a4f")

channel = "garage"

def callback(message, channel):
	    print('[' + channel + ']: ' + str(message))

pubnub.subscribe(
		    channel,
		    callback = callback)


