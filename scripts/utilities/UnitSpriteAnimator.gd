class_name UnitSpriteAnimator
extends AnimationTree


@export var look_toward_angle : float = 0.0:
	set(value):
		look_toward_angle = value
		set_blend_angle(Vector2.from_angle(-value))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
const blendPosPropName := &"parameters/blend_position"	
func set_blend_angle(v: Vector2) -> void:
	set(blendPosPropName, v)		
