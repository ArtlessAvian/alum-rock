extends RefCounted
class_name LedgeGrabState

func physics_process(player: Player, delta):
	player.velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_accept"):
		player.velocity.y = Player.JUMP_VELOCITY
		player.set_state(FallState.new());
		return

func on_touch_ground(player: Player, collision: KinematicCollision2D):
	# huh ok.
	player.state = GroundedState.new()

func on_slideoff(player: Player):
	pass
