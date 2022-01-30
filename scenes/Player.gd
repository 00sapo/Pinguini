extends Node2D

signal move_ended


export var bounce_off_factor = 20

export var x_speed = 50
export var y_speed = 50

var x_velocity = 0
var y_velocity = 0

var state = "idle"

var initial_position

func reset_character():
	x_velocity = 0
	y_velocity = 0
	state = "idle"
	$AnimatedSprite.play("default")

func _ready():
	initial_position = self.position
	
func restart():
	self.position = initial_position
	reset_character()

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
	if x_velocity != 0:
		self.position.x -= x_velocity/x_velocity * bounce_off_factor
	if y_velocity != 0:
		self.position.y -= y_velocity/y_velocity * bounce_off_factor 
	reset_character()
	emit_signal("move_ended")
