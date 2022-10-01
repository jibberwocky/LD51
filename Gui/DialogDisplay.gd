extends NinePatchRect


var text := "text" setget set_text

func set_text(txt:String):
	_label.text = txt
	text = txt

const MOVE_HEIGHT = 3
const MOVE_SPEED = 0.2
const ANIMATE_SPEED = 0.05

export var base_frame := 2 setget set_base_frame
var base_pos : float
var target_pos : float
var base_height : float
var base_visiblity : float
var target_visibility : float = 1
var locked setget lock

onready var _button := $Button
onready var _label := $Label

# Called when the node enters the scene tree for the first time.
func _ready():
#	_button.margin_bottom = self.margin_bottom
#	_button.margin_top = self.margin_top
#	_button.margin_left = self.margin_left
#	_button.margin_right = self.margin_right	
#	_label.margin_bottom = self.margin_bottom - 6
#	_label.margin_top = self.margin_top +6
#	_label.margin_left = self.margin_left +6
#	_label.margin_right = self.margin_right -6
	self.locked = false
	base_pos = self.margin_top
	target_pos = base_pos
	base_height = self.margin_bottom - self.margin_top

func _process(delta):
	if(margin_top != target_pos):
		margin_top = lerp(margin_top, target_pos, 0.1)
		margin_bottom = lerp(margin_bottom, target_pos + base_height, MOVE_SPEED)
	if(modulate.a != target_visibility):
		modulate.a = lerp(modulate.a, target_visibility, ANIMATE_SPEED)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_base_frame(frame:int):
	base_frame = frame
	change_color(base_frame)

func change_color(frame:int)->void:
	print("changing color")
	region_rect.position.x = frame*36


func _on_Button_mouse_entered():
	if(locked): return
	target_pos = base_pos-MOVE_HEIGHT
	change_color(base_frame +1)
	pass # Replace with function body.


func _on_Button_mouse_exited():
	if(locked): return
	target_pos = base_pos
	change_color(base_frame)
	pass # Replace with function body.


func _on_Button_button_down():
	if(locked): return
	change_color(base_frame +2)
	

	pass # Replace with function body.

func lock(locking: bool):
	if(locking):
		print("locking button")
	locked = locking
	_button.disabled = locking
	
func vanish():
	target_pos = base_pos+MOVE_HEIGHT*5
	target_visibility = 0


func _on_Button_pressed():
	self.locked = true
	vanish()
