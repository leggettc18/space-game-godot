extends RigidBody2D

signal screen_exited
signal hit

export var speed = 25
var can_move = false
var screen_size

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if can_move:
		velocity.y += 1
	velocity = velocity.normalized() * speed
	position += velocity * delta
	if position.y > screen_size.y:
		emit_signal("screen_exited")

func allow_movement():
	can_move = true

func mob_destroy():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("hit")
	get_parent().remove_child(self)
	queue_free()
