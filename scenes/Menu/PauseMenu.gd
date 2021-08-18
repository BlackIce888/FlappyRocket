extends "res://scenes/Menu/Menu.gd"

signal resume_game

func _on_ResumeButton_pressed():
	emit_signal("resume_game")

func _on_QuitButton_pressed():
	emit_signal("quit_game")
