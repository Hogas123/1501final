extends CanvasLayer


# Declare member variables here. Examples:
var score

signal resetSig


#Gets the score from main after being initialized first, stops querying once it has a score
func _ready():
	connect("resetSig", get_tree().get_root().get_node("main"), "reset_game")
	score = get_tree().get_root().get_node("main").score
	$score.text = "FINAL SCORE: " + str(score)

#closes the game
func _on_quitBtn_pressed():
	get_tree().quit()


func _on_replayBtn_pressed():
	emit_signal("resetSig")
