class_name Follower
extends PartyEntity

var _has_target := false
var _target := Vector2.ZERO

func _physics_process(delta: float) -> void:
    print("follower velocity x: " + str(velocity.x))
    print("follower velocity y: " + str(velocity.y))
    super(delta)