extends Node2D

signal apply_inversion

func _on_Area2D_area_entered(area):
	$AnimatedSprite.play("hit")
	emit_signal("apply_inversion")
