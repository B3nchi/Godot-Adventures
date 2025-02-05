extends CharacterBody2D

var speed = 0.5
var player_chase = false
var player = null

var health = 100
var player_inattack_range = false
var enemy_damage = true

func _physics_process(delta):
	deal_with_damage()
	update_health()
	
	if player_chase:
		var tmp_pos = position.direction_to(player.position)
		position = position + (tmp_pos*speed)
		$AnimatedSprite2D.play("side_walk")
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
	move_and_collide(Vector2(0,0))

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func enemy():
	pass

func _on_enemy_1_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_range = true
	
func _on_enemy_1_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_range = false
		
func deal_with_damage():
	if player_inattack_range and global.player_current_attack == true:
		if enemy_damage == true:
			health = health - 20
			$take_damage_cooldown.start()
			enemy_damage = false
			print("goblin health = ", health)
			if health <= 0:
				self.queue_free()


func _on_take_damage_cooldown_timeout() -> void:
	enemy_damage = true


func update_health():
	var healthbar = $Enemy_1_health
	healthbar.value = health
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
		
func _on_regen_timer_timeout() -> void:
	if health < 100:
		health = health + 10
		if health > 100:
			health = 100
	if health == 0:
		health = 0
