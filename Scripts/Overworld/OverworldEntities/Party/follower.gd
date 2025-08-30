class_name Follower
extends PartyEntity

var _has_target := false
var _target := Vector2.ZERO

@export var stop_radius := 6.0       # don't jitter at the target

func set_follow_target(point: Vector2) -> void:
    _has_target = true
    _target = point

func _physics_process(delta: float) -> void:
    print("follower velocity x: " + str(velocity.x))
    print("follower velocity y: " + str(velocity.y))
    _follower_move()
    super(delta)

func _follower_move() -> void:
    if !_has_target:
        velocity = Vector2.ZERO
        return
    
    var to_target := _target - global_position
    if to_target.length() > stop_radius:
        direction = to_target.normalized()
    else:
        direction = Vector2.ZERO
        