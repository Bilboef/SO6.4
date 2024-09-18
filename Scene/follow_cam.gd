extends Camera2D

@export var tilemap: TileMap 

func _ready() -> void:
	# Hvis tilemap ikke er tildelt, find den som et barn
	if tilemap == null:
		tilemap = $TileMap  # Erstat $TileMap med den korrekte sti til din TileMap node

	if tilemap != null:
		var mapRect = tilemap.get_used_rect()
		var tileSize = tilemap.rendering_quadrant_size
		var worldSizeInPixels = mapRect.size * tileSize
		limit_left = 0
		limit_top = 0
		limit_right = worldSizeInPixels.x
		limit_bottom = worldSizeInPixels.y
	else:
		print("Tilemap er ikke tildelt!")

func _process(delta: float) -> void:
	pass
