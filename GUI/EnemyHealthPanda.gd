extends TextureProgressBar

@export var panda: EnemyPanda


func _input(event):
	print('health ch')
	panda.healthChanged
	update()


func update():
	value = panda.currentHP * 100 / panda.maxHP
