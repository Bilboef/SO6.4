extends TextureProgressBar

@export var slime_green: SlimeGreen


func _input(event):
	slime_green.healthChanged_green
	update()

func update():
	value = slime_green.currentHP * 100 / slime_green.maxHP
