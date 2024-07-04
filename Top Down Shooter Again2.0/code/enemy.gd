extends CharacterBody2D

const SPEED := 250.0

@onready var slime := $Slime
@onready var player = get_node("/root/GameScene/Player")

var health := 3


func _ready() -> void:
	slime.play_walk()


func _process(_delta: float) -> void:
	if player.is_alive == true:
		var direction := position.direction_to(player.position)

		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	if health <= 0:
		queue_free()


func _on_hurtbox_detection_body_entered(body): #checks if the player touched the enemy
	if body.is_in_group("player"):
		player.hide()
		player.is_alive = false
