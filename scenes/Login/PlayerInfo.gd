extends Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	LoginEvents.OnLoginCompleted.connect(self._OnLogin)
	LoginEvents.OnPFPChanged.connect(self.LoadPFP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _OnLogin():
	$PFP/TextureRect.texture = load("res://data/Customization/PFP/%s" % LoginEvents.User.PFP)
	$LE_DisplayName.text = LoginEvents.User.DisplayName

func LoadPFP(pfpName: String):
	$PFP/TextureRect.texture = load("res://data/Customization/PFP/%s" % pfpName)
	LoginEvents.User.PFP = pfpName

func _on_Save():
	if len($LE_DisplayName.text.strip_edges(true,true)) > 0: 
		LoginEvents.User.DisplayName = $LE_DisplayName.text
		
	
	var putURL = LoginEvents.dbURL % "/user/" + str(LoginEvents.User.userName)
	var headers = ["Content-Type: application/json"]
	var ProfileData = LoginEvents.JsonConvertUserProfile()
	print("Patch attempt via %s using %s" % [putURL, ProfileData])
	$"../../../HTTP_Login".request(putURL, headers, HTTPClient.METHOD_PATCH, ProfileData)

#func _on_btn_login_pressed():
#	if (c_UN != "" && c_PW != ""):
#		var loginURL = LoginEvents.dbURL % "/user/" + str(c_UN)
#		var headers = ["Content-Type: application/json"]
#		var data = JsonConvertCreds()
#		var log_string = "Login attempt via %s using %s"
#		print(log_string % [loginURL, data])
#		$"../HTTP_Login".request(loginURL, headers, HTTPClient.METHOD_GET, data)
