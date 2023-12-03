extends Node

signal OnLoginCompleted

var dbURL = "http://localhost:80%s"
var User: UserProfile

signal OnPFPChanged(String)
signal OnDeleteAccount

func Reset():
	User = null

func JsonConvertUserProfile() -> String:
		var data_to_send = {"DisplayName": User.DisplayName,"ImageURL": User.PFP,"PassHash": User.userPw, "UserName": User.userName}
		var json_string = JSON.stringify(data_to_send)
		return json_string	
