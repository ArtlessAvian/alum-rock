extends RefCounted
class_name LedgeGrabState

func physics_process(player: Player, delta):
	player.velocity = Vector2.ZERO
