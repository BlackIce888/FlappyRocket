extends Node

var points : int = 0
var difficulty : int = 0
var isGameOver : bool = false 

class_name Game

signal finished

func _ready():
	$Player.connect("game_over", self, "_on_game_over")
	$WallManager.connect("difficulty_cleared", self, "_on_difficulty_cleared")
	increase_difficulty()
	
func _process(delta):
	$CanvasLayer/GUI/Punkte.text = String(points)
	$CanvasLayer/GUI/Level.text = String(difficulty)
	
func increase_difficulty():
	difficulty += 1
	$WallManager.spawn(difficulty)

func _on_game_over():
	$BGMPlayer.stop()
	yield($Player/SFXPlayer.play(), "finished")
	emit_signal("finished")
	
func _on_Wall_cleared(body):
	points += 1

func _on_difficulty_cleared():
	increase_difficulty()
