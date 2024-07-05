extends RigidBody2D

@onready var weapon_holder := $WeaponHolder
@onready var timer: Timer = $Timer
@onready var gun := $"WeaponHolder/Gun"
@onready var shotSfx := $"gunshot"
@onready var mainView := $"../mainView"
@onready var collision_shape := $CollisionShape2D
@onready var health_bar := $UI/HealthBar
@onready var hurt_box := $HurtBox

const ENEMY_DAMAGE := 6.0
const MAX_HEALTH := 5.0

var is_alive := true
var knockback := Vector2(1,1)
var health := 5.0
var is_melee_enemy_hurting := false

@export var borderOffset = 200

signal end_game


func _ready() -> void:
	health_bar.max_value = MAX_HEALTH


func _physics_process(delta: float) -> void:
	# Didn't clutter up the _physics_process() function.
	handle_weapon_holder_rotation()
	mouse_click()
	handle_player_alive_state()
	handle_player_alive_status()
	handle_player_health(delta)


func handle_weapon_holder_rotation() -> void:
	# This line of code makes the weapon look at the position of the mouse on the screen enabling the player to aim.
	weapon_holder.look_at(get_global_mouse_position())


func move_player() -> void:
	var direction: Vector2 = Vector2.LEFT.rotated(weapon_holder.rotation) * 400.0

	apply_central_impulse(knockback * direction)


func mouse_click() -> void:
	if Input.is_action_just_pressed("left_click") and is_alive == true:
		# Code to execute when left mouse button is clicked
		shotSfx.play()
		gun.shoot_bullet("player")
		move_player()
		
		
func handle_player_health(delta: float) -> void:
	health_bar.value = health
	
	if is_melee_enemy_hurting:
		health -= ENEMY_DAMAGE * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# This kills the player if it gets out the screen.
	is_alive = false
	
	
func handle_player_alive_state() -> void:
	if is_alive == false:
		hide()
		end_game.emit()
		
		
func handle_player_alive_status() -> void:
	if health <= 0:
		is_alive = false


func _on_hurt_box_body_entered(body: Node2D) -> void:
	# Detects the enemy entering the player's hurt box.
	if body.is_in_group("enemy"):
		is_melee_enemy_hurting = true


func _on_hurt_box_body_exited(body: Node2D) -> void:
	# Detects the enemy exiting the player's hurt box.
	if body.is_in_group("enemy"):
		is_melee_enemy_hurting = false
