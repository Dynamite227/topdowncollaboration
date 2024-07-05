extends Path2D

@onready var spawn_point: PathFollow2D = $SpawnPoint
@onready var enemies: Array[PackedScene] = [
	preload("res://scenes/enemy_gunman.tscn"),			# Agent.
	preload("res://scenes/enemy.tscn"),					# Boar.
	preload("res://scenes/wolf.tscn"),					#wolf.
	preload("res://scenes/rifleman.tscn"),				#rifleman.
	preload("res://scenes/bear.tscn")
]

@export var multiplier = 2.5

var wave_number := 1
var enemies_group
var easy_group: Array[PackedScene]
var med_group: Array[PackedScene]
var hard_group: Array[PackedScene]
@export var hardRate = 15
@export var medRate = 30
@export var easyRate = 55
func _ready() -> void:
	for i in enemies:
		if i.instantiate().is_in_group("easy"):
			easy_group.append(i)
		elif i.instantiate().is_in_group("medium"):
			med_group.append(i)
		elif i.instantiate().is_in_group("hard"):
			hard_group.append(i)


func _process(_delta: float) -> void:
	enemies_group = get_tree().get_nodes_in_group("enemy")
	
	if enemies_group.size() <= 0:
		for i in range(ceil(wave_number * multiplier)):
			spawn_enemies()
			
		wave_number += 1


func spawn_enemies() -> void:
	var random_enemy: CharacterBody2D
	var random_number := randi_range(0, 100)
	
	if random_number >= 0 and random_number <= hardRate:
		random_enemy = hard_group.pick_random().instantiate()
	elif random_number >= ( hardRate + 1) and random_number <= (medRate + hardRate):
		random_enemy = med_group.pick_random().instantiate()
	elif random_number >= ( medRate + hardRate + 1) and random_number <= (easyRate + hardRate + medRate):
		random_enemy = easy_group.pick_random().instantiate()
	
	spawn_point.progress_ratio = randf()
	spawn_point.h_offset = -500
	spawn_point.v_offset = -500
	random_enemy.global_position = spawn_point.global_position
	
	add_child(random_enemy)
