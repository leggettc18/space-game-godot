extends CanvasLayer

signal start_game

var life_scene = load("res://Life.tscn")

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")

	$Message.text = "Space Game"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

func show_victory():
	show_message("Victory!")
	yield($MessageTimer, "timeout")
	
	$Message.text = "Space Game"
	$Message.show()
	
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func update_lives(lives, screen_size):
	get_tree().call_group("lives", "queue_free")
	for i in range(lives):
		var life = life_scene.instance()
		$LifeCounter.add_child(life)
		#$LifeCounter.position.x = screen_size.x - (i * life.size.x)

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()
