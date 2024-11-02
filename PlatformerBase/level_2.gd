extends Node2D

@export var score : int
@export var level_start_pos: Node2D
@onready var portal = $Portal
@onready var portalZone = $Portal/CollisionShape2D
var has_key:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	has_key = false
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_key == false:
		portal.visible = false
		portalZone.disabled = true
	elif has_key == true:
		portalZone.disabled = false
		portal.visible = true



	


func _on_key_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		has_key = true 
		$Key.queue_free()
