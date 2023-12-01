extends Control

var dbURL = "http://localhost:80%s"

# Credentials
var c_UN = ""
var c_PW = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	
	# response code 200 -> successful login
	if response_code != 200:
		# Convert output body to JSON format
		var json = JSON.new()
		var error = json.parse(output)
		
		if error == OK:
			# Retrieve data from json: string or dictionary
			var data_received = json.data
			$Panel/PanelContainer/MarginContainer/VBoxContainer/ErrorRect.show()
			$Panel/PanelContainer/MarginContainer/VBoxContainer/ErrorRect/Label.text = data_received["detail"]
			
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", output, " at line ", json.get_error_line())
	else:
		$".".hide()

##### UI Events #####
func _OnUsernameEntered(new_text):
	c_UN = new_text

func _OnPasswordEntered(new_text):
	c_PW = new_text

func _on_btn_login_pressed():
	if (c_UN != "" && c_PW != ""):
		var loginURL = dbURL % "/user/" + str(c_UN)
		var headers = ["Content-Type: application/json"]
		var data = JsonConvertCreds()
		var log_string = "Login attempt via %s using %s"
		print(log_string % [loginURL, data])
		$HTTP_Login.request(loginURL, headers, HTTPClient.METHOD_GET, data)

func _on_btn_register_pressed():
	if (c_UN != "" && c_PW != ""):
		var registerURL = dbURL % "/user"
		var headers = ["Content-Type: application/json"]
		var data = JsonConvertCreds()
		var log_string = "Register attempt via %s using %s"
		print(log_string % [registerURL, data])
		var resultCode = $HTTP_Login.request(registerURL, headers, HTTPClient.METHOD_POST, data)
		
func _on_http_test_pressed():
#	var URL : String = "https://official-joke-api.appspot.com/random_joke"
	var testURL = dbURL % "/count"
	var headers = ["Content-Type: application/json"]
	var log_string = "Test attempt via %s"
	print(log_string % testURL)
	var resultCode = $HTTP_Login.request(testURL, headers, HTTPClient.METHOD_GET)
##### UI EVENTS #####	

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		$PanelContainer/MarginContainer/VBoxContainer/ErrorRect.hide()
		$".".show()
