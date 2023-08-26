extends RefCounted
class_name LedgeGrabState

func physics_process(player: Player, delta):
	player.velocity = Vector2.ZERO

func on_touch_ground(player: Player, collision: KinematicCollision2D):
	# huh ok.
	player.state = GroundedState.new()
