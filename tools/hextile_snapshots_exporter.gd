extends Node3D

class_name HexTileSnapshotsExporter

@export var meshlib: MeshLibrary


func _ready() -> void:
    var mgr_hextile: Dictionary[String, HexTile] = Utils.setup_manager_hextile(meshlib)
    print(get_window().size)
    print(get_window().size)
    get_window().size = Vector2i(512, 512)    
    for hextile: HexTile in mgr_hextile.values():
        await get_tree().process_frame
        get_hextile_snapshot(hextile)
    #get_tree().quit()
    return


func get_hextile_snapshot(hextile: HexTile) -> ImageTexture:
    if not hextile.data.mesh_name.begins_with("hex_"):
        return

    var sample_mesh: MeshInstance3D = MeshInstance3D.new()
    sample_mesh.mesh = hextile.data.mesh
    add_child(sample_mesh)

    await RenderingServer.frame_post_draw
    var img_name: String = "res://assests/snapshots/" + hextile.data.mesh_name + ".png"
    get_viewport().get_texture().get_image().save_png(img_name)
    sample_mesh.queue_free()
    print(img_name)
    return
