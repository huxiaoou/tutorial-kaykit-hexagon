extends Node

class_name WorldEditor

const SAVE_PATH = "user://world.tres"

@export var meshlib: MeshLibrary

@onready var cursor: Cursor = $Cursor
@onready var tiles: Node = $Tiles

var manager_hextile: Dictionary[String, HexTile] = { }
var selected_hextile: HexTile = null
var data_world: DataWorld = null


func _ready() -> void:
    setup_manager_hextile()
    data_world = DataWorld.new()
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


func match_hextile(data_record: DataHexTileRecord) -> HexTile:
    for hextile in manager_hextile.values():
        if hextile.data.mesh_name == data_record.mesh_name:
            return hextile
    return null


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("place_hex_tile"):
        if selected_hextile:
            selected_hextile.deactivate_preview()
            _place_hextile()
            selected_hextile.activate_preview()
        else:
            print("No hextile selected!")
    elif event.is_action_pressed("delete_hex_tile"):
        if selected_hextile:
            print("Cannot delete hex tile while a hextile is selected! Deselect first.")
            return
        _delete_hextile()

    elif event.is_action_pressed("debug_increase"):
        if selected_hextile == null:
            _select_random_hexltile()
            selected_hextile.activate_preview()
        else:
            print("Hex tile already selected: ", selected_hextile.data.mesh_name)
    elif event.is_action_pressed("debug_decrease"):
        if selected_hextile:
            selected_hextile.deactivate_preview()
            _deselect_hextile()
        else:
            print("No hextile selected to deselect!")
    elif event.is_action_pressed("save_world"):
        save_world()
    return


func _place_hextile() -> void:
    var hextile_coords: Vector2i = cursor.curr_hex_tile_coords
    if data_world.manager_records.get(hextile_coords, null):
        print("Hex tile already exists at ", hextile_coords)
        return

    var hextile_point: Vector3 = cursor.curr_point
    data_world.manager_records[hextile_coords] = selected_hextile.add_instance_at(hextile_point + Vector3(0, 1, 0))
    print("Clicked at %s, place %s hextile at %s" % [hextile_point, selected_hextile.data.mesh_name, hextile_coords])
    return


func _delete_hextile() -> void:
    var data_record: DataHexTileRecord = data_world.manager_records.get(cursor.curr_hex_tile_coords, null)
    if data_record:
        selected_hextile = match_hextile(data_record)
        if selected_hextile:
            var last_data_record: DataHexTileRecord = selected_hextile.remove_instance_from_index(data_record.id)
            var last_hextile_coords: Vector2i = data_world.match_coords(last_data_record)
            data_world.manager_records[last_hextile_coords] = data_record
            data_world.manager_records.erase(cursor.curr_hex_tile_coords)
            selected_hextile = null
        print("Delete hex tile at ", cursor.curr_hex_tile_coords)
    else:
        print("No hex tile to delete at ", cursor.curr_hex_tile_coords)
    return


func _select_random_hexltile() -> void:
    var hextile_names: Array[String] = manager_hextile.keys()
    if hextile_names.is_empty():
        print("No hextiles available in manager!")
        return

    var hextile_name: String = hextile_names.pick_random()
    selected_hextile = manager_hextile[hextile_name]
    print("Selected hextile: ", hextile_name)
    return


func _deselect_hextile() -> void:
    print("Deselected hextile: ", selected_hextile.data.mesh_name)
    selected_hextile = null
    return


func _process(_delta: float) -> void:
    if selected_hextile != null:
        selected_hextile.update_preview(cursor.curr_point + Vector3(0, 1, 0))
    return


func save_world() -> void:
    var error: int = ResourceSaver.save(data_world, SAVE_PATH)
    if error != OK:
        print("Error saving map: %s" % error)
        return
    print("Map saved successfully.")
    return
