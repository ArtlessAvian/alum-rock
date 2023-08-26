extends RefCounted
class_name GroundedState

func enter(player: Player):
	print("enter")
	player.get_node("GroundCheck").disabled = true

func exit(player: Player):
	print("exit")
	player.get_node("GroundCheck").disabled = false

func physics_process(player: Player, delta):
	
	if Input.is_action_just_pressed("ui_accept"):
		player.velocity.y = Player.JUMP_VELOCITY
		player.set_state(FallState.new());
		return

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		var ground_parallel = Vector2(-player.ground_normal.y, player.ground_normal.x)
		var parallel_component = ground_parallel.dot(player.velocity)
		var target = move_toward(parallel_component, direction * Player.SPEED, 10)
		player.velocity = target * ground_parallel
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, 10)

func on_touch_ground(player: Player, collision: KinematicCollision2D):
	player.ground_normal = collision.get_normal()
	player.velocity = player.velocity.slide(player.ground_normal)

func on_slideoff(player: Player):
	var ray: RayCast2D = player.get_node("SnapToFloorCheck");

	if !ray.is_colliding():
		# this should never happen, since slideoff check should be reporting something here.
		player.set_state(FallState.new())
		return

	var old_collision = ray.get_collision_point()

	ray.force_raycast_update()
	if !ray.is_colliding():
		# teeter?
		print("teeter?")
		player.set_state(FallState.new())
		return
	
	# slide along new floor
	var ground_parallel = Vector2(-player.ground_normal.y, player.ground_normal.x)
	var parallel_component = ground_parallel.dot(player.velocity)
	
	player.ground_normal = ray.get_collision_normal()
	ground_parallel = Vector2(-player.ground_normal.y, player.ground_normal.x)
	player.velocity = parallel_component * ground_parallel
	
	player.global_position.y = ray.get_collision_point().y
