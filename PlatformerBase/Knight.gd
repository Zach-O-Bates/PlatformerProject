extends CharacterBody2D
@onready var animation = $AnimatedSprite2D
@onready var label = $Label
var dir = -1


func _ready():
	animation.play("Idle")
	flip_sprite(dir)
		
func flip_sprite(dir):
	if dir == 1:
		animation.flip_h = false
	if dir == -1:
		animation.flip_h = true 


func _on_area_2d_area_entered(area: Area2D) -> void:
	label.visible = true 
