extends RefCounted
class_name FallState

func physics_process(player: Player, delta):
	if Input.is_action_pressed("ui_accept"):
		player.velocity.y += player.GRAVITY * delta
	else:
		player.velocity.y += player.GRAVITY * delta * 2
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		player.velocity.x = move_toward(player.velocity.x, direction * Player.SPEED, 100)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, Player.SPEED)

func on_touch_ground(player: Player, collision: KinematicCollision2D):
	player.set_state(GroundedState.new())
	player.ground_normal = collision.get_normal()
	player.velocity.y = 0
	player.velocity = player.velocity.slide(player.ground_normal)

func on_slideoff(player: Player):
	pass
