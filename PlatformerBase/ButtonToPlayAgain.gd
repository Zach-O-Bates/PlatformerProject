extends Button
var scene = ("res://level_2.tscn")

func _on_pressed() -> void:
	get_tree().change_scene_to_file(scene)



func _on_check_button_pressed() -> void:
	scene = ("res://level1.tscn")
