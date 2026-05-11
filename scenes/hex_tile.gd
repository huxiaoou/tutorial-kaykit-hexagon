extends MultiMeshInstance3D

class_name HexTile

@export var data: DataHexTile = null

var preview_activated: bool = false
var static_body: StaticBody3D = null


func _ready() -> void:
    if not data:
        print("HexTile: No data assigned!")
        return

    if multimesh == null:
        multimesh = MultiMesh.new()
        multimesh.transform_format = MultiMesh.TRANSFORM_3D
    var lib_mesh: Mesh = data.mesh
    if not lib_mesh:
        print("HexTile: No mesh found in data!")
        return

    multimesh.mesh = lib_mesh.duplicate()
    multimesh.use_colors = true
    multimesh.instance_count = data.max_count
    multimesh.visible_instance_count = 0

    var material: StandardMaterial3D = null
    for i: int in range(multimesh.mesh.get_surface_count()):
        material = multimesh.mesh.surface_get_material(i).duplicate(true)
        material.vertex_color_use_as_albedo = true
        material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
        material.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_ALWAYS
        multimesh.mesh.surface_set_material(i, material)

    static_body = StaticBody3D.new()
    add_child(static_body)
    return


func activate_preview() -> void:
    if preview_activated:
        return

    preview_activated = true
    multimesh.visible_instance_count += 1
    multimesh.set_instance_color(
        multimesh.visible_instance_count - 1,
        Color(1.0, 1.0, 1.0, 0.2),
    )
    return


func update_last_instance_pos(pos: Vector3) -> void:
    var mesh_idx: int = multimesh.visible_instance_count - 1
    var xform: Transform3D = Transform3D(Basis(), pos)
    multimesh.set_instance_transform(mesh_idx, xform)
    return


func update_preview(pos: Vector3) -> void:
    if not preview_activated:
        return
    update_last_instance_pos(pos)
    return


func deactivate_preview() -> void:
    if not preview_activated:
        return

    multimesh.set_instance_color(
        multimesh.visible_instance_count - 1,
        Color(1.0, 1.0, 1.0, 1.0),
    )
    multimesh.visible_instance_count -= 1
    preview_activated = false
    return


func add_collision_at(pos: Vector3) -> void:
    var collision_node = CollisionShape3D.new()
    var xform: Transform3D = Transform3D(Basis(), pos)
    collision_node.shape = multimesh.mesh.create_trimesh_shape()
    collision_node.transform = xform
    collision_node.scale = xform.basis.get_scale()
    static_body.add_child(collision_node)
    return


func get_new_added_data_record() -> DataHexTileRecord:
    var data_record: DataHexTileRecord = DataHexTileRecord.new()
    data_record.mesh_name = data.mesh_name
    data_record.id = multimesh.visible_instance_count - 1
    return data_record


func add_instance_at(pos: Vector3) -> DataHexTileRecord:
    multimesh.visible_instance_count += 1
    multimesh.set_instance_color(
        multimesh.visible_instance_count - 1,
        Color(1.0, 1.0, 1.0, 1.0),
    )
    update_last_instance_pos(pos)
    add_collision_at(pos)
    return get_new_added_data_record()


func remove_instance_from_index(mesh_idx: int) -> DataHexTileRecord:
    if preview_activated:
        print("Cannot remove instance while preview is active!")
        return null

    var last_idx: int = multimesh.visible_instance_count - 1
    var last_xform: Transform3D = multimesh.get_instance_transform(last_idx)
    multimesh.set_instance_transform(mesh_idx, last_xform)
    multimesh.visible_instance_count -= 1

    static_body.get_child(mesh_idx).transform = static_body.get_child(last_idx).transform
    static_body.get_child(last_idx).queue_free()

    var data_to_remove: DataHexTileRecord = DataHexTileRecord.new()
    data_to_remove.mesh_name = data.mesh_name
    data_to_remove.id = last_idx
    return data_to_remove
