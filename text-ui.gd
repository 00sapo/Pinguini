extends Control

onready var text_panel = get_node("./panel/text_interface_engine")
onready var dialogue_resource = preload("res://assets/camilla.tres")

signal move_left
signal move_right
signal move_down
signal move_up

var COMMANDS = [
	["left", "move_left"], 
	["right", "move_right"],
	["down", "move_down"],
	["up", "move_up"]
]
	
func show_saywhat_node(id: String) -> void:
	# Given an ID, let the dialogue manager find the next line that we should show
	text_panel.clear_buffer()
	var line_intro = ""
	var line_outro = ""
	while id != "end":
		var line = yield(DialogueManager.get_next_dialogue_line(id, dialogue_resource), "completed")
		if line != null:
			if line.character == "Narrator":
				line_intro = "\n*"
				line_outro = "*\n\n"
			else:
				line_intro = "%-8s" % (line.character + ": ")
				line_outro = "\n"
			text_panel.set_state(text_panel.STATE_OUTPUT)
			# text_panel.buff_text(line_intro + line.dialogue + line_outro) 
			text_panel.buff_text(line_intro + line.dialogue + line_outro, 0.075) 
			id = line.next_id
	_wait_user_input()

func _wait_user_input():
	text_panel.set_state(text_panel.STATE_OUTPUT)
	text_panel.buff_text("\nGive a hint to Camilla >>> ")
	text_panel.buff_input()

func _ready():
	# setupp GodotTie
	
	text_panel.connect("input_enter", self, "_on_input_enter")
	text_panel.connect("buff_end", self, "_on_buff_end")
	text_panel.connect("state_change", self, "_on_state_change")
	text_panel.connect("enter_break", self, "_on_enter_break")
	text_panel.connect("resume_break", self, "_on_resume_break")
	text_panel.connect("tag_buff", self, "_on_tag_buff")
	
	text_panel.reset()
	text_panel.set_color(Color(0.9,0.9,0.9))
	
	# show intro
	show_saywhat_node("Intro")

	pass

func check_command(s, command):
	if command in s.to_lower():
		return true
	else:
		return false
	
func _on_node_end():
	text_panel.buff_input()

func _on_input_enter(s):
	print("Input Enter ",s)
	
	text_panel.add_newline()
	var found = false
	for command in COMMANDS:
		if check_command(s, command[0]):
			found = true
			emit_signal(command[1])	
	if not found:
		text_panel.buff_text("Unknown Command!", 0.01)
		_wait_user_input()

func _on_buff_end():
	print("Buff End")
	pass

func _on_state_change(i):
	print("New state: ", i)
	pass

func _on_enter_break():
	print("Enter Break")
	pass

func _on_resume_break():
	print("Resume Break")
	pass

func _on_tag_buff(s):
	print("Tag Buff ",s)
	pass

func _on_level_awaiting_console_input():
	_wait_user_input()
	
func _on_level_ask_saywhat_node(id):
	print("asking new node: " + id)
	show_saywhat_node(id)
