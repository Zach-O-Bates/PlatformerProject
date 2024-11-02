extends CharacterBody2D

@onready var sound = $AudioStreamPlayer
@onready var hitZone = $PlayerHitZone
@onready var animation = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -400
var health = 3
var health_min = 0
var current_attack: bool
var player_damage = 1
var dead = false
var taking_damage = false
var can_take_damage: bool


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Global.playerBody = self
	current_attack = false 
	player_damage = Global.playerDamage
	
	
		

func _physics_process(delta):
	
	Global.playerHitZone = $PlayerHitZone
	Global.playerHitbox = $playerHitbox
	
	if health == 3:
		$"Heart/1".visible = true
		$"Heart/2".visible = true
		$"Heart/3".visible = true
	elif health == 2:
		$"Heart/1".visible = false
		$"Heart/2".visible = true
		$"Heart/3".visible = true
	elif health == 1:
		$"Heart/1".visible = false
		$"Heart/2".visible = false
		$"Heart/3".visible = true
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if position.y > 600:
		handle_death()
		
	if !dead:
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		var direction = Input.get_axis("Backward", "Forward")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
		if !current_attack:
			if Input.is_action_just_pressed("Attack"):
				current_attack = true
				animation.play("Attack")
				sound.play()
				handle_damage()
			
		handle_movement_anim(direction)
	move_and_slide()

	
func handle_movement_anim(dir):
	if !velocity and !current_attack:
		animation.play("Idle")
	if velocity and !current_attack:
		animation.play("Run")
		flip_sprite(dir)
	
func flip_sprite(dir):
	if dir == 1:
		animation.flip_h = false
		hitZone.scale.x = 1
	if dir == -1:
		animation.flip_h = true 
		hitZone.scale.x = -1
			
func handle_damage():
	var hitzone = hitZone.get_node("CollisionShape2D")
	hitzone.disabled = false
	await get_tree().create_timer(0.5).timeout
	hitzone.disabled = true
	
func take_damage(damage):
	animation.play("hurt")
	await get_tree().create_timer(0.5).timeout
	  
	if health > 0:
		health -= damage
		if health <= 0:
			$"Heart/3".visible = false
			dead = true
			handle_death()
		

func handle_death():
	animation.play("death")
	await get_tree().create_timer(.8).timeout
	queue_free()	
	get_tree().change_scene_to_file("res://GameOver.tscn")

func _on_animated_sprite_2d_animation_finished() -> void:
	current_attack = false


func _on_player_hitbox_area_entered(area: Area2D) -> void:
	var damage = Global.orcDamage
	if area == Global.orcHitZone:
		take_damage(damage)
		
func addHealth():
	print("ok")
	animation.play("Drink")
	await get_tree().create_timer(0.8).timeout
	health += 1
	print(health)
	
