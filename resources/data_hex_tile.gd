extends Resource

class_name DataHexTile

@export var mesh_name: String = ""
@export var mesh: Mesh = null
@export var max_count: int = 1000


func setup(meshlib: MeshLibrary, _mesh_name: String, _max_count: int = 1000) -> void:
    mesh_name = _mesh_name
    var mesh_id: int = meshlib.find_item_by_name(_mesh_name)
    if mesh_id != -1:
        mesh = meshlib.get_item_mesh(mesh_id)
    else:
        print("Mesh not found: ", mesh_name)
    max_count = _max_count
    return
