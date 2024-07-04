# This script handles the mouse clicking events for the player
# and enables the player to shoot bullets via gun.

extends Area2D

@onready var weapon_holder := $"../WeaponHolder"
@onready var gun := $"../WeaponHolder/Gun"


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	var mouse_click: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()

	if mouse_click:
		move_player()
		gun.shoot_bullet()


func move_player():
	# get_parent() references the player node. Cause this node's parent
	# is the Player itself.
	var player = get_parent()

	# This sets the direction of the player to the opposite of the rotation of the weapon.

	# This is necessary so that the player moves backward to the rotation of the weapon.
	var direction: Vector2 = Vector2.LEFT.rotated(weapon_holder.rotation) * 400.0

	# Timer is used to that player doesn't keep on moving forever when we click.

	# TRY: Comment the timer.start(), await player.timer.timeout and the lines after it to see the results for yourself.
	player.timer.start()
	player.velocity = direction

	await player.timer.timeout

	player.velocity = Vector2.ZERO