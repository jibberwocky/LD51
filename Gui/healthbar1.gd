extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target_value = value

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	value = lerp(value, target_value, 0.05)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
