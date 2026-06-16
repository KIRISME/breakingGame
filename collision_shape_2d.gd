extends CollisionShape2D

func _ready():
	while true:
		visible = false
		disabled = true
		
		await get_tree().create_timer(0.01).timeout
		
		visible = true
		disabled = false
		
		await get_tree().create_timer(0.5).timeout
