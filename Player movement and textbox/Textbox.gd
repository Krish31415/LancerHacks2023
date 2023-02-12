extends CanvasLayer

const CHAR_READ_RATE = 0.2

onready var textbox_container = $TextboxContainer
onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label2

func _ready():
	queue_text("The REALM has forever been under the tyranny of BALTHAZAR BEELZEBUB...")
	queue_text("But legend tells of a HERO!")
	queue_text("A HERO who would defeat BALTHAZAR, and restore ORDER...")
	queue_text("Welcome, HERO! Your quest is to defeat BALTHAZAR BEELZEBUB!")
	queue_text("Use the WASD or arrow keys to move.")
	
enum State {
	READY,
	READING,
	FINISHED
}

var currentstate = State.READY
var text_queue = []

func queue_text(next_text):
	text_queue.push_back(next_text)
	

func _process(delta):
	match currentstate:
		State.READY:
			if !text_queue.empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.percent_visible = 0.0
				$Tween.stop_all()
				end_symbol.text = "V"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				textbox_container.hide()
	
func hidescript():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	textbox_container.show()
	
func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	change_state(State.READING)
	show_textbox()
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func change_state(next_state):
	currentstate = next_state
	match currentstate:
		State.READY:
			pass
		State.READING:
			pass
		State.FINISHED:
			pass


func _on_Tween_tween_completed(object, key):
	end_symbol.text = "V"
	change_state(State.FINISHED)
