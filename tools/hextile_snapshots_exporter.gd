extends Node3D

class_name HexTileSnapshotsExporter

@export var snapshot_size: Vector2i = Vector2i(512, 512)
@export var meshlib: MeshLibrary = preload("res://resources/meshlibs/tiles.meshlib")
@export var output_folder: String = "res://assests/snapshots/"
@export var camera_position: Vector3 = Vector3(0.0, 2.0, 2.5)

const SNAPHOT_FORMAT: String = "png"

@onready var camera_3d: Camera3D = $Camera3D


func _ready() -> void:
    camera_3d.position = camera_position

    var mgr_hextile: Dictionary[String, HexTile] = Utils.setup_manager_hextile(meshlib)
    print(get_window().size)
    get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
    get_window().size = snapshot_size
    print(get_window().size)
    for hextile: HexTile in mgr_hextile.values():
        await get_tree().process_frame
        get_hextile_snapshot(hextile)
    get_tree().quit()
    return


func get_hextile_snapshot(hextile: HexTile) -> ImageTexture:
    if not hextile.data.mesh_name.begins_with("hex_"):
        return

    var sample_mesh: MeshInstance3D = MeshInstance3D.new()
    sample_mesh.mesh = hextile.data.mesh
    add_child(sample_mesh)

    await RenderingServer.frame_post_draw
    var img_name: String = output_folder + hextile.data.mesh_name + "." + SNAPHOT_FORMAT
    get_viewport().get_texture().get_image().save_png(img_name)
    sample_mesh.queue_free()
    print(img_name)
    return
