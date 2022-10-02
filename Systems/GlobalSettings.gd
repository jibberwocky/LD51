extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MAX_DUELIST_HEALTH = 3
enum SWORD_ACTIONS{
	WAIT
	PARRY
	THRUST
}
enum MOODS{
	AFFECTION
	FEAR
	RAGE
}

enum OUTCOMES{
	DEFEAT
	VICTORY
	DEMORALIZE
	RECONCILE
	TRADGEDY
}

var victoriesAcheived := [false,false,false,false,false]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
