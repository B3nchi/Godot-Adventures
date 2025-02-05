extends CharacterBody2D

const SPEED = 100
var current_dir = "none"
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false

func _ready(): # ready function for player also allows the camera to adjust based on tilemap size
	$AnimatedSprite2D.play("front_idle")
	#var tilemap_rect = get_parent().get_node("TileMap").get_used_rect()
	#var tilemap_cell_size = get_parent().get_node("TileMap").tile_set.tile_size
	#$Camera.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	#$Camera.limit_right = tilemap_rect.end.x * tilemap_cell_size.x 
	#$Camera.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y
	#$Camera.limit_top = tilemap_rect.position.y * tilemap_cell_size.y

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	update_health()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("player has been killed")
		self.queue_free()
	
func player_movement(delta):
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_animation(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		play_animation(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		play_animation(1)
		velocity.y = SPEED
		velocity.x = 0
	elif Input.is_action_pressed("up"):
		current_dir = "up"
		play_animation(1)
		velocity.y = -SPEED
		velocity.x = 0
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	move_and_slide()

func play_animation(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	if dir == "right":
		anim.flip_h = false
		if movement ==  1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement ==  1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "up":
		anim.flip_h = true
		if movement ==  1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")
	if dir == "down":
		anim.flip_h = true
		if movement ==  1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")

func player():
	pass
	
func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 5
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)
		
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()
			
			
func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false

func update_health():
	var healthbar = $Health_bar
	healthbar.value = health
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout() -> void:
	if health < 100:
		health = health + 5
		if health > 100:
			health = 100
	if health == 0:
		health = 0
