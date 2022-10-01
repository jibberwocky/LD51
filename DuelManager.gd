extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var _countdown = $Countdown
onready var _everyTenSeconds = $EveryTenSeconds
onready var _inBetweenTimer = $NotTenSeconds
onready var _dialogManager = $DialogManager
onready var _swordManager = $SwordManager

var duelist_healths = [GlobalSettings.MAX_DUELIST_HEALTH,GlobalSettings.MAX_DUELIST_HEALTH]

var duelist2_mood = Vector3(50.0, 50.0, 50.0)
var duelist1_sword_choice = 0
var duelist2_sword_choice = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	_everyTenSeconds.start()
	pass # Replace with function body.

func _process(delta):
	_countdown.value = _everyTenSeconds.time_left
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EveryTenSeconds_timeout():
	duelist1_sword_choice = _swordManager.actionChoice
	duelist2_sword_choice = randi()%3
	resolve_round()
	_inBetweenTimer.start()
	yield(_inBetweenTimer, "timeout")
	_everyTenSeconds.start()
	_dialogManager.testChoice() #should be reset
	_swordManager._reset()
	pass # Replace with function body.

func resolve_round():
	resolve_dialog_choices()
	_swordManager.resolve_sword_choices(duelist1_sword_choice, duelist2_sword_choice)
	#get choices
	#play animations and dialogs
	#update values
	#reset
	pass
	
func resolve_dialog_choices():
	var my_choice : int = _dialogManager.chosen_choice
	var mood_value = _dialogManager.choices[my_choice].mood_value
	if(duelist1_sword_choice == _dialogManager.choices[my_choice].predicted_move):
		mood_value *= 2
	update_oponent_mood(mood_value)
	for i in range (0, 3):
		if(mood_value[i] > 0):
			_swordManager._deulist2. emmit_mood(i, mood_value[i])
		
	
func update_oponent_mood(mood_value:Vector3):
	duelist2_mood+= mood_value
func _on_SwordManager_fightWon(winner):
	match winner:
		1:#duelist1
			_update_duelist_health(1, -1)
		2: #duelist2
			_update_duelist_health(0, -1)
		0: #both lose
			_update_duelist_health(1, -1)
			_update_duelist_health(0, -1)
	
func _update_duelist_health(duelist: int, change_to_health: int):
	duelist_healths[duelist] = duelist_healths[duelist] + change_to_health
	_swordManager.update_healthbar(duelist,duelist_healths[duelist])
