extends TextureProgressBar

@export var slime: SlimeBlue


func _input(event):
	slime.healthChanged
	update()

func update():
	value = slime.currentHP * 100 / slime.maxHP
