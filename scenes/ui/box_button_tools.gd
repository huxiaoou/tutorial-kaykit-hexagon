extends HBoxContainer

class_name BoxButtonTools

var max_buttons: int = 10


func setup(manager_hextile: Dictionary[String, HexTile]) -> void:
    var scene_button_tool: PackedScene = preload("res://scenes/ui/button_tool.tscn")
    var count: int = 0
    for hextile in manager_hextile.values():
        if not hextile.data.mesh_name.begins_with("hex_"):
            continue

        var button_tool: ButtonTool = scene_button_tool.instantiate()
        add_child(button_tool)
        button_tool.setup(hextile)
        count += 1
        if count >= max_buttons:
            break
    return
