extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal fightWon(winner)

onready var _deulist1 := $Duelist1
onready var _deulist2 := $Duelist2
onready var _thrustButton := $Duelist1/ThustButton
onready var _parryButton := $Duelist1/ParryButton
onready var _waitButton := $Duelist1/waitButton
onready var _2thrustButton := $Duelist2/ThustButton
onready var _2parryButton := $Duelist2/ParryButton
onready var _2waitButton := $Duelist2/waitButton2
onready var _sePlayer := $SEPlayer
onready var _healthbars := [$Duelist1/healthbar1, $Duelist2/healthbar2]

export var SE_hit : AudioStreamSample = preload("res://Sounds/hit.wav")
export var SE_clashGood : AudioStreamSample = preload("res://Sounds/klangGood.wav")
export var SE_clashBad : AudioStreamSample = preload("res://Sounds/klangBad.wav")
export var SE_clashEnd : AudioStreamSample = preload("res://Sounds/klang1.wav")
export var SE_noHit : AudioStreamSample = preload("res://Sounds/no hit.wav")

var target_pos := position
const MOVE_LIMIT = 100
const MOVE_DISTANCE = 30
const MOVE_RATE = 0.2
var actionChoice :int= GlobalSettings.SWORD_ACTIONS.WAIT
var fade_buttons = 1
var temporary_target = target_pos.x
var halted = false
# Called when the node enters the scene tree for the first time.
func _ready():
	_thrustButton.text = "Thrust"
	_thrustButton.activate()
	_parryButton.text = "Parry"
	_parryButton.activate()
	_2parryButton.text = "Parry"
	_2thrustButton.text = "Thrust"
	
	_2waitButton.text = "wait"
	_waitButton.text = "wait"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	if(abs(position.x - temporary_target) <= 0.1):
		temporary_target = target_pos.x
	else:
		print(position.x, ",", temporary_target)
	if(!halted):position.x = lerp(position.x, temporary_target, MOVE_RATE)
	fade_buttons -= 0.01
	if(fade_buttons < 0.5):
		_waitButton.vanish()
		_2waitButton.vanish()
		_2parryButton.vanish()
		_2thrustButton.vanish()
		
	
func _reset():
	actionChoice= GlobalSettings.SWORD_ACTIONS.WAIT
	_thrustButton.lock(false)
	_parryButton.lock(false)
	_thrustButton.activate()
	_parryButton.activate()
	_2thrustButton.vanish()
	_2parryButton.vanish()

func _on_ThustButton_choice_selected(choice_number):
	actionChoice= GlobalSettings.SWORD_ACTIONS.THRUST
	_thrustButton.lock(true)
	_parryButton.vanish()


func _on_ParryButton_choice_selected(choice_number):
	actionChoice= GlobalSettings.SWORD_ACTIONS.PARRY
	_parryButton.lock(true)
	_thrustButton.vanish()
	
func resolve_sword_choices(duelist1Choice:int, duelist2Choice:int):
	var fight_winner := 0
	fade_buttons = 1
	match duelist1Choice:
		GlobalSettings.SWORD_ACTIONS.WAIT:
			_waitButton.activate()
			_deulist1.play_animation("wait")
			match duelist2Choice:
				GlobalSettings.SWORD_ACTIONS.WAIT:
					_deulist2.play_animation("wait")
					_2waitButton.activate()
					playSoundEffect(SE_noHit)
				GlobalSettings.SWORD_ACTIONS.THRUST:
					_deulist2.play_animation("thrust")
					_deulist1.set_next_anim("getHit")
					_deulist2.playSoundEffect(SE_clashBad)
					fight_winner = -1
					emit_signal("fightWon",2)
					_2thrustButton.activate()
					pass
				GlobalSettings.SWORD_ACTIONS.PARRY:	
					_deulist2.play_animation("parry")
					_2parryButton.activate()
					playSoundEffect(SE_noHit)
					pass
		GlobalSettings.SWORD_ACTIONS.THRUST:
			_deulist1.play_animation("thrust")
			match duelist2Choice:
				GlobalSettings.SWORD_ACTIONS.WAIT:
					_2waitButton.activate()
					_deulist2.play_animation("wait")
					_deulist2.set_next_anim("getHit")
					_deulist1.playSoundEffect(SE_clashGood)
					fight_winner = 1
					emit_signal("fightWon",1)
				GlobalSettings.SWORD_ACTIONS.THRUST:
					_deulist2.play_animation("thrust")
					_deulist1.set_next_anim("getHit")
					_deulist2.set_next_anim("getHit")
					_deulist1.playSoundEffect(SE_clashGood)
					_deulist2.playSoundEffect(SE_clashBad)
					_2thrustButton.activate()
					emit_signal("fightWon",0)
					pass
				GlobalSettings.SWORD_ACTIONS.PARRY:	
					_deulist2.play_animation("parry")
					_deulist2.set_next_anim("thrust")
					_deulist1.set_next_anim("getHit")
					_2parryButton.activate()
					_deulist2.playSoundEffect(SE_clashBad)
					fight_winner = -1
					emit_signal("fightWon",2)
					pass
		GlobalSettings.SWORD_ACTIONS.PARRY:	
			_deulist1.play_animation("parry")
			match duelist2Choice:
				GlobalSettings.SWORD_ACTIONS.WAIT:
					_2waitButton.activate()
					_deulist2.play_animation("wait")
					_deulist2.set_next_anim("thrust")
					_deulist1.set_next_anim("getHit")
					emit_signal("fightWon",2)
					_deulist2.playSoundEffect(SE_clashBad)
				GlobalSettings.SWORD_ACTIONS.THRUST:
					_deulist2.play_animation("thrust")
					_deulist1.set_next_anim("thrust")
					_deulist2.set_next_anim("getHit")
					_2thrustButton.activate()
					_deulist1.playSoundEffect(SE_clashGood)
					fight_winner = 1
					emit_signal("fightWon",1)
					pass
				GlobalSettings.SWORD_ACTIONS.PARRY:	
					_deulist2.play_animation("parry")
					_2parryButton.activate()
					playSoundEffect(SE_noHit)
					pass
	
	move_duelists(fight_winner)
		
func move_duelists(direction :int):
	target_pos.x += clamp(direction*MOVE_DISTANCE, -MOVE_LIMIT, MOVE_LIMIT)
	
func update_healthbar(healthbar_number:int, new_value:int):
	_healthbars[healthbar_number].target_value = (float(new_value)/GlobalSettings.MAX_DUELIST_HEALTH * 100)
	
func animateOutcome(outcome:int):
	halted = true
	playSoundEffect(SE_clashEnd)
	match outcome:
		GlobalSettings.OUTCOMES.DEFEAT:
			_deulist2.play_animation("thrust")
			_deulist1.play_animation("getHit")
			_deulist1.set_next_anim("die")
			_deulist1.continue_animating = false
		GlobalSettings.OUTCOMES.VICTORY:
			_deulist1.play_animation("thrust")
			_deulist2.play_animation("getHit")
			_deulist2.set_next_anim("die")
			_deulist2.continue_animating = false
		GlobalSettings.OUTCOMES.DEMORALIZE:
			_deulist1.play_animation("wait")
			_deulist2.set_next_anim("give_up")
			_deulist2.continue_animating = false
		GlobalSettings.OUTCOMES.RECONCILE:
			_deulist1.set_next_anim("reconcile")
			_deulist2.set_next_anim("reconcile")
			_deulist2.continue_animating = false
			_deulist1.continue_animating = false
		GlobalSettings.OUTCOMES.TRADGEDY:
			_deulist1.set_next_anim("die")
			_deulist2.set_next_anim("die")
			_deulist2.continue_animating = false
			_deulist1.continue_animating = false

func playSoundEffect(soundFile) -> void:
		if !_sePlayer.is_playing():
			_sePlayer.stream = soundFile
			_sePlayer.pitch_scale = rand_range(0.9, 1.1)
			_sePlayer.play()


