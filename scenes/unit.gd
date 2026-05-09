extends CharacterBody3D

class_name Unit

@export var speed: float = 100


func _physics_process(delta: float) -> void:
    var direction: Vector2 = Input.get_vector(
        "unit_move_left",
        "unit_move_right",
        "unit_move_foward",
        "unit_move_backward",
    )
    var _velocity: Vector3 = Vector3(direction.x, 0, direction.y) * speed * delta
    velocity = global_transform.basis * _velocity
    move_and_slide()
    return
