extends RefCounted
class_name GroundedState

func physics_process(player: Player, delta):
	player.get_node("GroundCheck").disabled = true
	
	if Input.is_action_just_pressed("ui_accept"):
		player.velocity.y = Player.JUMP_VELOCITY
		player.get_node("GroundCheck").disabled = false
		player.state = FallState.new();
		return

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		var ground_parallel = Vector2(-player.ground_normal.y, player.ground_normal.x)
		var parallel_component = ground_parallel.dot(player.velocity)
		var target = move_toward(parallel_component, direction * Player.SPEED, 10)
		player.velocity += (target - parallel_component) * ground_parallel
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, 10)

func on_touch_ground(player: Player, collision: KinematicCollision2D):
	player.ground_normal = collision.get_normal()
	player.velocity = player.velocity.slide(player.ground_normal)
