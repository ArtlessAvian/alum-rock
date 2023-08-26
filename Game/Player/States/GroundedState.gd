extends RefCounted
class_name GroundedState

func physics_process(player: Player, delta):
	if Input.is_action_just_pressed("ui_accept"):
		player.velocity.y = Player.JUMP_VELOCITY
		player.state = FallState.new();
		return

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		var ground_parallel = Vector2(-player.ground_normal.y, player.ground_normal.x)
		player.velocity = ground_parallel * direction * Player.SPEED
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, Player.SPEED)
