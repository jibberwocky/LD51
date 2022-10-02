extends Node2D

signal change_scene
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target_visibility = 1
const APPEAR_SPEED = 0.1
onready var outcomeDialog = $outcomeHolder/OutcomeDialog
func _process(delta):
	modulate.a = lerp(modulate.a, target_visibility, APPEAR_SPEED)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func cleanup():
	queue_free()


func _on_DialogDisplay_choice_selected(choice_number):
	emit_signal("change_scene")


func _on_DuelManager_CompletedOutcome(outcome):
	outcomeDialog.activate()
	outcomeDialog.lock(false)
	$outcomeHolder.position = Vector2.ZERO
	match outcome:
		GlobalSettings.OUTCOMES.DEFEAT:
			outcomeDialog.text = "DEFEAT"
		GlobalSettings.OUTCOMES.VICTORY:
			outcomeDialog.text = "VICTORY"
		GlobalSettings.OUTCOMES.DEMORALIZE:
			outcomeDialog.text = "DEMORALIZE"
		GlobalSettings.OUTCOMES.RECONCILE:
			outcomeDialog.text = "RECONCILE"

