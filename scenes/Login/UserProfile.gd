class_name UserProfile
extends Node

var userName: String
var userPw
var PFP: String
var DisplayName: String = userName

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _init(json_dict):
	userName = json_dict["UserName"]
	userPw = json_dict["PassHash"]
	PFP = json_dict["ImageURL"]
	DisplayName = json_dict["DisplayName"]
