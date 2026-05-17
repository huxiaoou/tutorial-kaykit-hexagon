extends Button

class_name ButtonTool

var hextile: HexTile = null

@onready var label: Label = $Label
@onready var label_shortcut: Label = $LabelShortcut

signal hextile_activated(hextile: HexTile)
signal hextile_deactivated(hextile: HexTile)
signal button_updated(button: ButtonTool)

var activated: bool = false


func setup(_hextile: HexTile, _shortcut: Shortcut) -> void:
    setup_hextile(_hextile)
    setup_shortcut(_shortcut)
    return


func setup_hextile(_hextile: HexTile) -> void:
    hextile = _hextile
    icon = Utils.get_hextile_snapshot(hextile)
    label.text = hextile.data.mesh_name.substr(4)
    return


func setup_shortcut(_shortcut: Shortcut) -> void:
    shortcut = _shortcut
    if shortcut and not shortcut.events.is_empty():
        var first_event: InputEvent = shortcut.events[0]
        label_shortcut.text = first_event.as_text()
    else:
        label_shortcut.text = ""
    return


func _on_pressed() -> void:
    if activated:
        activated = false
        hextile_deactivated.emit(hextile)
    else:
        if hextile:
            activated = true
            hextile_activated.emit(hextile)
        else:
            print("No hextile assigned to this button!")
    return


func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
    if _data is Dictionary:
        if _data.get("hextile", null) is HexTile:
            return true
    return false


func _drop_data(_at_position: Vector2, _data: Variant) -> void:
    if activated:
        print("Tile deactivated: %s" % hextile.data.mesh_name)
        activated = false
        hextile_deactivated.emit(hextile)

    print("Tile dropped: %s" % _data["hextile"].data.mesh_name)
    setup_hextile(_data["hextile"])
    button_updated.emit(self)
    return


func reset() -> void:
    hextile = null
    icon = null
    label.text = ""
    activated = false
    return
