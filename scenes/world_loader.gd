extends Node

class_name WorldLoader

const SAVE_PATH = "user://world.tres"

@export var meshlib: MeshLibrary
@onready var tiles: Node = $Tiles

var manager_hextile: Dictionary[String, HexTile] = { }
var data_world: DataWorld = null
var xz_plane_y: float = 0.0


func _ready() -> void:
    setup_manager_hextile()
    setup_world(load_world())
    return


func setup_manager_hextile() -> void:
    if meshlib == null:
        return

    var ids: PackedInt32Array = meshlib.get_item_list()
    for id: int in ids:
        var item_name: String = meshlib.get_item_name(id)
        var data: DataHexTile = DataHexTile.new()
        data.setup(meshlib, item_name)

        var hextile: HexTile = HexTile.new()
        hextile.data = data
        manager_hextile[item_name] = hextile
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
