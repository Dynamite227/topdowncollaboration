extends Node2D

@onready var main_menu := $MainMenu
@onready var enemy_spawner := $Spawner


func _ready() -> void:
	main_menu.hide()


func _on_player_end_game() -> void:
	main_menu.label.text = "stand tall farmer, you stood your ground for " + str(enemy_spawner.wave_number) + " rounds."
	main_menu.visible = true
