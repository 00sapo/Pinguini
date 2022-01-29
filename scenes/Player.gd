extends Node2D

export var x_speed = 50
export var y_speed = 50

var x_velocity = 0
var y_velocity = 0

var state = "idle"

func _ready():
	pass
	
func init(initial_position):
	pass

func _process(delta):
	self.position.x += x_velocity * delta
	self.position.y += y_velocity * delta
	print(self.position.x)

func _unhandled_input(event):
	if state == "idle":
		handle_movement(event)

	
func handle_movement(event):
	if event.is_action_pressed("ui_down"):
		move_down()
	if event.is_action_pressed("ui_up"):
		move_up()
	if event.is_action_pressed("ui_right"):
		move_right()
	if event.is_action_pressed("ui_left"):
		move_left()

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
