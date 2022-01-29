extends Control

# to be moved in the puzzle level
# --> platform should trigger this event with an id saved in editor
# --> same id of "saywhat"
signal next_story_block(key_id)

onready var text_panel = get_node("./panel/text_interface_engine")
onready var dialogue_resource = preload("res://assets/esempio.tres")

signal move_left
signal move_right
signal move_ahead
signal move_back

var COMMANDS = [
	["left", "move_left"], 
	["right", "move_right"],
	["ahead", "move_ahead"],
	["back", "move_back"]
]
	
func show_saywhat_node(id: String) -> void:
	# Given an ID, let the dialogue manager find the next line that we should show
	var line_intro = ""
	var line_outro = ""
	while id != "end":
		var line = yield(DialogueManager.get_next_dialogue_line(id, dialogue_resource), "completed")
		if line != null:
			text_panel.set_state(text_panel.STATE_OUTPUT)
			if line.character == "Storia":
				line_intro = "\n*"
				line_outro = "*\n"
			else:
				line_intro = "%-10s" % (line.character + ": ")
				line_outro = ""
			text_panel.buff_text(line_intro + line.dialogue + line_outro + "\n", 0.05)
			id = line.next_id
	wait_user_input()

func wait_user_input():
	text_panel.buff_text("\nGive a hint to Camilla:\n>>> ")
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
	show_saywhat_node("A First Node")
	
	# connect the incoming signals
	self.connect("next_story_block", self, "handle_new_story_id")
	pass
	
func handle_new_story_id(id):
	print("received key node: ", id)
	show_saywhat_node(id)
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_right"):
		var next_id = "Un altro nodo"
		emit_signal("next_story_block", next_id)

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
	text_panel.add_newline()
	var found = false
	for command in COMMANDS:
		if check_command(s, command[0]):
			found = true
			emit_signal(command[1])
	if not found:
		text_panel.buff_text("Unknown Command!\n", 0.01)
		wait_user_input()

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
	print("awaiting...")
