extends Panel

var PFP = []
# Called when the node enters the scene tree for the first time.
func _ready():
	LoginEvents.OnLoginCompleted.connect(self.dir_contents)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Search PFP path for other images
func dir_contents():
	var dir = DirAccess.open("res://data/Customization/PFP/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.ends_with(".png") || file_name.ends_with(".jpg"):
					PFP.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	for pfp in PFP:
		var id = -1
		var icon = load("res://data/Customization/PFP/ico/ico_%s" % pfp)
		$OptionButton.add_icon_item(icon, pfp.erase(len(pfp)-4, 4), ++id)

func _On_PFP_Option_Set(index):
	LoginEvents.emit_signal("OnPFPChanged", PFP[index])
