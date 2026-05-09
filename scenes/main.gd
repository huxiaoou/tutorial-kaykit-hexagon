extends Node3D

class_name main

var meshlib:MeshLibrary = null
var hextile: HexTile = null


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
        print("Clicked at ", pos)
        hextile.add_instance_at(pos + Vector3(0, 1, 0))        
