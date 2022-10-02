extends Node2D

signal CompletedOutcome(outcome)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var _countdown = $Countdown
onready var _everyTenSeconds = $EveryTenSeconds
onready var _inBetweenTimer = $NotTenSeconds
onready var _dialogManager = $DialogManager
onready var _swordManager = $SwordManager
var outcomeOccured = false

var duelist_healths = [GlobalSettings.MAX_DUELIST_HEALTH,GlobalSettings.MAX_DUELIST_HEALTH]

var duelist2_mood = Vector3(0, 0, 0)
var duelist1_sword_choice = 0
var duelist2_sword_choice = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	duelist2_mood = Vector3(rand_range(-5,10),rand_range(-5,10), rand_range(-5,100))
	#$DialogDisplay.activate()
	duelist2_sword_choice =  _select_enemy_action()
	_everyTenSeconds.start()
	pass # Replace with function body.

func _process(delta):
	_countdown.value = _everyTenSeconds.time_left
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _select_enemy_action() -> int:
	var total_value = duelist2_mood.x + duelist2_mood.y + duelist2_mood.z + 30
	if(total_value <= 0):
		return randi() % int(3)
	var randRoll = randi() % int(total_value)
	for i in range(0,3):
		if randRoll < duelist2_mood[i] + 10: return i
		randRoll -= max(0,duelist2_mood[i]) + 10
	return randi() % 3
		
func _on_EveryTenSeconds_timeout():
	duelist1_sword_choice = _swordManager.actionChoice
	duelist2_sword_choice =  _select_enemy_action()
	resolve_round()
	_inBetweenTimer.start()
	yield(_inBetweenTimer, "timeout")
	if(outcomeOccured): return
	_everyTenSeconds.start()
	_dialogManager.next_choice(duelist2_mood) #should be reset
	_swordManager._reset()
	$Label.text = "mood vals"+ String(duelist2_mood.x) + ":" + String(duelist2_mood.y) + ":"+ String(duelist2_mood.z)
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
		if(my_choice < 3):_dialogManager._choiceDisplay[my_choice].change_color(7)
	else:
		if(my_choice < 3):_dialogManager._choiceDisplay[my_choice].change_color(1)
	update_oponent_mood(mood_value)
	for i in range (0, 3):
		if(mood_value[i] > 0):
			_swordManager._deulist2. emmit_mood(i, duelist2_mood[i])
		
	
func update_oponent_mood(mood_value:Vector3):
	duelist2_mood+= mood_value
	if(duelist2_mood[GlobalSettings.MOODS.AFFECTION] >= 100):
		_run_outcome(GlobalSettings.OUTCOMES.RECONCILE)
	elif(duelist2_mood[GlobalSettings.MOODS.FEAR] >= 100):
		_run_outcome(GlobalSettings.OUTCOMES.DEMORALIZE)
	
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
	if(duelist_healths[duelist] <= 0):
		_run_outcome(duelist)

func _run_outcome(outcome:int):
	if(outcomeOccured):return
	outcomeOccured = true
	_inBetweenTimer.stop()
	_everyTenSeconds.stop()
	_swordManager.animateOutcome(outcome)
	emit_signal("CompletedOutcome",outcome)
	GlobalSettings.victoriesAcheived[outcome] = true
