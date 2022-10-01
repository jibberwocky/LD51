extends Control
class_name Dialog
onready var dialogGuiElement = preload("res://Gui/DialogDisplay.tscn")

class DialogChoice:
	var text: String = ""
	var mood_value : Vector3 = Vector3.ZERO
	var predicted_move : int = GlobalSettings.SWORD_ACTIONS.WAIT

	func _init(inText:String, mood_V:Vector3, prediction:int):
		text = inText
		mood_value = mood_V
		predicted_move = prediction
	
	


enum moods{
	AFFECTION
	MORALE
	RAGE
}

func _ready():
	testChoice()

var choices : Array
var prompt : String = ""
onready var _promptDisplay := $PromptDisplay
onready var _choiceDisplay := [$choiceDialog1, $choiceDialog2, $choiceDialog3]
onready var _choicesDelay := $choicesDelay
var chosen_choice := 4

func testChoice():
	setupChoice("It doesn't have to go like this",
	[DialogChoice.new("Like hell it doesn't, I've got you dead to rights!", Vector3.ZERO, 0),DialogChoice.new("How dare you say that. After what you did!", Vector3.ZERO, 0),DialogChoice.new("I wish that were true...", Vector3.ZERO, 0),DialogChoice.new("Maybe...", Vector3.ZERO, 0) ])
	
func update_dialog_gui_choice(choice:DialogChoice, gui:DialogDisplay, choice_num:int):
	gui.text = choice.text
	gui.activate()
	gui.choice_number = choice_num
	gui.locked = false
	
func update_dialog_gui_prompt(text:String, gui:DialogDisplay):
	gui.text = text
	gui.activate()
	gui.locked = true

func setupChoice(new_prompt:String, new_choices:Array):
	chosen_choice = 4
	prompt = new_prompt
	choices = new_choices
	update_dialog_gui_prompt(prompt, _promptDisplay)
	_choicesDelay.start()
	
func _on_choicesDelay_timeout():
	display_choices()

func display_choices():
	for i in range (0,len(_choiceDisplay)):
		update_dialog_gui_choice(choices[i], _choiceDisplay[i], i)


func _on_choiceDialog_choice_selected(choice_number):
	chosen_choice = choice_number
	for i in range (0,len(_choiceDisplay)):
		if(i != chosen_choice):_choiceDisplay[i].vanish()
		



