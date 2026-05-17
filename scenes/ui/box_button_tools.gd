extends HBoxContainer

class_name BoxButtonTools

const SHORTCUTS_DIR: String = "res://resources/shortcuts/"

var max_buttons: int = 10


func setup(manager_hextile: Dictionary[String, HexTile]) -> void:
    var scene_button_tool: PackedScene = preload("res://scenes/ui/button_tool.tscn")
    var count: int = 0
    for hextile in manager_hextile.values():
        if not hextile.data.mesh_name.begins_with("hex_"):
            continue

        var button_tool: ButtonTool = scene_button_tool.instantiate()
        add_child(button_tool)
        var shortcut_path: String = SHORTCUTS_DIR + "btn_" + str((count + 1) % 10) + ".tres"
        var shortcut: Shortcut = ResourceLoader.load(shortcut_path)
        button_tool.setup(hextile, shortcut)
        button_tool.button_updated.connect(on_button_updated)
        count += 1
        if count >= max_buttons:
            break
    return


func get_button_tools() -> Array[ButtonTool]:
    var button_tools: Array[ButtonTool] = []
    for child in get_children():
        if child is ButtonTool:
            button_tools.append(child)
    return button_tools


func deactivate_hextile_button(hextile: HexTile) -> void:
    for button_tool in get_button_tools():
        if button_tool.hextile == hextile:
            button_tool.activated = false
            return


func on_button_updated(button: ButtonTool) -> void:
    for button_tool in get_button_tools():
        if button_tool != button and button_tool.hextile == button.hextile:
            button_tool.reset()
    return
