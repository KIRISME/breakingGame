extends Sprite2D

@onready var player = $"../../Player"
@onready var goal = $"../../Goal"

func _process(delta):
	var direction = goal.global_position - player.global_position
	rotation = direction.angle()
