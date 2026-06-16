# Enemy.gd
# Attach to a CharacterBody2D enemy

extends CharacterBody2D

@export var target_path: NodePath
@export var max_speed := 300.0
@export var acceleration := 900.0
@export var friction := 10.0
@export var stop_distance := 12.0

var target: Node2D

# Trail settings
var trail_points: Array[Vector2] = []
@export var trail_length := 20

func _ready():
	target = get_node(target_path)

func _physics_process(delta):
	if target == null:
		return

	# Direction toward player
	var direction = global_position.direction_to(target.global_position)
	var distance = global_position.distance_to(target.global_position)

	# Move toward player
	if distance > stop_distance:
		velocity = velocity.move_toward(
			direction * max_speed,
			acceleration * delta
		)
	else:
		# Slow down when close
		velocity = velocity.move_toward(
			Vector2.ZERO,
			friction * delta
		)

	move_and_slide()

	# Store trail positions
	trail_points.append(global_position)

	# Keep trail limited
	if trail_points.size() > trail_length:
		trail_points.pop_front()

	queue_redraw()

func _draw():
	# Draw fading trail
	for i in range(trail_points.size() - 1):
		var alpha := float(i) / trail_points.size()
		var color := Color(1.0, 0.2, 0.2, alpha)

		draw_line(
			to_local(trail_points[i]),
			to_local(trail_points[i + 1]),
			color,
			3.0
		)
