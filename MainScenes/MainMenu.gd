extends Node2D

signal change_scene
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var _HowToPlayScreen= preload("res://Gui/HowToPlaySceen.tscn")
var have_activated = false
var out_of_screen_pos = Vector2(0,-400)
var target_position = Vector2.ZERO
onready var victoryBoxes := [$DefeatBox, $VictoryBox, $DemorializeBox, $ReconcileBox]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	position = lerp(position, target_position, 0.05)
	
	if(abs(position.y - target_position.y) <= 1):
			activate_victory_conditions()
			$HowToPlay.lock(false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activate_victory_conditions():
	for i in range(0, len(victoryBoxes)):
		if(GlobalSettings.victoriesAcheived[i]):
			victoryBoxes[i].activate()


func _on_PlayButton_choice_selected(choice_number):
	emit_signal("change_scene")


func _on_HowToPlay_choice_selected(choice_number):
	var How_to_play_sceen = _HowToPlayScreen.instance()
	$Display.add_child(How_to_play_sceen)
	$HowToPlay.activate()
	
func cleanup():
	queue_free()
