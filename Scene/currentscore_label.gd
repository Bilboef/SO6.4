extends RichTextLabel

var default_text = "Score: "
 

func _process(delta):
	var text = str(default_text, str(Global.current_score))
	self.text = (text)
	
	
