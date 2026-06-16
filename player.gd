extends CharacterBody2D

@export var max_speed := 400000.0
@export var acceleration := 10200.0
@export var friction := 10

@export var hit_effect: PackedScene

var input_direction := Vector2.ZERO

# Trail settings
var trail_points: Array[Vector2] = []
@export var trail_length := 20

var can_spawn_effect := true

func _physics_process(delta):

	input_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	# Accelerate
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(
			input_direction * max_speed,
			acceleration * delta
		)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

	# CHECK FOR COLLISIONS
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		spawn_hit_effect(collision.get_position())

	# Add current position to trail
	trail_points.append(global_position)

	if trail_points.size() > trail_length:
		trail_points.pop_front()

	queue_redraw()


func spawn_hit_effect(pos):

	if not can_spawn_effect:
		return

	can_spawn_effect = false

	var effect = hit_effect.instantiate()
	effect.global_position = pos
	get_tree().current_scene.add_child(effect)

	await get_tree().create_timer(0.08).timeout
	can_spawn_effect = true


func _draw():

	for i in range(trail_points.size() - 1):

		var alpha := float(i) / trail_points.size()
		var color := Color(180, 0, 0, alpha)

		draw_line(
			to_local(trail_points[i]),
			to_local(trail_points[i + 1]),
			color,
			4.0
		)
