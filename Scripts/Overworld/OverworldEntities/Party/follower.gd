class_name Follower
extends PartyEntity

var _has_target := false
var _target := Vector2.ZERO

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
    
    direction = _target - global_position
#    if to_target.length() > stop_radius:
#        velocity = to_target.normalized() * move_speed
#    else:
#        velocity = Vector2.ZERO