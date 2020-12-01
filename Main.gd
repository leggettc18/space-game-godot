extends Node

var mob_scene = load("res://Mob.tscn")
export (PackedScene) var Laser
var lives
var score
var game_running = false
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		if get_tree().get_nodes_in_group("mobs").size() == 0:
			$HUD.show_victory()
			game_running = false
			$Player/CollisionShape2D.set_deferred("disabled", true)
			$Player.hide()
			get_tree().call_group("mobs", "queue_free")


func _on_Player_hit():
	lives -= 1
	$HUD.update_lives(lives, screen_size)
	if lives <= 0:
		game_over()

func game_over():
	$Player/CollisionShape2D.set_deferred("disabled", true)
	$Player.hide()
	get_tree().call_group("mobs", "queue_free")
	$HUD.show_game_over()
	game_running = false

func new_game():
	score = 0
	$HUD.update_score(score)
	lives = 3
	$HUD.update_lives(lives, screen_size)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	spawn_enemies()
	$HUD.show_message("Get Ready")
	game_running = true


func spawn_enemies():
	var MONSTER_TOTAL = 5
	var MONSTER_WIDTH = MONSTER_TOTAL * 80
	var STARTX = ($Player.screen_size.x - MONSTER_WIDTH) / 2 + (80/2)
	var STOPX = STARTX + MONSTER_WIDTH
	
	for x in range(STARTX, STOPX, 80):
		for y in range(50, 60*5 + 50, 60):
			var mob = mob_scene.instance()
			mob.position.x = x
			mob.position.y = y
			add_child(mob)
			mob.connect("screen_exited", self, "_on_Mob_screen_exited")
			mob.connect("hit", self, "_on_Mob_hit")

func _on_StartTimer_timeout():
	get_tree().call_group("mobs", "allow_movement")

func _on_Mob_screen_exited():
	game_over()

func _on_Mob_hit():
	score += 100
	$HUD.update_score(score)

func _on_Player_fire():
	var laser = Laser.instance()
	laser.position = $Player.position
	add_child(laser)
