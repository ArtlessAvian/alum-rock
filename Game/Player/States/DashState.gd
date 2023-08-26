extends RefCounted
class_name DashState

const DASH_SPEED = 1500;
const DASH_DECEL = 100;

var dir: Vector2
var grounded = false

func enter(player: Player):
	dir = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	dir = dir.normalized()
	player.velocity = dir * DASH_SPEED

func physics_process(player: Player, delta):
	var speed = max(0, DASH_SPEED - DASH_DECEL * player.state_time)
	player.velocity *= (speed) / max(1, player.velocity.length())

	if Input.is_action_just_pressed("dash"):
		player.set_state(DashState.new());
		return
	
	if player.state_time >= 3 and grounded:
		player.set_state(GroundedState.new())
	if player.state_time >= 15 and !grounded:
		player.set_state(FallState.new())
			

func on_touch_ground(player: Player, collision: KinematicCollision2D):
	player.ground_normal = collision.get_normal()
	player.velocity = player.velocity.slide(player.ground_normal)
	grounded = true

func on_slideoff(player: Player):
	pass
