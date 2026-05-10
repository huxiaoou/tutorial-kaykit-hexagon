extends Sprite3D

class_name Cursor

signal curr_hex_tile_changed(new_coords: Vector2i)

var curr_point: Vector3 = Vector3.ZERO
var curr_hex_tile_coords: Vector2i = Vector2i.ZERO


func _ready() -> void:
    curr_hex_tile_changed.connect(update_pos_from_hex_coords)
    return


func update_pos_from_hex_coords(hex_coords: Vector2i) -> void:
    var hex_center_pos: Vector3 = ManagerHextileCoords.hex_coordinates_to_point(
        hex_coords,
        global_position.y,
    )
    global_position = hex_center_pos
    return


func update_curr_hex_from_cursor() -> void:
    var new_point: Vector3 = ManagerHextileCoords.get_xz_projection()
    if new_point == Vector3.INF:
        return
    var new_hex_tile_coords: Vector2i = ManagerHextileCoords.point_to_hex_coordinates(new_point)
    if new_hex_tile_coords != curr_hex_tile_coords:
        curr_hex_tile_coords = new_hex_tile_coords
        curr_hex_tile_changed.emit(curr_hex_tile_coords)
    return


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        update_curr_hex_from_cursor()
