extends RigidBody2D

@onready var weapon_holder := $WeaponHolder
@onready var timer: Timer = $Timer
@onready var gun := $"WeaponHolder/Gun"
@onready var shotSfx := $"gunshot"
@onready var mainView := $"../mainView"
var is_alive = true
var knockback = Vector2(1,1)
@export var borderOffset = 200

signal end_game


func _physics_process(_delta: float) -> void:
	# Didn't clutter up the _physics_process() function.
	handle_holder_rotation()
	mouseClick()
	if is_alive == false:
		hide()
		end_game.emit()


func handle_holder_rotation():
	# This line of code makes the weapon look at the position of the mouse
	# on the screen enabling the player to aim.
	weapon_holder.look_at(get_global_mouse_position())


func move_player():
	var direction: Vector2 = Vector2.LEFT.rotated(weapon_holder.rotation) * 400.0

	# Timer is used to that player doesn't keep on moving forever when we click.
	# TRY: Comment the timer.start(), await player.timer.timeout and the lines after it to see the results for yourself.
	timer.start()
	apply_central_impulse(knockback * direction)

	await timer.timeout


func mouseClick():
	if Input.is_action_just_pressed("left_click") and is_alive == true:
		# Code to execute when left mouse button is clicked
		shotSfx.play()
		gun.shoot_bullet("player")
		move_player()



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# This kills the player if it gets out the screen.
	is_alive = false
