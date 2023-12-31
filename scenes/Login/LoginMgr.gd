extends Control

# Credentials
var c_UN = ""
var c_PW = ""

signal login_completed(UserProfile)

# Called when the node enters the scene tree for the first time.
func _ready():
	LoginEvents.OnDeleteAccount.connect(_OnDeleteAccount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func JsonConvertCreds() -> String:
		var data_to_send = {"PassHash": c_PW, "UserName": c_UN}
		var json_string = JSON.stringify(data_to_send)
		return json_string

func HTTP_Request(result, response_code, headers, body):
	$Panel/PanelContainer/MarginContainer/VBoxContainer/ErrorRect.hide()
	var format_string = "Result: %s\nResponse Code: %s\nHeaders: %s \nOutput: %s"
	var output = body.get_string_from_utf8()
	print(format_string % [result, response_code, headers, output])
	
	# Convert output body to JSON format
	var json = JSON.new()
	var error = json.parse(output)
	var data_received
	if error == OK:
		# Retrieve data from json: string or dictionary
		data_received = json.data
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", output, " at line ", json.get_error_line())
	
	print("Data Received Parsed: %s" % data_received)
	
	# response code 200 -> successful login
	if response_code != 200:
		$Panel/PanelContainer/MarginContainer/VBoxContainer/ErrorRect.show()
		$Panel/PanelContainer/MarginContainer/VBoxContainer/ErrorRect/Label.text = data_received["detail"]
	else:
		if !data_received.has("message"):
			LoginEvents.User = UserProfile.new(data_received)
			_LoginComplete()
		elif data_received.has("message"):
			LoginEvents.Reset()
			get_tree().reload_current_scene()

##### UI Events #####
func _OnUsernameEntered(new_text):
	c_UN = new_text

func _OnPasswordEntered(new_text):
	c_PW = new_text

func _on_btn_login_pressed():
	if (c_UN != "" && c_PW != ""):
		var loginURL = LoginEvents.dbURL % "/user/" + str(c_UN)
		var headers = ["Content-Type: application/json"]
		var data = JsonConvertCreds()
		var log_string = "Login attempt via %s using %s"
		print(log_string % [loginURL, data])
		$"../HTTP_Login".request(loginURL, headers, HTTPClient.METHOD_GET, data)

func _on_btn_register_pressed():
	if (c_UN != "" && c_PW != ""):
		var registerURL = LoginEvents.dbURL % "/user"
		var headers = ["Content-Type: application/json"]
		var data = JsonConvertCreds()
		var log_string = "Register attempt via %s using %s"
		print(log_string % [registerURL, data])
		$"../HTTP_Login".request(registerURL, headers, HTTPClient.METHOD_POST, data)
		
func _on_http_test_pressed():
#	var URL : String = "https://official-joke-api.appspot.com/random_joke"
	var testURL = LoginEvents.dbURL % "/count"
	var headers = ["Content-Type: application/json"]
	var log_string = "Test attempt via %s"
	print(log_string % testURL)
	$HTTP_Login.request(testURL, headers, HTTPClient.METHOD_GET)
##### UI EVENTS #####

func _LoginComplete():
	LoginEvents.OnLoginCompleted.emit()
	$Panel/PanelContainer/MarginContainer/VBoxContainer/ErrorRect/Label.text = ""
	$".".hide()
	
func _OnDeleteAccount():
	if (c_UN != "" && c_PW != ""):
		var deleteURL = LoginEvents.dbURL % "/user/%s" % LoginEvents.User.userName
		var headers = ["Content-Type: application/json"]
		var data = JsonConvertCreds()
		var log_string = "Delete attempt via %s using %s"
		print(log_string % [deleteURL, data])
		$"../HTTP_Login".request(deleteURL, headers, HTTPClient.METHOD_DELETE, data)

func ResetUI():
	$Panel/PanelContainer/MarginContainer/VBoxContainer/ErrorRect.hide()
	$Panel/PanelContainer/MarginContainer/VBoxContainer/ErrorRect/Label.text = ""
	$Panel/PanelContainer/MarginContainer/VBoxContainer/LE_Username.text = ""
	$Panel/PanelContainer/MarginContainer/VBoxContainer/LE_Password.text = ""
	$".".show()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		ResetUI()
