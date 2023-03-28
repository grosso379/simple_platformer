extends KinematicBody2D

signal game_over
signal grab_key
signal collect_coin

const MAX_SPEED = 300

#Forces
const GRAVITY = 950
const ACCELERATION = 1000
const FRICTION = 900
const JUMP = 600

var velocity = Vector2.ZERO
onready var anim = $AnimatedSprite
var grabbed_enemy = null
var enemy_in_range = null
var enemy_y_shift = 35
var enemy_y_jump_shift = 0
var count = 0
var jumping = false
var dash_count = 1
var direction = 1
var dash_down = false
var lives = 3
var game_on = false
var coins = 0
var has_key = false
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("idle")

func undash():
	yield(get_tree().create_timer(0.1), "timeout")
	dash_down = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !game_on:
		return
	if is_on_floor():
		undash()
	
	# Handle grabbed enemy
	if grabbed_enemy != null:
		enemy_y_jump_shift = 55 if anim.animation == "jump" else 0
		if anim.flip_h:
			grabbed_enemy.position = Vector2(position[0] - 30  , position[1] + enemy_y_shift - enemy_y_jump_shift)
			grabbed_enemy.flip_anim(false)
		else:
			grabbed_enemy.position = Vector2(position[0] + 30  , position[1] + enemy_y_shift - enemy_y_jump_shift )
			grabbed_enemy.flip_anim(true)
	
	
	
	# Handle left/right movement and idle
	if Input.is_action_pressed("ui_right"):
		if velocity.x < 0:
			velocity.x = 0
		velocity.x = move_toward(velocity.x, MAX_SPEED, ACCELERATION * delta)
		anim.set_flip_h(false)
		if is_on_floor():
			anim.play("walk")
	elif Input.is_action_pressed("ui_left"):
		anim.set_flip_h(true)
		if is_on_floor():
			anim.play("walk")
		if velocity.x > 0:
			velocity.x = 0
		velocity.x = move_toward(velocity.x, -MAX_SPEED, ACCELERATION * delta)
	else:
		if is_on_floor():
			anim.play("idle")
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		else:
# warning-ignore:integer_division
			velocity.x = move_toward(velocity.x, 0, FRICTION / 4 * delta)			
	
	
	
	# Handle jump and dash
	if Input.is_action_just_pressed("ui_select"):
		if is_on_floor():
			dash_count = 1
			velocity.y = -JUMP
			anim.play("jump")
		elif dash_count > 0:
			direction = 1 if anim.flip_h else -1
# warning-ignore:integer_division
			velocity.y = -JUMP / 2
			velocity.x = move_toward(velocity.x, -direction * MAX_SPEED * 2, ACCELERATION * 4)
			dash_count = 0
			
	
	# Handle dash down
#	if Input.is_action_just_pressed("ui_down"):
#		if !is_on_floor():
#			velocity.y = JUMP * 1.5
#			dash_down = true
			
	
	
	# Handle enemy grab and throw
	if Input.is_action_just_pressed("ui_pick"):
		if grabbed_enemy == null:
			grabbed_enemy = enemy_in_range
		else:
			grabbed_enemy.thrown(velocity.x)
			grabbed_enemy = null
	
func bounce():
	velocity.y = -JUMP * 0.5
		

	
func _physics_process(delta):
	# gravity
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	


func _on_GrabRange_body_entered(body):
	enemy_in_range = body

func _on_GrabRange_body_exited(_body):
	enemy_in_range = null	
	
func die():
	$HurtSound.play()
	lives -= 1
	if lives == 2:
		$CanvasLayer/Life3.hide()
	elif lives == 1:
		$CanvasLayer/Life2.hide()
	elif lives == 0:
		$CanvasLayer/Life1.hide()
	position.x = 235
	position.y = 400
	if lives == 0:
		emit_signal("game_over")
		
func collect_coin():
	coins += 1
	emit_signal("collect_coin")
	
func grab_key():
	has_key = true
	emit_signal("grab_key")
		
