extends Control
class_name Dialog
onready var dialogGuiElement = preload("res://Gui/DialogDisplay.tscn")

func _ready():
	setupChoice(_dialogDB.firstDialog)

var choices : Array
var prompt : String = ""
onready var _promptDisplay := $PromptDisplay
onready var _choiceDisplay := [$choiceDialog1, $choiceDialog2, $choiceDialog3]
onready var _choicesDelay := $choicesDelay
export var _dialogDB : Resource= preload("res://Systems/DialogDatabase.tres")
var chosen_choice := 3

func next_choice(moods:Vector3):
	setupChoice(_dialogDB.get_next_dialog(moods))
	
func update_dialog_gui_choice(choice:DialogDatabase.DialogChoice, gui:DialogDisplay, choice_num:int):
	gui.text = choice.text
	gui.activate()
	gui.choice_number = choice_num
	gui.locked = false
	
func update_dialog_gui_prompt(text:String, gui:DialogDisplay):
	gui.text = text
	gui.activate()
	gui.locked = true

func setupChoice(ChoiceObject : DialogDatabase.ChoiceObject):
	chosen_choice = 3
	prompt = ChoiceObject.prompt
	choices = ChoiceObject.choices
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
		

	

