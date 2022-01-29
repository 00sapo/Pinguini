extends Node2D

export var x_speed = 50
export var y_speed = 50

var x_velocity = 0
var y_velocity = 0

var state = "idle"

var initial_position

func _ready():
	initial_position = self.position
	
func restart():
	self.position = initial_position

func _process(delta):
	self.position.x += x_velocity * delta
	self.position.y += y_velocity * delta

func horizontal_movement(speed):
	state = "movement"
	y_velocity = 0
	x_velocity = speed
	
func vertical_movement(speed):
	state = "movement"
	x_velocity = 0
	y_velocity = speed

func move_left():
	horizontal_movement(-x_speed)
	
func move_right():
	horizontal_movement(x_speed)
	
func move_up():
	vertical_movement(-y_speed)
	
func move_down():
	vertical_movement(y_speed)


func _on_Area2D_area_entered(area):
	x_velocity = 0
	y_velocity = 0
	state = "idle"


func _on_Bounds_out_of_bounds():
	pass # Replace with function body.
