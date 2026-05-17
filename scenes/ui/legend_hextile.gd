extends TextureRect

class_name LegendHextile

var hextile: HexTile = null

func setup(_texture: Texture2D, _hextile: HexTile) -> void:
    texture = _texture
    hextile = _hextile
    return
