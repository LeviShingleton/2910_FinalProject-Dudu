extends Control

func _ready():
	pass

func _btn_quit():
	_doQuit()

func _input(event):
	if Input.is_action_pressed("Escape"):
		_doQuit()

func _doQuit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _reload_current_scene():
	get_tree().reload_current_scene()

func _on_btn_logout_pressed():
	_reload_current_scene()

func _on_btn_delete_account_pressed():
	#print("Delete")
	LoginEvents.OnDeleteAccount.emit()
