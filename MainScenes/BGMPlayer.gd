extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var target_volume:= -30

# Called when the node enters the scene tree for the first time.
func _ready():
	volume_db = -50



func _process(delta):
	if(volume_db != target_volume): volume_db = min(target_volume, volume_db+1)
