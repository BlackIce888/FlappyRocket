extends Node2D

class_name WallSpawner

export (int) var difficulty_increase_rate = 5

var wall : PackedScene = preload("res://scenes/Wall/Wall.tscn")
var currentDifficulty : int = 0
var wallCount : int = 0
var spawnCount : int = 0
var speed : float = 95.0
var spawnInterval : float = 0
var space : float = 50.0
var offset : float = 50.0

signal difficulty_cleared

func spawn(difficulty : int):
	currentDifficulty = difficulty
	randomize_spawn_params(currentDifficulty)
	$SpawnTimer.start(spawnInterval)
	#currentWall.get_node("WallArea").connect("area", self, "_on_game_over")

func randomize_spawn_params(difficulty : int):
	spawnCount = randi() % (2 + difficulty) + (2 + difficulty)
	speed += difficulty * difficulty_increase_rate
	spawnInterval = speed / (25 * difficulty)
	wallCount = spawnCount
	
func randomize_positional_params(difficulty : int):
	space = rand_range(0.0, randi() % 10 * difficulty)
	offset = rand_range(-30.0, 30.0)

func _on_SpawnTimer_timeout():
	if spawnCount > 0:
		spawnCount -= 1
		var currentWall : Wall = wall.instance()
		randomize_positional_params(currentDifficulty)
		currentWall.init(speed, space, offset)
		currentWall.connect("wall_despawned", self, "_on_Wall_despawned")
		get_node("../DespawnArea").connect("area_entered", currentWall, "_on_DespawnArea_entered")
		add_child(currentWall)
		currentWall.get_node("WallArea").connect("body_exited", get_parent(), "_on_Wall_cleared")
		currentWall.get_node("UpperWall/CollisionAreaTop").connect("body_entered", get_node("../Player"), "_on_CollisionArea_body_entered")
		currentWall.get_node("LowerWall/CollisionAreaBottom").connect("body_entered", get_node("../Player"), "_on_CollisionArea_body_entered")
		
func _on_Wall_despawned():
	wallCount -= 1
	if wallCount <= 0:
		emit_signal("difficulty_cleared")		
