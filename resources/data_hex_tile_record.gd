extends Resource

class_name DataHexTileRecord

@export var mesh_name: String = ""
@export var id: int = -1


func is_equal(other: DataHexTileRecord) -> bool:
    return mesh_name == other.mesh_name and id == other.id
