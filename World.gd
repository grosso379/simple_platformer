extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ENEMY = preload("Enemy.tscn")
const COIN = preload("Coin.tscn")
const KEY = preload("Key.tscn")
var player_won = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$WorldEnvironment.get_environment().set_dof_blur_near_enabled(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_KillPlane_body_entered(body):
	body.die()
	


func _on_New_Game_start_game():
	spawn_enemies()
	spwan_coins()
	spawn_key()
	$GameSound.play()
	$Player.game_on = true
	$Player.has_key = false
	$Player.lives = 3
	$Player.coins = 0
	$Player/CanvasLayer/CoinCount.text = "0"
	$Player/CanvasLayer/Key.hide()	
	$Player/CanvasLayer/Life1.show()
	$Player/CanvasLayer/Life2.show()
	$Player/CanvasLayer/Life3.show()
	$NewGameScreen.hide()
	$WorldEnvironment.get_environment().set_dof_blur_near_enabled(false)
	

func _on_Player_game_over():
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("coins", "queue_free")
	$Player.velocity.x = 0
	$Player.position.x = 235
	$Player.position.y = 400
	$Player/AnimatedSprite.play("idle")
	$Player.game_on = false
	$WorldEnvironment.get_environment().set_dof_blur_near_enabled(true)	
	if player_won:
		$GameOverScreen/Label.text = "Congrats! You Won!"
	else:
		$GameOverScreen/Label.text = "Oops! You lost!"
	$GameOverScreen.show()
	yield(get_tree().create_timer(3), "timeout")
	$GameOverScreen.hide()	
	player_won = false
	$NewGameScreen.show()


func spawn_enemies():
	var enemy1 = ENEMY.instance()
#	enemy1.position = Vector2(50, 400)
	enemy1.position = Vector2(1295, 180)
	add_child(enemy1)
	
	var enemy2 = ENEMY.instance()	
	enemy2.position = Vector2(2000, 400)
	add_child(enemy2)
	
	var enemy3 = ENEMY.instance()	
	enemy3.position = Vector2(2900, 400)
	add_child(enemy3)


func spwan_coins():
	var coin1 = COIN.instance()
	coin1.position = Vector2(3570, 280)
	add_child(coin1)
	
	var coin2 = COIN.instance()	
	coin2.position = Vector2(800, 200)
	add_child(coin2)
	
	var coin3 = COIN.instance()	
	coin3.position = Vector2(3700, 35)
	add_child(coin2)
	
func spawn_key():
	var key = KEY.instance()
	key.position = Vector2(3430, 520)
	add_child(key)

func _on_Player_collect_coin():
	$Player/CanvasLayer/CoinCount.text = str($Player.coins)
	


func _on_Player_grab_key():
	$Player/CanvasLayer/Key.show()


func _on_Doors_body_entered(body):
	if body.has_key:
		player_won = true
		_on_Player_game_over()
	else:
		$Player/CanvasLayer/Hints.show()
		yield(get_tree().create_timer(3), "timeout")
		$Player/CanvasLayer/Hints.hide()
		
		
