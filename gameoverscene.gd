extends RichTextLabel

var default_text = "End score: "

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var text = str(default_text, str(Global.current_score))
	self.text = (text)
