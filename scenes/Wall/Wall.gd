extends Node2D

class_name Wall

signal wall_despawned

var speed : float = 125.0

func init(move_speed : float, space : float, offset : float):
	speed = move_speed
	$UpperWall.position.y += clamp(abs(space), 0, 50)   
	$LowerWall.position.y -= clamp(abs(space), 0, 50) 
	position.y += offset
	
func _process(delta):
	position.x -= speed * delta

func _on_DespawnArea_entered(area : Area2D):
	if is_a_parent_of(area):
		emit_signal("wall_despawned")
		queue_free()
