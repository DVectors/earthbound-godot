class_name PartyManager
extends Node2D

@export var follow_spacing := 32.0   # pixels between party members along the trail
@export var min_trail_step := 8.0    # only record a point if the leader moved this far
@export var max_trail_points := 2048 # cap to keep memory in check
@export var snap_distance := 320.0   # if a member is farther than this, warp them

@export var leader : Player
@export var members : Array[PackedScene] = []

var instantiated_members : Array[PartyEntity] = []
var trail: PackedVector2Array = []   # newest at the end

func _ready() -> void:
    if leader != null:
        if not instantiated_members.has(leader):
            instantiated_members.insert(0, leader) # Make sure that the leader is at the initial index position
    
    if members.size() > 0 and members != null:
        for member in members:
            instantiate_member(member)
            
    trail.append(leader.global_position) # Set initial trail point

func instantiate_member(member: PackedScene) -> void:
#    if not is_instance_valid(member) and member != null:
#        var member_instance : Node2D = member.instantiate()
#        member_instance.global_position = leader.global_position
#        add_child(member_instance)

    var member_instance : Node2D = member.instantiate()
    var party_entity_member: Follower = member_instance as Follower
    party_entity_member.global_position = leader.global_position
    add_child(party_entity_member)
    
    instantiated_members.append(party_entity_member)
    
func _physics_process(delta: float) -> void:
    _update_trail()
    _update_member_targets()
    
func _update_trail() -> void:
    # Get leader's position to use as next position or the last position if it exists
    var last := leader.global_position if trail.is_empty() else trail[trail.size() - 1]
    print("last trail position x: " + str(last.x))
    print("last trail position y: " + str(last.y))
    
    if last.distance_to(leader.global_position) >= min_trail_step:
        trail.append(leader.global_position) # Add new trail point
        # pop from front by slicing (PackedVector2Array is cheap to slice)
        trail = trail.slice(trail.size() - max_trail_points, max_trail_points)
        
        
        
func _update_member_targets() -> void:
    for i in range(1, instantiated_members.size()): # First index is player, which does not need to be sorted
        var member: Follower = instantiated_members[i]
        if not is_instance_valid(member):
            continue

        # How far behind the leader should this member be?
        var desired_distance := follow_spacing * i
        var target := _get_point_on_trail(desired_distance)

        # Safety: snap if they fall too far behind (room transitions, cutscenes, etc.)
        if member.global_position.distance_to(leader.global_position) > snap_distance:
            member.global_position = target
            if member is Follower:
                member
                member.velocity = Vector2.ZERO

        if member.has_method("set_follow_target"):
            member.set_follow_target(target)

func _get_point_on_trail(distance_back: float) -> Vector2:
    # Walk the trail from newest -> oldest accumulating distance until we reach the requested offset.
    if trail.is_empty():
        return leader.global_position

    var remaining := distance_back
    var prev := trail[trail.size() - 1]
    for idx in range(trail.size() - 2, -1, -1):
        var curr := trail[idx]
        var seg_len := prev.distance_to(curr)
        if seg_len >= remaining:
            # Interpolate along this segment
            var t := remaining / seg_len
            return prev.lerp(curr, t)
        remaining -= seg_len
        prev = curr
    # If we ran out of trail, just return the oldest point.
    return trail[0]

#func _snap_member_to_target(node: Node2D) -> void:
#    var idx := members.find(node)
#    if idx <= 0:
#        return
#    var target := _get_point_on_trail(follow_spacing * idx)
#    node.global_position = target
