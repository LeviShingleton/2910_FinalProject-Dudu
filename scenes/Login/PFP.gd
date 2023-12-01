extends Panel

var PFP = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Search PFP path for other images
func dir_contents(path):
	var dir = DirAccess.open("res://data/Customization/PFP/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.ends_with(".png" || file_name.ends_with(".jpeg")):
					
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
