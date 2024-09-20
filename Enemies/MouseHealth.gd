extends TextureProgressBar

@export var mouse: EnemyMouse


func _input(event):
	mouse.healthChanged
	update()


func update():
	value = mouse.currentHP * 100 / mouse.maxHP
