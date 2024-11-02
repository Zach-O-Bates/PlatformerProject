extends Area2D
@onready var animation = $AnimatedSprite2D

func _ready():
	animation.play("portalThing")

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	get_tree().change_scene_to_file("res://Menu.tscn")
