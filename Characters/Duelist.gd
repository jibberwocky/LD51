extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var _anim_player := $AnimationPlayer
var has_next_anim := false
var next_anim := ""
var continue_animating = true
onready var _blood_particles := $CPUParticles2D
onready var mood_particles := [$hearts, $fear, $rage]
onready var _sePlayer := $SEPlayer

export var SE_hit : AudioStreamSample = preload("res://Sounds/hit.wav")
export var SE_clashGood : AudioStreamSample = preload("res://Sounds/klangGood.wav")
export var SE_clashBad : AudioStreamSample = preload("res://Sounds/klangBad.wav")

func _ready():
	if(flip_h):
		_blood_particles.set_direction(Vector2(1, -0.5))
		_blood_particles.position = Vector2(40,0)
		for moodParts in mood_particles:
			moodParts.set_direction(Vector2(0, -1))
			moodParts.position = Vector2(40,0)
	pass # Replace with function body.


func play_animation(animationName:String):
	_anim_player.stop()
	_anim_player.play(animationName)
	if(animationName == "getHit"):
		_blood_particles.set_emitting(true)
		playSoundEffect(SE_hit)
		
	
func set_next_anim(animationName:String):
	has_next_anim = true
	next_anim = animationName

func _on_AnimationPlayer_animation_finished(anim_name):
	if(!has_next_anim): 
		if(continue_animating):play_animation("idle") 
		return
	has_next_anim =false
	play_animation(next_anim)

func emmit_mood(mood_type:int, mood_ammount:int):
	if(mood_ammount > 0):
		mood_particles[mood_type].set_amount(mood_ammount/10)
		mood_particles[mood_type].set_emitting(true)

func playSoundEffect(soundFile) -> void:
		if !_sePlayer.is_playing():
			_sePlayer.stream = soundFile
			_sePlayer.pitch_scale = rand_range(0.9, 1.1)
			_sePlayer.play()

