extends Node

# const HEXTILE_SNAPSHOTS_DIR: String = "res://assests/snapshots/"


func setup_manager_hextile(meshlib: MeshLibrary) -> Dictionary[String, HexTile]:
    if meshlib == null:
        return { }

    var manager_hextile: Dictionary[String, HexTile] = { }
    var ids: PackedInt32Array = meshlib.get_item_list()
    for id: int in ids:
        var item_name: String = meshlib.get_item_name(id)
        var data: DataHexTile = DataHexTile.new()
        data.setup(meshlib, item_name)

        var hextile: HexTile = HexTile.new()
        hextile.data = data
        manager_hextile[item_name] = hextile
    return manager_hextile


func get_hextile_snapshot(hextile: HexTile) -> Texture2D:
    var snapshot_path: String = Config.DIR_SNAPSHOTS + hextile.data.mesh_name + ".png"
    if ResourceLoader.exists(snapshot_path):
        var snapshot: Texture2D = ResourceLoader.load(snapshot_path) as Texture2D
        return snapshot
    print("Snapshot not found for hextile: ", snapshot_path)
    return null
