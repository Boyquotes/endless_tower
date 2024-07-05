extends AudioStreamPlayer

const level_music = preload("res://sfx/music/591037__kbrecordzz__dungeon-ambience-piano.mp3")

func _play_music(music: AudioStream, volume = -15):
	@warning_ignore("standalone_expression", "standalone_expression", "standalone_expression")
	autoplay
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()
	
func play_music_level():
	@warning_ignore("standalone_expression", "standalone_expression")
	autoplay
	_play_music(level_music)
	
