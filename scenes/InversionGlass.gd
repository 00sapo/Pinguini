extends Node2D

signal apply_inversion

func _on_Area2D_area_entered(area):
	emit_signal("apply_inversion")
