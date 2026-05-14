extends Button

class_name ButtonTool

var hextile: HexTile = null

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var label: Label = $Label


func setup(_hextile: HexTile) -> void:
    hextile = _hextile.duplicate() as HexTile
    label.text = hextile.data.mesh_name.substr(4)
    var sample_mesh: MeshInstance3D = MeshInstance3D.new()
    sample_mesh.mesh = hextile.data.mesh
    sub_viewport.add_child(sample_mesh)

    var tw: Tween = create_tween()
    tw.set_loops()
    tw.tween_property(sample_mesh, "rotation_degrees:y", 360.0, 10).from(0.0)
    return
