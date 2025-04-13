extends Node

@export var mob_scene: PackedScene
var score = 0

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_node("Player").show()
	get_tree().paused = false
	get_node("Player").position = Vector2(400, 300)  # Ajusta esta posición según sea necesario

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	print("StartTimer hizo timeout")  # Agregá esto para probar
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	print("generando mobs ")
	var mob = mob_scene.instantiate()
	print("Posición del mob: ", mob.position)
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
# Posición del centro (ajustá si no es exactamente ese punto)
	var center = Vector2(400, 300)
	var to_center = (center - mob.position).normalized()

# Aplicamos una pequeña variación aleatoria al vector
	var angle_offset = randf_range(-PI / 8, PI / 8)
	var final_direction = to_center.rotated(angle_offset)

# Asignamos la dirección como rotación y la velocidad
	mob.rotation = final_direction.angle()
	var speed = randf_range(150.0, 250.0)
	mob.linear_velocity = final_direction * speed

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
