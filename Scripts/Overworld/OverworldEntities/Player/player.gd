class_name Player 
extends CharacterBody2D

## Export vars
@export var speed: float = 125.0
@export var animation_tree : AnimationTree

var input : Vector2
var playback : AnimationNodeStateMachinePlayback

func _ready() -> void:
    playback = animation_tree["parameters/playback"]

func _physics_process(delta: float) -> void:
    input = Input.get_vector("left", "right", "up", "down")
    
    velocity = input * speed
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
    if input == Vector2.ZERO:
        return
        
    animation_tree["parameters/Idle/blend_position"] = input
    animation_tree["parameters/Walk/blend_position"] = input
