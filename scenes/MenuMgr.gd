extends Control

func _btn_quit():
	_doQuit()

func _input(event):
	if Input.is_action_pressed("Escape"):
		_doQuit()

func _doQuit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
