extends Control

# to be moved in the puzzle level
# --> platform should trigger this event with an id saved in editor
# --> same id of "saywhat"
signal next_story_block(key_id)

onready var test_panel = get_node("./panel/text_interface_engine")

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
	
func show_saywhat_node(id: String, resource: DialogueResource) -> void:
	# Given an ID, let the dialogue manager find the next line that we should show
	while id != "end":
		var line = yield(DialogueManager.get_next_dialogue_line(id, resource), "completed")
		if line != null:
			test_panel.set_state(test_panel.STATE_OUTPUT)
			test_panel.buff_text(line.character + ": " + line.dialogue + "\n", 0.05)
			id = line.next_id
	test_panel.buff_input()

func _ready():
	# setupp GodotTie
	test_panel.connect("input_enter", self, "_on_input_enter")
	test_panel.connect("buff_end", self, "_on_buff_end")
	test_panel.connect("state_change", self, "_on_state_change")
	test_panel.connect("enter_break", self, "_on_enter_break")
	test_panel.connect("resume_break", self, "_on_resume_break")
	test_panel.connect("tag_buff", self, "_on_tag_buff")
	
	test_panel.reset()
	test_panel.set_color(Color(1,1,1))
	
	#################################################
	# setup SayWhat
	var dialogue_resource = preload("res://assets/esempio.tres")
	print("Loaded dialogue")
	
	show_saywhat_node("A First Node", dialogue_resource)
	
	self.connect("next_story_block", self, "handle_new_story_id")
	pass
	
func handle_new_story_id(next_id):
	print("received key node: ", next_id)
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_right"):
		var next_id = "fake_id"
		emit_signal("next_story_block", next_id)

func check_command(s, command):
	if command in s.to_lower():
		return true
	else:
		return false
	
func _on_node_end():
	test_panel.buff_input()

func _on_input_enter(s):
	print("Input Enter ",s)
	
	test_panel.add_newline()
	var found = false
	for command in COMMANDS:
		if check_command(s, command[0]):
			found = true
			emit_signal(command[1])
	if not found:
		test_panel.buff_text("Unknown Command!", 0.01)

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
