extends Node2D

signal awaiting_console_input

var normal_movements_rules
var inverted_movements_rules
var actual_movements_rules

var is_inverted

func _ready():
	$Bounds.connect("out_of_bounds", $Player, "restart")
	$Bounds.connect("out_of_bounds", self, "restart")
	$WinPlatform.connect("level_won", self, "on_win")
	
	self.normal_movements_rules = {
		"down": funcref($Player, "move_down"),
		"up": funcref($Player, "move_up"),
		"right": funcref($Player, "move_right"),
		"left": funcref($Player, "move_left")
	}
	
	self.inverted_movements_rules = {
		"down": funcref($Player, "move_up"),
		"up": funcref($Player, "move_down"),
		"right": funcref($Player, "move_left"),
		"left": funcref($Player, "move_right")
	}
	
	self.actual_movements_rules = inverted_movements_rules
	is_inverted = true
	
func on_win():
	print("level won!")
		
func restart():
	self.actual_movements_rules = inverted_movements_rules
	is_inverted = true
	
func _on_apply_inversion():
	if is_inverted:
		actual_movements_rules = normal_movements_rules
	else:
		actual_movements_rules = inverted_movements_rules
	is_inverted = not is_inverted


func _on_move_ahead():
	actual_movements_rules["up"].call_func()


func _on_move_back():
	actual_movements_rules["down"].call_func()


func _on_move_left():
	actual_movements_rules["left"].call_func()


func _on_move_right():
	actual_movements_rules["right"].call_func()


func _on_player_move_ended():
	emit_signal("awaiting_console_input")
