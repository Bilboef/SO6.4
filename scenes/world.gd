extends BaseScene

#@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var camera = $Player/follow_cam

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	camera.follow_node = player
	
	#heartsContainer.setMaxHearts(player.maxHealth)
	#heartsContainer.updateHearts(player.currentHealth)
	#player.healthChanged.connect(heartsContainer.updateHearts)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_score()
	pass


func _on_inventory_gui_closed() -> void:
	get_tree().paused = false 


func _on_inventory_gui_opened() -> void:
	get_tree().paused = true

func update_score():
	Global.previous_score = Global.current_score
	if Global.current_score > Global.high_score:
		Global.high_score = Global.current_score
	#Global.current_score = 0
