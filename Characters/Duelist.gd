extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var _anim_player := $AnimationPlayer
var has_next_anim := false
var next_anim := ""
onready var _blood_particles := $CPUParticles2D
# Called when the node enters the scene tree for the first time.
func _ready():
	if(flip_h):
		_blood_particles.set_direction(Vector2(1, -0.5))
		_blood_particles.position = Vector2(40,0)
	pass # Replace with function body.


func play_animation(animationName:String):
	_anim_player.stop()
	_anim_player.play(animationName)
	if(animationName == "getHit"):
		_blood_particles.set_emitting(true)
		
	
func set_next_anim(animationName:String):
	has_next_anim = true
	next_anim = animationName

func _on_AnimationPlayer_animation_finished(anim_name):
	if(!has_next_anim): 
		play_animation("idle") 
		return
	has_next_anim =false
	play_animation(next_anim)
	
