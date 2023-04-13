extends CanvasLayer


# Declare member variables here. Examples:
var score
var tLines
var playTime



#Gets the score from main after being initialized first, stops querying once it has a score
func _ready():
	score = get_tree().get_root().get_node("main").score
	tLines = get_tree().get_root().get_node("main").lines
	$score.text = str(score) + " PIZZAS DELIVERED"
	$tLines.text = str(tLines) + " TIMELINES VISITED"
	$gameOverMusic.play()
	pause_mode = PAUSE_MODE_PROCESS
	if tLines == 8:
		$Label.text = "NO MORE TIMELINES :("
#closes the game
func _on_quitBtn_pressed():
	get_tree().quit()
