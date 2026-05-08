@tool
extends EditorScript

const SOURCE_DIR: String = "res://assests/gltf"
const OUTPUT_PATH = "res://resources/meshlibs/tiles.meshlib"


func list_files_recursive(path: String, file_list: Array[String]):
    var dir = DirAccess.open(path)
    if dir:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            if dir.current_is_dir():
                var subfolder_path = path.path_join(file_name)
                list_files_recursive(subfolder_path, file_list)
            else:
                file_list.append(path.path_join(file_name))
            file_name = dir.get_next()
    else:
        print("An error occurred when trying to access the path: ", path)
    return


func _run() -> void:
    print("Begin to export gltfs to meshlib")
    process_dir(SOURCE_DIR)
    print("Export completed.")
    return


func process_dir(source_dir: String) -> void:
    var mesh_lib = MeshLibrary.new()
    var item_id: int = mesh_lib.get_item_list().size()
    var all_files: Array[String] = []
    list_files_recursive(source_dir, all_files)
    for file: String in all_files:
        if not file.ends_with(".gltf"):
            continue
        print("Processing %d: %s" % [item_id, file])
        process_gltf(file, mesh_lib, item_id, file)
        item_id += 1
    save(mesh_lib, OUTPUT_PATH)
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


func save(mesh_lib: MeshLibrary, dst_path: String) -> void:
    var error = ResourceSaver.save(mesh_lib, dst_path)
    if error == OK:
        print("Successfully exported MeshLibrary to: ", dst_path)
    else:
        print("Error saving MeshLibrary: ", error)
