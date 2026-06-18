@tool
class_name AnimateableBody extends AnimatedSprite2D

@export_category("Raw Texture Settings")
@export var numDirs : int = 8
@export_tool_button("Make All Animations") var basic = _import_base_directions


@export_category("Animator Tools")
@export var animationLibary: AnimationLibrary
@export var animationTree: AnimationNodeBlendSpace2D
##THIS WILL WIPE YOUR EXISTING LIBARY
@export var setupPlayer : bool = false
##THIS WILL WIPE YOUR EXISTING TREE
@export var setupAnimationTree : bool = false

@export var animation_tree_name : String
@export_tool_button("Make_Tree_For") var tree = _create_tree_for

@export_category("In Game Settings")
var lookDir := Vector2.ZERO

@onready var animationHelper := $AnimationTree as UnitSpriteAnimator

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	animationHelper.look_toward_angle = lookDir.angle() 
	
	

func _import_base_directions() -> void:
	if not Engine.is_editor_hint(): return
	
	if setupPlayer:
		for anim in animationLibary.get_animation_list():
			animationLibary.remove_animation(anim)
		
		for animationName in sprite_frames.get_animation_names():
			if animationName.find("Side") > 0:
				createAnimation(animationName + "_Right", animationName)
				createAnimation(animationName + "_Left", animationName, true)
			else:
				createAnimation(animationName)
		
		
		
func add_blend_animation(animationName: String, dir: int) -> void:
		var angle := (TAU / numDirs) * dir
		var animationRoot = AnimationNodeAnimation.new()
		animationRoot.animation = (animationLibary.resource_path.get_file().get_slice(".",0) +"/"+ animationName)

		var realAngle = Vector2.from_angle(angle)
		realAngle.y *= -1
		animationTree.add_blend_point(animationRoot, realAngle)
		
		
			
func createAnimation(animationName: String, spriteFramesName: String = "", flipped: bool = false) -> void:
	var newAnimation := Animation.new()
	newAnimation.length = 0.1
	var animationTrackIndex := newAnimation.add_track(Animation.TYPE_VALUE)
	newAnimation.track_set_path(animationTrackIndex, NodePath(animationPropPath))
	newAnimation.track_insert_key(animationTrackIndex, 0.0, spriteFramesName if spriteFramesName != "" else animationName)
	var flippedTrackIndex := newAnimation.add_track(Animation.TYPE_VALUE)
	newAnimation.track_set_path(flippedTrackIndex, NodePath(flippedPropPath))
	newAnimation.track_insert_key(flippedTrackIndex, 0.0, flipped)
	
	animationLibary.add_animation(animationName,newAnimation)
	
	
func _create_tree_for() -> void:
	if setupAnimationTree:
		while animationTree.get_blend_point_count() > 0:
			animationTree.remove_blend_point(0)
		
		add_blend_animation(animation_tree_name + "_Side_Right", 0)
		add_blend_animation(animation_tree_name + "_Down_Side_Right", 1)
		add_blend_animation(animation_tree_name + "_Down", 2)
		add_blend_animation(animation_tree_name + "_Down_Side_Left", 3)
		add_blend_animation(animation_tree_name + "_Side_Left", 4)
		add_blend_animation(animation_tree_name + "_Up_Side_Left", 5)
		add_blend_animation(animation_tree_name + "_Up", 6)
		add_blend_animation(animation_tree_name + "_Up_Side_Right", 7)


const animationPropPath = ".:animation"
const flippedPropPath = ".:flip_h"
