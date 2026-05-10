extends Node3D

class_name Main

var meshlib: MeshLibrary = null
var hextile: HexTile = null
var records: Dictionary[Vector2i, bool] = { }


func _ready() -> void:
    meshlib = load("res://resources/meshlibs/tiles.meshlib") as MeshLibrary
    var data: DataHexTile = DataHexTile.new()
    data.setup(meshlib, "hex_grass")
    hextile = HexTile.new()
    hextile.data = data
    add_child(hextile)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("place_hex_tile"):
        var pos: Vector3 = ManagerHextileCoords.get_xz_projection()
        var hextile_coords: Vector2i = ManagerHextileCoords.point_to_hex_coordinates(pos)
        if records.get(hextile_coords, false):
            print("Hex tile already exists at ", hextile_coords)
            return
        records[hextile_coords] = true
        var hextile_point: Vector3 = ManagerHextileCoords.hex_coordinates_to_point(hextile_coords)
        print("Clicked at ", pos)
        hextile.add_instance_at(hextile_point + Vector3(0, 1, 0))
        return
