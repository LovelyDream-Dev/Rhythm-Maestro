extends Node
class_name File_Saver

var fileLoader:File_Loader 

func _ready() -> void:
	fileLoader = (get_parent() as Component_Maestro).fileLoader 

func save_tau_data(filePath:String):
	var file = FileAccess.open(filePath, FileAccess.READ)
	if file == null:
		push_error("Could not open .tau file for writing: " + filePath)
		return

	# File format version header
