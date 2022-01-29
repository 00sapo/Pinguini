extends Node2D


var normal_movements_rules
var inverted_movements_rules
var actual_movements_rules

var is_inverted

func _ready():
	$Bounds.connect("out_of_bounds", $Player, "restart")
	$Bounds.connect("out_of_bounds", self, "restart")
	$WinPlatform.connect("level_won", self, "on_win")
	
	self.normal_movements_rules = {
		"ui_down": funcref($Player, "move_down"),
		"ui_up": funcref($Player, "move_up"),
		"ui_right": funcref($Player, "move_right"),
		"ui_left": funcref($Player, "move_left")
	}
	
	self.inverted_movements_rules = {
		"ui_down": funcref($Player, "move_up"),
		"ui_up": funcref($Player, "move_down"),
		"ui_right": funcref($Player, "move_left"),
		"ui_left": funcref($Player, "move_right")
	}
	
	self.actual_movements_rules = inverted_movements_rules
	is_inverted = true
	
func on_win():
	print("level won!")

func _unhandled_input(event):
	if $Player.state == "idle":
		handle_movement(event)
		
func restart():
	self.actual_movements_rules = inverted_movements_rules
	is_inverted = true
	
func handle_movement(event):
	if event.is_action_pressed("ui_down"):
		actual_movements_rules["ui_down"].call_func()
	if event.is_action_pressed("ui_up"):
		actual_movements_rules["ui_up"].call_func()
	if event.is_action_pressed("ui_right"):
		actual_movements_rules["ui_right"].call_func()
	if event.is_action_pressed("ui_left"):
		actual_movements_rules["ui_left"].call_func()


func _on_apply_inversion():
	if is_inverted:
		actual_movements_rules = normal_movements_rules
	else:
		actual_movements_rules = inverted_movements_rules
	is_inverted = not is_inverted
