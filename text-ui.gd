extends Control

signal node_ended

# to be moved in the puzzle level
# --> platform should trigger this event with an id saved in editor
# --> same id of "saywhat"
signal next_story_block(key_id)

onready var test_panel = get_node("./panel/text_interface_engine")

## not used anymore
#func print_text():
#	test_panel.reset()
#	test_panel.set_color(Color(1,1,1))
#	# Schedule an Input in the buffer, after all
#	# the text before it is displayed
#	test_panel.buff_text("Hey there!! What's your name?\n", 0.01)
#	test_panel.buff_input()
#	test_panel.set_state(test_panel.STATE_OUTPUT)
	
func show_node(id: String, resource: DialogueResource) -> void:
	# Given an ID, let the dialogue manager find the next line that we should show
	while id != "end":
		var line = yield(DialogueManager.get_next_dialogue_line(id, resource), "completed")
		if line != null:
			test_panel.set_state(test_panel.STATE_OUTPUT)
			test_panel.buff_text(line.character + ": " + line.dialogue + "\n", 0.05)
			# instead of recursion, put `next_id` in the game-state and restart
			id = line.next_id
	# emit_signal("node_ended")

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
	# DialogueManager.game_states = [GameState]
	# Show some dialogue right away
	var dialogue_resource = preload("res://assets/esempio.tres")
	var id = "A First Node" # this should be taken from the game-state...
	print("Loaded dialogue")
	
	yield(show_node(id, dialogue_resource), "completed")
	test_panel.buff_input()
	
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
	if check_command(s, "destra"):
		test_panel.buff_text("Vado a destra!", 0.01)
	else:
		test_panel.buff_text("comando sconosciuto!", 0.01)
	pass

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
