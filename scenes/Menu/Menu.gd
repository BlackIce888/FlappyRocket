extends Node

signal start_game
signal quit_game

class_name Menu

func _on_StartButton_pressed():
	$BGMPlayer.stop()
	emit_signal("start_game")

func _on_QuitButton_pressed():
	$BGMPlayer.stop()
	emit_signal("quit_game")
