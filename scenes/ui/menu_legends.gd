extends ScrollContainer

class_name MenuLegends

@export var scene_legend: PackedScene
@onready var center_container: CenterContainer = $CenterContainer
@onready var color_rect: ColorRect = $CenterContainer/ColorRect
@onready var grid_legends: GridContainer = $CenterContainer/GridLegends


func setup(manager_hextile: Dictionary[String, HexTile]) -> void:
    for hextile_name: String in manager_hextile.keys():
        if not hextile_name.begins_with("hex_"):
            continue

        var hextile: HexTile = manager_hextile[hextile_name]
        var legend_hextile: LegendHextile = scene_legend.instantiate()
        legend_hextile.setup(hextile)
        grid_legends.add_child(legend_hextile)
    color_rect.custom_minimum_size.y = grid_legends.get_minimum_size().y * 1.02
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_menu"):
        visible = !visible
    elif event.is_action_pressed("camera_zoom_in") and visible:
        accept_event()
    elif event.is_action_pressed("camera_zoom_out") and visible:
        accept_event()
    return
