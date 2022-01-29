extends Node2D

func _ready():
	pass

func init(bound_size):
	$Area2D/CollisionShape2D.shape.extents = bound_size
