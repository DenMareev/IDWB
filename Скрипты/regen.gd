extends Node2D


func _on_timer_timeout() -> void:
	if Global.hpatm < Global.maxhp and Global.fightisgoing == false:
		Global.hpatm += 10
