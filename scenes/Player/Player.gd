extends KinematicBody2D

export (float) var gravity = 250.0
export (float) var max_speed = 175.0
export (float) var force = 500.0
export (AudioStream) var sfx_death
export (AudioStream) var sfx_thrust

var temp_velocity = Vector2()
var velocity = Vector2()
var isGameOver : bool = false 

signal game_over

func _ready():
	$SFXPlayer.stream = sfx_thrust
	temp_velocity.x = 100.0
	velocity.x = 0.0
	$SmokeParticles.position = $Position2D.position
	$FlameParticles.position = $Position2D.position

func _physics_process(delta):
	if (position.y < 5.0 || position.y > 263.0):
		emit_game_over()
	if Input.is_action_pressed("ui_accept"):
		$SmokeParticles.emitting = true
		$FlameParticles.emitting = true
		temp_velocity.y -= force * delta
		if (!$SFXPlayer.playing):
			$SFXPlayer.play()
	else:
		$SmokeParticles.emitting = false  
		$FlameParticles.emitting = false  
		temp_velocity.y += gravity * delta
		$SFXPlayer.stop()
	velocity.y = clamp(temp_velocity.y, -max_speed, max_speed)
	var normal_velocity = temp_velocity.normalized()
	rotation = cos(normal_velocity.x) + sin(normal_velocity.y)
	$SmokeParticles.rotation = -cos(normal_velocity.x) - sin(normal_velocity.y)
	$FlameParticles.rotation = $SmokeParticles.rotation
	velocity = move_and_slide(velocity, Vector2.UP)

func emit_game_over():
	if (!isGameOver):
		isGameOver = true
		$SFXPlayer.stream = sfx_death
		#$DeathParticle.emmiting = true
		emit_signal("game_over")

func _on_CollisionArea_body_entered(body):
	emit_game_over()
