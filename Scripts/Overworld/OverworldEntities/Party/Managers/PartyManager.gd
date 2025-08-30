class_name PartyManager
extends Node2D

@export var follow_spacing := 32.0   # pixels between party members along the trail
@export var min_trail_step := 8.0    # only record a point if the leader moved this far
@export var max_trail_points := 2048 # cap to keep memory in check
@export var snap_distance := 320.0   # if a member is farther than this, warp them

@export var leader : Player
@export var members : Array[PackedScene] = []

var trail: PackedVector2Array = []   # newest at the end

func _ready() -> void:
#    if leader != null:
#        if not members.has(leader):
#            members.insert(0, leader) # Make sure that the leader is at the initial index position
    
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
    member_instance.global_position = leader.global_position
    add_child(member_instance)
