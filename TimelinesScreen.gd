extends CanvasLayer


# Declare member variables here. Examples:
var lines

signal newLineSig
signal endGameSig


#Gets the score from main after being initialized first, stops querying once it has a score
func _ready():
	connect("newLineSig", get_tree().get_root().get_node("main"), "randomize_playspace")
	connect("endGameSig", get_tree().get_root().get_node("main"), "gameOver")
	lines = get_tree().get_root().get_node("main").lines
	$numResets.text = "TIMELINE #" + str(lines) + " TERMINATED."
	pause_mode = PAUSE_MODE_PROCESS

#closes the game
func _on_quitBtn_pressed():
	emit_signal("endGameSig")


func _on_replayBtn_pressed():
	get_tree().paused =  false
	emit_signal("newLineSig")
	queue_free()
