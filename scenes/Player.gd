extends Node2D

signal move_ended

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
	
	
func apply_movement():
	state = "movement"
	$AnimatedSprite.play("walk")

func horizontal_movement(speed):
	apply_movement()
	y_velocity = 0
	x_velocity = speed
	
func vertical_movement(speed):
	apply_movement()
	x_velocity = 0
	y_velocity = speed

func move_left():
	self.rotation_degrees = 90
	horizontal_movement(-x_speed)
	
func move_right():
	self.rotation_degrees = -90
	horizontal_movement(x_speed)
	
func move_up():
	self.rotation_degrees = 180
	vertical_movement(-y_speed)
	
func move_down():
	self.rotation_degrees = 0
	vertical_movement(y_speed)


func _on_Area2D_area_entered(area):
	##### WARNING! THIS IS A BAD WAY OF SOLVING THE PROBLEM! ######
	self.position.x -= int(x_velocity > 0) * 10 # x_velocity * delta
	self.position.y -= int(y_velocity > 0) * 10 # y_velocity * delta
	x_velocity = 0
	y_velocity = 0
	state = "idle"
	$AnimatedSprite.play("default")
	emit_signal("move_ended")


func _on_Bounds_out_of_bounds():
	pass # Replace with function body.
