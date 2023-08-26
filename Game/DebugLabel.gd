extends Label

@export var path = NodePath(".");
@export var property: StringName = "global_position"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = str(get_node(path).get(property))
