extends Path2D

# Array of enemy scenes to spawn
@onready var timer = $Timer
@onready var enemies: Array[PackedScene] = [
	preload("res://scenes/enemy_gunman.tscn"),  # Agent.
	preload("res://scenes/enemy.tscn"),  # Boar
]

var rng = RandomNumberGenerator.new()
var WAVE_SIZE_INCREMENTER := 5.5  # Incrementer for wave size
var wave_number := 1  # Current wave number
var wavePhase = 0  # Current wave phase
var costs = [4, 2]  # Costs of spawning each enemy type
var numOfEnemies = 0  # Number of enemies currently alive
var spawnPoints = []  # Array of spawn points
var randomOffset = 0  # Random offset for spawn points
var allEnemiesAlive = []  # Array of all alive enemies
var enemyoffset = 0  # Offset for enemy count in each wave
var spawnSide = 0  # Side to spawn enemies

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	allEnemiesAlive = get_tree().get_nodes_in_group("enemy")
	numOfEnemies = allEnemiesAlive.size() - 1
	print(numOfEnemies)

	# If wave phase is 1 and there are no enemies alive, start the next wave
	if wavePhase == 1 and numOfEnemies == 0:
		next_wave()
		timer.start()
		await timer.timeout

	# If wave phase is 0, spawn a wave of enemies
	elif wavePhase == 0:
		spawn_wave()

func choose_spawn_point():
	spawnSide = rng.randi_range(0, 3)  # Choose a random side to spawn enemies
	randomOffset = rng.randf_range(-1000, 2500)  # Generate a random offset for spawn points
	spawnPoints = [
		Vector2(randomOffset, -1000),  # Top spawn point
		Vector2(3000, randomOffset),  # Right spawn point
		Vector2(randomOffset, 1800),  # Bottom spawn point
		Vector2(-1300, randomOffset),  # Left spawn point
	]

func spawn_wave():
	enemyoffset = rng.randi_range(-1, 1)  # Random offset for enemy count in each wave
	var points = ceil((WAVE_SIZE_INCREMENTER * wave_number + enemyoffset))
	print(wave_number)

	while points > 0:
		var enemy = rng.randi_range(0, enemies.size() - 1)  # Choose a random enemy type to spawn

		# If enemy type is Agent and there are enough points, spawn an Agent enemy
		if enemy == 0 and (points - costs[enemy] >= 0):
			choose_spawn_point()
			print("Spawning Agent")
			var new_enemy = enemies[enemy].instantiate()
			new_enemy.add_to_group("enemy")
			new_enemy.position = spawnPoints[spawnSide]
			get_tree().get_root().add_child(new_enemy)
			points -= costs[enemy]
			print(points, "points")

		# If enemy type is Boar and there are enough points, spawn a Boar enemy
		elif enemy == 1 and (points - costs[enemy] >= 0):
			choose_spawn_point()
			print("Spawning Boar")
			var new_boar = enemies[enemy].instantiate()
			new_boar.add_to_group("enemy")
			new_boar.position = spawnPoints[spawnSide]
			get_tree().get_root().add_child(new_boar)
			points -= costs[enemy]
			print(points, "points")

		else:
			print("Not enough points")
			break

	wavePhase += 1
	print(wave_number)

func next_wave():
	print("Next Wave")
	wave_number += 1

	# If there are no enemies alive, decrement the wave phase
	if numOfEnemies == 0:
		wavePhase -= 1
