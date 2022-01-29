extends Node2D

signal level_won

func _on_Area2D_area_entered(area):
	emit_signal("level_won")
