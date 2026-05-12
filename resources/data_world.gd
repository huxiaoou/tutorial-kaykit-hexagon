extends Resource

class_name DataWorld

@export var manager_records: Dictionary[Vector2i, DataHexTileRecord] = { }


func match_coords(data_record: DataHexTileRecord) -> Vector2i:
    for coords in manager_records.keys():
        if manager_records[coords].is_equal(data_record):
            return coords
    return Vector2.INF
