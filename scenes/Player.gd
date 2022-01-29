extends Node2D

export var x_speed = 50
export var y_speed = 50

var x_velocity = 0
var y_velocity = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(initial_position):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.x += x_velocity * delta
	self.position.y += y_velocity * delta
	print(self.position.x)

func _unhandled_input(event):
	if Input.is_action_pressed("ui_down"):
		move_down()
	if Input.is_action_pressed("ui_up"):
		move_up()
	if Input.is_action_pressed("ui_right"):
		move_right()
	if Input.is_action_pressed("ui_left"):
		move_left()
	

func horizontal_movement(speed):
	y_velocity = 0
	x_velocity = speed
	
func vertical_movement(speed):
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
