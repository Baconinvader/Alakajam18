extends Node

var current_path:String = ""

func play_sound(sound_name:String):
	var path:String = "res://assets/audio/%s.wav.import" % sound_name
	if current_path != path:
		current_path = path
		$player1.stream = load(path)
		$player1.stop()
	$player1.play()
