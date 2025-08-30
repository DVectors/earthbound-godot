class_name SkinManager
extends Node

@export var sprite_2d : Sprite2D
@export var skins_library : SkinLibrary

var skins_dict : Dictionary = {}
    
func set_skins() -> void:
    _rebuild_index()

func _rebuild_index() -> void:
    skins_dict.clear() # Clears if dictionary was already in use
	
    for skin in skins_library.skins:
        if skin and skin.id != StringName():
            if skins_dict.has(skin.id):
                push_warning("Duplicate skin id: %s" % skin.id)
            skins_dict[skin.id] = skin
    
func apply_skin(skin_id : StringName) -> void:
    if skins_library == null:
        return
    
    if skins_dict.has(skin_id):
        var skin : SkinData = skins_dict[skin_id]
    
        # Applying sprite details from SkinData resource to Sprite2D
        if sprite_2d.texture != null:
            sprite_2d.texture = skin.texture
            sprite_2d.hframes = skin.hframes
            sprite_2d.vframes = skin.vframes
    else:
        push_warning("Invalid skin id: %s" % skin_id)
        
        return
