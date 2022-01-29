extends Node2D


var normal_movements_rules
var inverted_movements_rules
var actual_movements_rules

func _ready():
	$Bounds.connect("out_of_bounds", $Player, "restart")
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
	
func on_win():
	print("level won!")

func _unhandled_input(event):
	if $Player.state == "idle":
		handle_movement(event)

	
func handle_movement(event):
	if event.is_action_pressed("ui_down"):
		actual_movements_rules["ui_down"].call_func()
	if event.is_action_pressed("ui_up"):
		actual_movements_rules["ui_up"].call_func()
	if event.is_action_pressed("ui_right"):
		actual_movements_rules["ui_right"].call_func()
	if event.is_action_pressed("ui_left"):
		actual_movements_rules["ui_left"].call_func()
