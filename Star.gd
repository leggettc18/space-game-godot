extends AnimatedSprite

export var speed = 0

func _ready():
	pass

func _process(delta):
	var velocity = Vector2()
	velocity.y += 1
	velocity = velocity.normalized() * speed
	position += velocity * delta


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
