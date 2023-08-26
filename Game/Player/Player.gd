extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980

var state = GroundedState.new()
var ground_normal = Vector2.UP;

@onready var _previous_position: Vector2 = global_position

func _physics_process(delta):
	state.physics_process(self, delta)
	
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		if collision.get_local_shape() == $GroundCheck:
			# state.on_touch_ground()
			print("landed")
			state = GroundedState.new()
			ground_normal = collision.get_normal()
	
	$SlideoffCheck.force_raycast_update()
	if !$SlideoffCheck.is_colliding():
		state = FallState.new()
		# state.on_slideoff
	
	if velocity.y > 0 and $RightLedgebox.has_overlapping_areas():
		state = LedgeGrabState.new()
	
	_previous_position = global_position
	
