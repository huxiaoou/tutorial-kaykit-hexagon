extends Camera3D

var speed: float = 10


func _physics_process(delta: float) -> void:
    var direction: Vector2 = Input.get_vector(
        "unit_move_left",
        "unit_move_right",
        "unit_move_foward",
        "unit_move_backward",
    )
    var move_vec: Vector3 = Vector3(direction.x, 0, direction.y) * speed * delta
    global_position += move_vec
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("camera_zoom_in"):
        translate_object_local(Vector3(0, 0, -speed * 0.1))
    elif event.is_action_pressed("camera_zoom_out"):
        translate_object_local(Vector3(0, 0, speed * 0.1))
    return
