extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var _countdown = $Countdown
onready var _everyTenSeconds = $EveryTenSeconds
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
	_dialogManager.testChoice()
	_swordManager._reset()
	resolve_round()
	pass # Replace with function body.

func resolve_round():
	_swordManager.resolve_sword_choices(duelist1_sword_choice, duelist2_sword_choice)
	#get choices
	#play animations and dialogs
	#update values
	#reset
	pass


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
