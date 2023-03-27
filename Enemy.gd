extends KinematicBody2D

var velocity = Vector2()
const GRAVITY = 10
var speed = 100
export var direction = -1
export var detects_cliffs = true
var is_object = false
var FRICTION = 1

func _ready():
	$AnimatedSprite.flip_h = direction > 0
	$FloorDetector.position.x = $Enemybox.shape.get_extents().x * direction
	$FloorDetector.enabled = detects_cliffs
	
func _physics_process(_delta):
	if !is_object:
		velocity.y += GRAVITY
		velocity.x = speed * direction
		velocity = move_and_slide(velocity, Vector2.UP)
		if is_on_wall() or (not $FloorDetector.is_colliding() and detects_cliffs and is_on_floor()):
			direction *= -1
			$AnimatedSprite.flip_h = direction > 0
			$FloorDetector.position.x = $Enemybox.shape.get_extents().x * direction
		if detects_cliffs:
			modulate = Color(0,1,1,1)
	else:
		velocity.y += GRAVITY
		FRICTION = 40 if is_on_floor() else 1
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		velocity = move_and_slide(velocity, Vector2.UP)
	
#func _process(delta):
#	if !is_object:
#		velocity.x = speed * direction
#		if is_on_wall() or (not $FloorDetector.is_colliding() and detects_cliffs and is_on_floor()):
#			direction *= -1
#			$AnimatedSprite.flip_h = direction > 0
#			$FloorDetector.position.x = $Hurtbox.shape.get_extents().x * direction
#		if detects_cliffs:
#			modulate = Color(0,1,1,1)
#	else: 
#		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
#
#func _physics_process(delta):
#	velocity.y += move_toward(velocity.y, 500, GRAVITY)
#	move_and_slide(velocity, Vector2.UP)


func _on_Hitbox_body_entered(body):
	$DeathSound.play()
	
	body.bounce()
	$AnimatedSprite.play("Dead")	
	speed = 0
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
#	if body.dash_down:
#		velocity.x = 0
#		$AnimatedSprite.play("Dead")
#		self.scale = Vector2(1, 1)
#		$Hitbox.set_collision_mask_bit(0, 0)
#		$Hitbox.set_collision_layer_bit(2, 0)
#		$Hurtbox.set_collision_mask_bit(0, 0)
#		set_collision_mask_bit(0, 0)
#		set_collision_layer_bit(3, 1)
#		body.bounce()
#		is_object = true


func flip_anim(value):
	$AnimatedSprite.flip_h = value
	
func thrown(initial_velocity):
	velocity.y = 0
	velocity.x = initial_velocity + 400 if $AnimatedSprite.flip_h else initial_velocity-400


func _on_Hurtbox_body_entered(body):
	body.die()
