extends CharacterBody2D

const SPEED := 250.0

@onready var slime := $Slime
@onready var player = get_node("/root/GameScene/Player")
@onready var gun := $WeaponHolder/Gun
@onready var weapon_holder = $WeaponHolder
@onready var time_between = $timeBetweenShots
@export var shootDistance = 500

var health := 3


func _ready() -> void:
	slime.play_walk()
	time_between.start()


func _process(_delta: float) -> void:
	handle_holder_rotation()
	enemy_logic()




func _on_hurtbox_detection_body_entered(body): #checks if the player touched the enemy
	if body.is_in_group("player"):
		player.hide()
		player.is_alive = false


func handle_holder_rotation():
	# Declare the 'weapon_holder' variable in the current scope


	# This line of code makes the weapon look at the position of the mouse
	# on the screen enabling the player to aim.
	weapon_holder.look_at(player.position)

func enemy_logic():
	var direction := position.direction_to(player.position)


	if position.distance_to(player.position) > shootDistance:

		if player.is_alive == true:


			velocity = direction * SPEED
	else:
		velocity = -direction * SPEED
	move_and_slide()
	if health <= 0:
		queue_free()
	await time_between.timeout
	gun.shoot_bullet("enemy")
	time_between.start()
