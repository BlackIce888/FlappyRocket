extends Node

var game_ressource : PackedScene = preload("res://scenes/Game/Game.tscn")
var menu_ressource : PackedScene = preload("res://scenes/Menu/Menu.tscn")
var pause_menu_ressource : PackedScene = preload("res://scenes/Menu/PauseMenu.tscn")
var menu : Menu
var game : Game
var ignore_input : bool = false

func _ready():
	load_menu(menu_ressource.instance(), false)
	
func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel") && game is Game && !ignore_input):
		toggle_pause()

func load_game():
	if (!game is Game):
		game = game_ressource.instance()
		add_child(game)
		game.connect("finished", self, "_game_ended")
		set_paused(true, true)
		yield(get_tree().create_timer(0.5), "timeout")
		set_paused(false, false)
		
func set_paused(is_paused : bool, is_input_ignored : bool = false):
	get_tree().paused = is_paused
	ignore_input = is_input_ignored

func load_menu(menu_instance : Menu, isPauseMenu : bool):
	menu = menu_instance
	menu.connect("quit_game", self, "_on_quit_game")
	if (!isPauseMenu):
		menu.connect("start_game", self, "_on_start_game")
	else:
		menu.connect("resume_game", self, "_on_resume_game")
	add_child(menu)

func _game_ended():
	unload_game()
	load_menu(menu_ressource.instance(), false)

func unload_game():
	if (game is Game):
		game.queue_free()

func unload_menu():
	if (menu is Menu):
		menu.queue_free()

func toggle_pause():
	if (menu is Menu):
		menu.queue_free()
		set_paused(false)
	else:
		load_menu(pause_menu_ressource.instance(), true)
		set_paused(true)

func _on_start_game():
	unload_menu()
	load_game()

func _on_resume_game():
	unload_menu()
	get_tree().paused = false
	
func _on_quit_game():
	unload_menu()
	unload_game()
	get_tree().quit()
