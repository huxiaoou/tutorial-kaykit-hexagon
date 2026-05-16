extends Button

class_name ButtonTool

var hextile: HexTile = null

@onready var label: Label = $Label
@onready var label_shortcut: Label = $LabelShortcut

signal hextile_activated(hextile: HexTile)
signal hextile_deactivated(hextile: HexTile)

var activated: bool = false


func setup(_hextile: HexTile, _shortcut: Shortcut) -> void:
    hextile = _hextile
    icon = Utils.get_hextile_snapshot(hextile)
    label.text = hextile.data.mesh_name.substr(4)
    setup_shortcut(_shortcut)
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
        activated = true
        hextile_activated.emit(hextile)
    return
