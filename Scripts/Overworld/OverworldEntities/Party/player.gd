class_name Player 
extends PartyEntity

func _physics_process(delta: float) -> void:
    direction = Input.get_vector("left", "right", "up", "down")
    
    super(delta) # Calling base class method to handle directional movement from the input
