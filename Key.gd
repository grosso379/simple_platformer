extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	print(body)
	$CollectSound.play()
	body.grab_key()
	hide()
	yield(get_tree().create_timer(0.4), "timeout")
	queue_free()
