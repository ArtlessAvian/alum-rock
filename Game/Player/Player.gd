extends PhysicsBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980
const MAX_FLOOR_ANGLE = 45

var velocity: Vector2 = Vector2.ZERO
var _state = GroundedState.new()
var state_time = 0
var ignore_ledges = 0
var ground_normal = Vector2.UP;

@onready var _previous_position: Vector2 = global_position

func _physics_process(delta):
	_state.physics_process(self, delta)
	state_time += 1
	
	move_and_slide(velocity * delta)
	
	$SlideoffCheck.force_raycast_update()
	if !$SlideoffCheck.is_colliding():
		_state.on_slideoff(self)
	
	if ignore_ledges <= 0 and velocity.y >= 0 and $RightLedgebox.has_overlapping_areas():
		if not _state is LedgeGrabState:
			set_state(LedgeGrabState.new())
			var thing = $RightLedgebox.get_overlapping_areas()[0]
			self.global_position = thing.global_position - $RightLedgebox.position
		
	if ignore_ledges <= 0 and velocity.y >= 0 and $LeftLedgebox.has_overlapping_areas():
		if not _state is LedgeGrabState:
			set_state(LedgeGrabState.new())
			var thing = $LeftLedgebox.get_overlapping_areas()[0]
			self.global_position = thing.global_position - $LeftLedgebox.position
	
	ignore_ledges -= 1
		
	_previous_position = global_position
	
	var arrow = $Visuals/DebugStuff/LargeObnoxiousArrow
	arrow.scale = Vector2.ONE * max(1, sqrt(velocity.length()))
	arrow.target_position = velocity / arrow.scale

func move_and_slide(vec):
	for i in range(4):
		$LeftLow.disabled = vec.x > 0
		$LeftHigh.disabled = vec.x > 0
		$RightLow.disabled = vec.x < 0
		$RightHigh.disabled = vec.x < 0
		$Head.disabled = vec.y > 0

		var collision: KinematicCollision2D = move_and_collide(vec)
		if collision == null:
			return
		
		if vec.y >= 0 and collision.get_local_shape() == $GroundCheck and collision.get_angle() < PI/4:
			_state.on_touch_ground(self, collision)
			return
		
		# don't actually affect velocity, but affect sliding.
		if collision.get_local_shape() in [$LeftLow, $LeftHigh, $RightLow, $RightHigh]:
			vec.x = 0
			
		if collision.get_local_shape() in [$Head]:
			vec.y = 0

func set_state(new_state):
	if _state.has_method("exit"):
		_state.exit(self)
	_state = new_state
	if _state.has_method("enter"):
		_state.enter(self)
	
	state_time = 0
