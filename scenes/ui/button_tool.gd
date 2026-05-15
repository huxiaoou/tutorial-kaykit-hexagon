extends Button

class_name ButtonTool

var hextile: HexTile = null

@onready var label: Label = $Label


func setup(_hextile: HexTile) -> void:
    hextile = _hextile
    label.text = hextile.data.mesh_name.substr(4)
    icon = Utils.get_hextile_snapshot(hextile)
    return
