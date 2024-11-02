extends CharacterBody2D


class_name Orc



var speed = 30
var is_orc_chase: bool = false


var health = 2
var health_min = 0

var dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 1
var is_dealing_damage: bool = false
const gravity = 900

var dir: Vector2
var knockback = -50
var is_roaming: bool = true
var player = CharacterBody2D
var player_in_area = false



func _process(delta):
	if !is_on_floor():
		velocity.y += speed * delta
		velocity.x = 0
	player = Global.playerBody
	Global.orcDamage = damage_to_deal
	Global.orcHitZone = $DamageArea
	
	
	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if !dead:
		if !is_orc_chase:
			velocity += dir * speed * delta
		elif is_orc_chase and !taking_damage:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = abs (velocity.x) / velocity.x
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * knockback
			velocity.x = knockback_dir.x
		is_roaming = true
	elif dead:
		velocity.x = 0
			

func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("walk")
		if dir.x == -1:
			anim_sprite.flip_h = true
		elif dir.x == 1:
			anim_sprite.flip_h = false
	elif !dead and taking_damage and !is_dealing_damage:
		anim_sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		anim_sprite.play('death')
		await get_tree().create_timer(1.0).timeout
		death()
	elif !dead and is_dealing_damage:
		anim_sprite.play("attack")
		await get_tree().create_timer(1.0).timeout
	
		

	
func death():
	queue_free()

func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = choose([2.5, 1, 2.5])
	if !is_orc_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
	
func choose(array):
	array.shuffle()
	return array.front()
		
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= health_min:
		dead = true

func _on_damage_area_area_entered(area: Area2D) -> void:
	if area == Global.playerHitbox:
		await get_tree().create_timer(1.0).timeout
		is_dealing_damage = true
		await get_tree().create_timer(1.0).timeout
		is_dealing_damage = false


func _on_orc_hitbox_area_entered(area: Area2D) -> void:
	var damage = Global.playerDamage
	if area == Global.playerHitZone:
		take_damage(damage)


func _on_chase_zone_area_entered(area: Area2D) -> void:
	is_orc_chase = true
	speed = 50

func _on_chase_zone_area_exited(area: Area2D) -> void:
	is_orc_chase = false
	speed = 30
