extends TextureRect

class_name LegendHextile

var hextile: HexTile = null


func setup(_hextile: HexTile) -> void:
    hextile = _hextile
    texture = Utils.get_hextile_snapshot(hextile)
    return


func _get_drag_data(_at_position: Vector2) -> Variant:
    # set preview
    var preview: TextureRect = TextureRect.new()
    preview.custom_minimum_size = Vector2(128, 128)
    preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    preview.texture = texture

    # set preview container
    var preivew_container: Control = Control.new()
    preivew_container.add_child(preview)
    preview.position = -0.5 * preview.custom_minimum_size
    set_drag_preview(preivew_container)

    return {
        "hextile": hextile,
    }
