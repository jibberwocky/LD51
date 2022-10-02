extends Resource
class_name DialogDatabase

var currentStep := 0



var Dialogs := {
	"affection":[],
	"fear":[],
	"rage":[],
	"neutral":[],
}
var firstDialog : ChoiceObject 

class DialogChoice:
	var text: String = ""
	var mood_value : Vector3 = Vector3.ZERO
	var predicted_move : int = GlobalSettings.SWORD_ACTIONS.WAIT

	func _init(inText:String, mood_V:Vector3, prediction:int):
		text = inText
		mood_value = mood_V
		predicted_move = prediction
	

class ChoiceObject:
	var choices : Array
	var prompt : String = ""
	
	func _init(new_prompt:String, new_choices:Array):
		prompt = new_prompt
		choices = new_choices

func get_next_dialog(moods:Vector3) -> ChoiceObject:
	var mood_choice := "neutral"
	var choice : ChoiceObject
	if(randi() % 120 < moods[GlobalSettings.MOODS.RAGE]):
		mood_choice = "rage"
	elif(randi() % 105 < moods[GlobalSettings.MOODS.AFFECTION]):
		mood_choice = "affection"
	elif(randi() % 105 < moods[GlobalSettings.MOODS.FEAR]):
		mood_choice = "fear"
	currentStep = wrapi(currentStep + 1, 0, 6)
	return Dialogs[mood_choice][currentStep-1]


func _init():
	populateDB()
	
func populateDB():
	firstDialog = ChoiceObject.new("It doesn't have to go like this",[
	DialogChoice.new("Like hell it doesn't, I've got you dead to rights!", Vector3(-10,10,5), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("How dare you say that. After what you did!", Vector3(1,0,10), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("I wish that were true...", Vector3(10,-10,0), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("Maybe...", Vector3(10,0,0), GlobalSettings.SWORD_ACTIONS.WAIT) ])
	#right now just a very long function
	#Consider reading in JSON if I have time
	Dialogs["neutral"].append_array([
	ChoiceObject.new("I can't let you pass, just lower your blade",[
	DialogChoice.new("The friend I knew would never stand against me like this.", Vector3(10,-5,1), GlobalSettings.SWORD_ACTIONS.WAIT),
	DialogChoice.new("What. afraid I might win a fair fight?", Vector3(1,10,10),  GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("the others couldn't stand in my way, neither will you!", Vector3(-20,15,10), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(0,1,0), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	
	ChoiceObject.new("Impressive… you’ve come a long way from the student I once knew",[
	DialogChoice.new("You’ve improved too, I’ve never felt more alive", Vector3(10,0,-10),  GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("I’ve got a few more tricks where that came from", Vector3(0,0,10), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("Maybe you’re just getting sloppy old timer", Vector3(0,0,20), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("...", Vector3(-5,-5,5), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	
	ChoiceObject.new("That blade is wasted on you, it deserves someone who will treat it with respect",[
	DialogChoice.new("Perhaps I should return it to you then. Point first!", Vector3(-5,10,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("Oh like you treated it any better ...", Vector3(-10,0,15), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("Maybe after this I’ll go show your mother some \"respect\"", Vector3(-10,-10,25), GlobalSettings.SWORD_ACTIONS.WAIT),
	DialogChoice.new("...", Vector3(5,0,0), GlobalSettings.SWORD_ACTIONS.PARRY) ]),
	
	ChoiceObject.new("Your father had to die! You must understand he was a monster and a traitor!",[
	DialogChoice.new("LIAR! YOU are the traitor. You’ll pay for what you did", Vector3(0,0,20), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("I understand ...", Vector3(10,0,-10), GlobalSettings.SWORD_ACTIONS.WAIT),
	DialogChoice.new("this isn't about him?. This has always been about you.", Vector3(15,10,-10), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(0,15,0), GlobalSettings.SWORD_ACTIONS.THRUST) ]),
	
	ChoiceObject.new("It’s clear you our past means nothing to you. This ends here!",[
	DialogChoice.new("Indeed. Give me a good fight, like the ones we used to have", Vector3(30,0,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("Please. Wait. You were my friend, I loved you. ", Vector3(30,-20,-20), GlobalSettings.SWORD_ACTIONS.WAIT),
	DialogChoice.new("Then prepare to die", Vector3(-20,40,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(0,0,40), GlobalSettings.SWORD_ACTIONS.PARRY) ]),
	])
	
	Dialogs["rage"].append_array([
	ChoiceObject.new("Don’t mistake my restraint for mercy",[
	DialogChoice.new("Oh you're too predictable for that", Vector3(5,0,10), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("Here’s me thinking you’re just bad at this", Vector3(-10,0,15), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("And don’t mistake my respect for forgiveness", Vector3(5,5,5), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(10,0,0), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	
	ChoiceObject.new("It’s a shame you won’t live to regret your insolence!",[
	DialogChoice.new("You should know I’ve never regretted anything in my life", Vector3(15,-5,0),  GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("Bold claim from someone about to get stabbed", Vector3(0,5,5),  GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("I’ll make sure YOU regret everything you’ve done", Vector3(-10,10,0),  GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(0,0,10), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	
	ChoiceObject.new("I’ll make you bleed for that!",[
	DialogChoice.new("Come on then. Bring it", Vector3(0,10,10), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("I’ve bled for less, it never slowed me down", Vector3(10,0,10), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("Is this the same bloodlust that drove you to kill my father?", Vector3(-10,10,10), GlobalSettings.SWORD_ACTIONS.WAIT),
	DialogChoice.new("...", Vector3(0,0,20), GlobalSettings.SWORD_ACTIONS.PARRY) ]),
	
	ChoiceObject.new("I don’t have time for this! This ends here!",[
	DialogChoice.new("Somewhere to be? Is my vendetta holding you up?", Vector3(0,0,5), GlobalSettings.SWORD_ACTIONS.WAIT),
	DialogChoice.new("We can end this any time you want, just surrender", Vector3(10,0,5), GlobalSettings.SWORD_ACTIONS.WAIT),
	DialogChoice.new("Careful old friend, impatience makes you blunder", Vector3(0,0,15), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("...", Vector3(0,0,30), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	
	ChoiceObject.new("",[
	DialogChoice.new("Cat got your tongue?", Vector3(0,10,20), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("You always talked too much anyway", Vector3(10,0,10), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("I must really be getting under your skin", Vector3(-10,10,20), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("...", Vector3(20,0,0), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	
	ChoiceObject.new("WHY WON’T. YOU. DIE!",[
	DialogChoice.new("Your temper always did get the better of you", Vector3(5,10,20),GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("I’ve won, surrender now and spare your ego", Vector3(-5,0,10), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("YOU.FIRST!", Vector3(-30,40,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(10,0,0), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
		])
		
	Dialogs["affection"].append_array([
	ChoiceObject.new("Turn back before I do something we’ll both regret",[
	DialogChoice.new("It’ll be hard to regret it when you’re dead", Vector3(-5,10,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("Regret? How dare you speak of regret after what you did", Vector3(0,0,10), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("You know I'd never turn back. Give me a good fight!", Vector3(10,-10,0), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("...", Vector3(20,0,0), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	
	ChoiceObject.new("Oh to match blades with you again",[
	DialogChoice.new("I’ve missed it too old friend", Vector3(0,15,00), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("You’ve gotten sloppy", Vector3(-10,0,10), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("Don’t think this is like before. This time you die", Vector3(-10,10,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(-20,0,1), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	
	ChoiceObject.new("You treat that sword well. Better than I ever did",[
	DialogChoice.new("Funny. I was thinking about returning it to you. Point first!", Vector3(-10,10,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("I promise I will honor it when this is all over", Vector3(5,10,0), GlobalSettings.SWORD_ACTIONS.WAIT),
	DialogChoice.new("I know you'll treat it well if this doesn’t go my way...", Vector3(10,-10,-10), GlobalSettings.SWORD_ACTIONS.WAIT),
	DialogChoice.new("...", Vector3(-10,0,0), GlobalSettings.SWORD_ACTIONS.THRUST) ]),
	
	ChoiceObject.new("I never wanted our friendship to end like this",[
	DialogChoice.new("You should have thought about that before!", Vector3(-20,0,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("Then let me know I’m worth more than your honor!", Vector3(20,0,0), GlobalSettings.SWORD_ACTIONS.WAIT),
	DialogChoice.new("I always knew it could only end this way", Vector3(-10,10,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(0,0,0), GlobalSettings.SWORD_ACTIONS.PARRY) ]),
	
	ChoiceObject.new("You must understand I had to kill him, for you",[
	DialogChoice.new("*INCOHERENT RAGE*", Vector3(0,20,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("*INCOHERENT SADNESS*", Vector3(20,0,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...and that makes you no better than him", Vector3(-10,0,10),GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(0,0,0), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	
	ChoiceObject.new("I loved you...",[
	DialogChoice.new("I love you too", Vector3(50,-20,-20), GlobalSettings.SWORD_ACTIONS.WAIT),
	DialogChoice.new("I did too once...", Vector3(10,0,0), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("and I always hated you for it", Vector3(-50,0,50), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(-50,50,0), GlobalSettings.SWORD_ACTIONS.THRUST) ]),
	])
	Dialogs["fear"].append_array([
	ChoiceObject.new("You couldn’t fight your way out of a paper bag with that technique",[
	DialogChoice.new("and you couldn't hit the side of a barn door", Vector3(0,0,5),GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("Thats an old one. Running out of material?", Vector3(0,0,10), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("Then what does that make you? the bag", Vector3(5,0,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(0,-10,0),  GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	
	ChoiceObject.new("Aren’t you getting tired of all this violence?",[
	DialogChoice.new("Do you need a breather old timer?", Vector3(-10,0,10),  GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("Just getting started", Vector3(0,10,0),  GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("I’m  drained to be fighting an old friend", Vector3(10,-10,0), GlobalSettings.SWORD_ACTIONS.WAIT),
	DialogChoice.new("...", Vector3(20,0,0), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	
	ChoiceObject.new("You would kill me here? In our home? On a day like this?",[
	DialogChoice.new("It’s a good a day as anyone could want to die on", Vector3(0,10,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("You killed my father in much the same way...", Vector3(0,0,10), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("And you’d do the same? you aren't above this", Vector3(-10,0,10), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(10,-10,-10), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	
	ChoiceObject.new("Let up a minute, you're frightening me, this isn’t a fight with honor",[
	DialogChoice.new("Afraid of a real fight?", Vector3(0,10,15), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("My real friend would fight not cower", Vector3(5,20,10), GlobalSettings.SWORD_ACTIONS.PARRY),
	DialogChoice.new("*INTIMIDATING YELL*", Vector3(-30,40,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(0,20,0), GlobalSettings.SWORD_ACTIONS.THRUST) ]),
	
	ChoiceObject.new("Please, have mercy, I don’t want to do this anymore",[
	DialogChoice.new("No", Vector3(0,30,00), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("I’m sorry . . . No", Vector3(5,0,0), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("Never!", Vector3(10,0,30), GlobalSettings.SWORD_ACTIONS.THRUST),
	DialogChoice.new("...", Vector3(20,-10,0), GlobalSettings.SWORD_ACTIONS.WAIT) ]),
	])	
