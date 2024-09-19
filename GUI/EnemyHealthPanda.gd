extends TextureProgressBar

@export var panda: EnemyPanda


func _input(event):
	panda.healthChanged
	update()


func update():
	value = panda.currentHP * 100 / panda.maxHP
