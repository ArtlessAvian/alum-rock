extends RefCounted
class_name FallState

func physics_process(player: Player, delta):
	if Input.is_action_pressed("ui_accept"):
		player.velocity.y += player.GRAVITY * delta
	else:
		player.velocity.y += player.GRAVITY * delta * 2
	
	if Input.is_action_just_pressed("dash"):
		player.set_state(DashState.new());
		return
	
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		# if youre already faster than speed, keep the speed.
		var accel = 100 if player.velocity.x * direction <= Player.SPEED else 25
		player.velocity.x = move_toward(player.velocity.x, direction * Player.SPEED, accel)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, 100)

func on_touch_ground(player: Player, collision: KinematicCollision2D):
	player.set_state(GroundedState.new())
	player.ground_normal = collision.get_normal()
	player.velocity.y = 0
	player.velocity = player.velocity.slide(player.ground_normal)

func on_slideoff(player: Player):
	pass
