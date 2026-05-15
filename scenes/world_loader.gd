extends Node

class_name WorldLoader

const SAVE_PATH = "user://world.tres"

@export var meshlib: MeshLibrary
@onready var tiles: Node = $Tiles

var manager_hextile: Dictionary[String, HexTile] = { }
var data_world: DataWorld = null
var xz_plane_y: float = 0.0


func _ready() -> void:
    manager_hextile = Utils.setup_manager_hextile(meshlib)
    setup_tiles_node()
    setup_world(load_world())
    return


func setup_tiles_node() -> void:
    for hextile: HexTile in manager_hextile.values():
        tiles.add_child(hextile)
    return


func load_world() -> DataWorld:
    if not ResourceLoader.exists(SAVE_PATH):
        print("Error loading map: No resource found at %s" % SAVE_PATH)
        return
    var loaded_resource: Resource = ResourceLoader.load(SAVE_PATH, "DataWorld")
    if loaded_resource == null:
        print("Error loading map: Resource not found at %s" % SAVE_PATH)
        return
    if loaded_resource is not DataWorld:
        print("Error loading map: Resource at %s is not of type DataWorld" % SAVE_PATH)
        return
    print("Map loaded successfully.")
    return loaded_resource as DataWorld


func setup_world(loaded_world_data: DataWorld) -> void:
    data_world = DataWorld.new()
    for cell: Vector2i in loaded_world_data.manager_records.keys():
        var data_record: DataHexTileRecord = loaded_world_data.manager_records[cell]
        var hextile: HexTile = manager_hextile[data_record.mesh_name]
        var pos: Vector3 = ManagerHextileCoords.hex_coordinates_to_point(cell, xz_plane_y)
        var upd_data_record: DataHexTileRecord = hextile.add_instance_at(pos + Vector3(0, 1, 0))
        data_world.manager_records[cell] = upd_data_record
    print("World setup completed")
    return
