extends Node2D


func _on_go_pressed() -> void:
	get_tree().change_scene_to_file("res://Сцены/lobby.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_infoonas_pressed() -> void:
	get_tree().change_scene_to_file("res://Сцены/obigre.tscn")
