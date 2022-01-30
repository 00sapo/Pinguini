extends Node2D

signal out_of_bounds

func _ready():
	var screen_size = get_viewport_rect().size
	var epsilon_size = 10
	var vertical_size = Vector2(epsilon_size, screen_size.y)
	var horizontal_size = Vector2(screen_size.x, epsilon_size)
	
	
	$LeftBound.position = Vector2(0, 0)
	$LeftBound.init(vertical_size)
	
	$RightBound.position = Vector2(0.65 * screen_size.x, 0)
	$RightBound.init(vertical_size)
	
	$TopBound.position = Vector2(0, 0)
	$TopBound.init(horizontal_size)
	
	$BottomBound.position = Vector2(0, screen_size.y)
	$BottomBound.init(horizontal_size)

func _on_Area2D_area_entered(area):
	emit_signal("out_of_bounds")
