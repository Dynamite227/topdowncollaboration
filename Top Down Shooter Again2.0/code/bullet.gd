extends Area2D

const SPEED := 700.0
const MAX_DISTANCE := 4000.0
var travelled_distance := 0.0
var who_shot : String = "" #should have used a bool

func _process(delta: float):
	var direction := Vector2.RIGHT.rotated(rotation)

	position += direction * SPEED * delta

	travelled_distance += SPEED * delta

	if travelled_distance >= MAX_DISTANCE:
		queue_free()


func _on_body_entered(body: Node2D):
	if body.is_in_group("player") and who_shot == "enemy": #detect collision with player and checks if the enemy shot the bullet. 
	#this is where im confused because it won't detect collision with the player for some reason.
		var player: RigidBody2D = body
		print("Player got hit") #debug help
		player.hide()
		queue_free()
	# Detects collision with the enemies
	if body.is_in_group("enemy") and who_shot == "player":
		var enemy: CharacterBody2D = body
		enemy.slime.play_hurt()		# Look at the enemy.tscn.
		enemy.health -= 1
		queue_free()
