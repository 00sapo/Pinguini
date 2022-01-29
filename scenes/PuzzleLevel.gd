extends Node2D

func _ready():
	$Bounds.connect("out_of_bounds", $Player, "restart")
