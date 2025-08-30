class_name PartyEntity
extends CharacterBody2D

## Export vars
@export var speed: float = 125.0
@export var animation_tree : AnimationTree
@export var skin_manager : SkinManager
@export var default_skin_id : StringName = &"default"

var direction : Vector2
var playback : AnimationNodeStateMachinePlayback

func _ready() -> void:
    playback = animation_tree["parameters/playback"]

    # Apply default skin
    skin_manager.set_skins() # Sets up skin dictionary, making it easier for looking up specific skins
    skin_manager.apply_skin(default_skin_id)

func _physics_process(delta: float) -> void:
    velocity = direction * speed
    move_and_slide()

    ## Updating animation
    select_animation()
    update_animation_parameters()

func select_animation() -> void:
    if velocity == Vector2.ZERO:
        playback.travel("Idle")
    else:
        playback.travel("Walk")

func update_animation_parameters() -> void:
    if direction == Vector2.ZERO:
        return

    animation_tree["parameters/Idle/blend_position"] = direction
    animation_tree["parameters/Walk/blend_position"] = direction
    

