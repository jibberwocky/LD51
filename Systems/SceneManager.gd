extends Node
class_name scene_manager

var currentSceneNum := 0
onready var currentScene := $MainMenu
var nextScene = null
onready var _bg = $Bg

var bg_positions = [201,123]
var bg_target_pos = bg_positions[0]
const BG_MOVE_SPEED = 0.1
var levels = ["res://MainScenes/MainMenu.tscn","res://DuelScene.tscn" ]

onready var _main_menu = preload("res://Gui/HowToPlaySceen.tscn")
func _process(delta):
	_bg.position.y = lerp(_bg.position.y, bg_target_pos, BG_MOVE_SPEED)
	


func _ready():
	randomize()
	pass # Replace with function body.


func on_change_scene():
	currentSceneNum = wrapi(currentSceneNum +1, 0 ,len(levels))
	nextScene = load(levels[currentSceneNum]).instance()
	self.add_child(nextScene)
	nextScene.connect("change_scene", self, "on_change_scene")
	bg_target_pos = bg_positions[currentSceneNum]
	
	currentScene.cleanup()
	currentScene = nextScene
	nextScene = null
	
	
