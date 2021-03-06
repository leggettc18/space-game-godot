extends Area2D

signal hit
signal fire

export var speed = 300
var screen_size
var lives = 3
var can_fire = true

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2() # The player's movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if Input.is_action_pressed("ui_select"):
		if can_fire:
			emit_signal("fire")
			can_fire = false
			$LaserCooldown.start()



func _on_Player_body_entered(body):
	lives -= 1
	emit_signal("hit")
	if body.has_method("mob_destroy"):
		body.mob_destroy()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_LaserCooldown_timeout():
	can_fire = true
