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
		# Save data
		# ...
		# Retrieve data
#		var json = JSON.new()
#		var error = json.parse(json_string)
#		if error == OK:
#			var data_received = json.data
#			if typeof(data_received) == TYPE_ARRAY:
#				print(data_received) # Prints array
#				return json_string
#			else:
#				print("LoginMgr.gd :: JsonCovertLogin :: Unexpected data")
#				return ""
#		else:
#			print("LoginMgr.gd :: JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
#			return ""



##### UI Events #####
func _OnUsernameEntered(new_text):
	c_UN = new_text

func _OnPasswordEntered(new_text):
	c_PW = new_text

func _on_btn_login_pressed():
	if (c_UN != "" && c_PW != ""):
		var loginURL = dbURL % "/user"
		var headers = ["Content-Type: application/json"]
		var data = JsonConvertCreds()
		var log_string = "Login attempt via %s"
		print(log_string % loginURL)
		$HTTP_Login.request(loginURL, headers, HTTPClient.METHOD_GET, JsonConvertCreds())

func _on_btn_register_pressed():
	if (c_UN != "" && c_PW != ""):
		var registerURL = dbURL % "/user"
		var headers = ["Content-Type: application/json"]
		var data = JsonConvertCreds()
		var log_string = "Register attempt via %s using %s"
		print(log_string % [registerURL, data])
		$HTTP_Login.request(registerURL, headers, HTTPClient.METHOD_POST, JsonConvertCreds())
##### UI EVENTS #####	

func _on_http_test_pressed():
#	var URL : String = "https://official-joke-api.appspot.com/random_joke"
	var testURL = dbURL % "/count"
	var headers = ["Content-Type: application/json"]
	var log_string = "Test attempt via %s"
	print(log_string % testURL)
	$HTTP_Login.request(testURL, headers, HTTPClient.METHOD_GET)
	

func HTTP_Request(result, response_code, headers, body):
	
	var format_string = "Result: %s\nResponse Code: %s\nHeaders: %s \n%s"
	var output = body.get_string_from_utf8()
	print(format_string % [result, response_code, headers, output])
# [result, response_code, headers, output]
