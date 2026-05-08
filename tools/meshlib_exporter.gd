@tool
extends EditorScript

const SOURCE_DIR = "res://assests/gltf/tiles/base/"
const OUTPUT_PATH = "res://resources/meshlibs/tiles.meshlib"


func _run() -> void:
    print("Begin to export gltfs to meshlib")
    print("Source dir: ", SOURCE_DIR)
    var mesh_lib = MeshLibrary.new()
    process_dir(SOURCE_DIR, mesh_lib)
    save(mesh_lib)
    print("Export completed.")
    return


func process_dir(source_dir: String, mesh_lib: MeshLibrary) -> void:
    var dir = DirAccess.open(source_dir)
    if dir:
        var item_id: int = 0
        var files: PackedStringArray = dir.get_files()
        for file: String in files:
            if not file.ends_with(".gltf"):
                continue
            var path = source_dir + file
            print("Processing: ", path)
            process_gltf(path, mesh_lib, item_id, file)
            item_id += 1
    else:
        print("Error: Failed to open directory ", source_dir)
    return


func process_gltf(path: String, lib: MeshLibrary, id: int, original_name: String):
    var scene = load(path).instantiate()
    var mesh_node: MeshInstance3D = find_mesh_node(scene)
    if mesh_node and mesh_node.mesh:
        lib.create_item(id)
        lib.set_item_name(id, original_name.get_basename())
        lib.set_item_mesh(id, mesh_node.mesh)
    scene.free()
    return


func find_mesh_node(node: Node) -> MeshInstance3D:
    if node is MeshInstance3D:
        return node
    for child in node.get_children():
        var found = find_mesh_node(child)
        if found:
            return found
    return null


func save(mesh_lib: MeshLibrary) -> void:
    var error = ResourceSaver.save(mesh_lib, OUTPUT_PATH)
    if error == OK:
        print("Successfully exported MeshLibrary to: ", OUTPUT_PATH)
    else:
        print("Error saving MeshLibrary: ", error)
