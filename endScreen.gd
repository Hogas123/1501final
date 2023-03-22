extends CanvasLayer


# Declare member variables here. Examples:
var score


#Gets the score from main after being initialized first, stops querying once it has a score
func _ready():
	score = get_tree().get_root().get_node("main").score
	$score.text = "FINAL SCORE: " + str(score)

#closes the game
func _on_Button_pressed():
	get_tree().quit()
