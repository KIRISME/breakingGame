extends CharacterBody2D

@onready var target = $"../Player"

var speed = 10000

# Trail settings
var trail_points: Array[Vector2] = []
@export var trail_length := 1500

func _physics_process(delta):

	var direction = (target.position - position).normalized()

	velocity = direction * speed * delta * 60

	look_at(target.position)

	move_and_slide()

	# Add current position to trail
	trail_points.append(global_position)

	if trail_points.size() > trail_length:
		trail_points.pop_front()

	queue_redraw()


func _draw():

	for i in range(trail_points.size() - 1):

		var alpha := 1.0 + (float(i) / trail_points.size())
		var color := Color(1, 0, 0, alpha)

		draw_line(
			to_local(trail_points[i]),
			to_local(trail_points[i + 1]),
			color,
			4.0
		)
