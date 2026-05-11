extends Node

class_name WorldEditor

@export var meshlib: MeshLibrary

@onready var cursor: Cursor = $Cursor
@onready var tiles: Node = $Tiles

var manager_hextile: Dictionary[String, HexTile] = { }
var selected_hextile: HexTile = null
var records: Dictionary[Vector2i, bool] = { }


func _ready() -> void:
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


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("place_hex_tile"):
        if selected_hextile == null:
            print("No hextile selected!")
            return
        if selected_hextile.preview_activated:
            selected_hextile.deactivate_preview()
            _place_hextile()
            selected_hextile.activate_preview()
    elif event.is_action_pressed("debug_increase"):
        _select_random_hexltile()
        selected_hextile.activate_preview()
    elif event.is_action_pressed("debug_decrease"):
        _deselect_and_deactivate_preview()
    return


func _place_hextile() -> void:
    var hextile_coords: Vector2i = cursor.curr_hex_tile_coords
    if records.get(hextile_coords, false):
        print("Hex tile already exists at ", hextile_coords)
        return

    var hextile_point: Vector3 = cursor.curr_point
    selected_hextile.add_instance_at(hextile_point + Vector3(0, 1, 0))
    print("Clicked at %s, place %s hextile at %s" % [hextile_point, selected_hextile.data.mesh_name, hextile_coords])
    records[hextile_coords] = true
    return


func _select_random_hexltile() -> void:
    if selected_hextile != null:
        print("A hextile is already selected!")
        return

    var hextile_names: Array[String] = manager_hextile.keys()
    if hextile_names.is_empty():
        print("No hextiles available in manager!")
        return

    var hextile_name: String = hextile_names.pick_random()
    selected_hextile = manager_hextile[hextile_name]
    print("Selected hextile: ", hextile_name)
    return


func _deselect_and_deactivate_preview() -> void:
    if selected_hextile == null:
        print("No hextile is currently selected!")
        return
    if selected_hextile.preview_activated:
        selected_hextile.deactivate_preview()
    print("Deselected hextile: ", selected_hextile.data.mesh_name)
    selected_hextile = null
    return


func _process(_delta: float) -> void:
    if selected_hextile != null:
        selected_hextile.update_preview(cursor.curr_point + Vector3(0, 1, 0))
    return
