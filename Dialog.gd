extends Control
class_name Dialog
onready var dialogGuiElement = preload("res://Gui/DialogDisplay.tscn")

enum moods{
	AFFECTION
	MORALE
	RAGE
}

func _ready():
	pass 

var choices : Array
var prompt : String = ""

func testChoice():
	pass
	
func create_dialog_gui():
	dialogGuiElement.instance()

func setupChoice(prompt:String, choices:Array):
	pass

class DialogChoice:
	var text: String = ""
	var mood_value : Vector3 = Vector3.ZERO
	var predicted_move : int = GlobalSettings.SWORD_ACTIONS.WAIT

	func _init(inText:String, mood_V:Vector3, prediction:int):
		text = inText
		mood_value = mood_V
		predicted_move = prediction
	
	
