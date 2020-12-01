extends Area2D


export var speed = 500


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	velocity.y -= 1
	velocity = velocity.normalized() * speed
	position += velocity * delta


func _on_Laser_body_entered(body):
	if body.has_method("mob_destroy"):
		body.mob_destroy()
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
