extends CharacterBody2D

var speed = 20
var player_chase = false
var player = null


func _physics_process(delta):
	if player_chase and player != null and player.has_method("get_position"):
		position += (player.position - position).normalized() * speed * delta


		if player.position.x > position.x:
			$AnimatedSprite2D.play("Right")
		else:
			$AnimatedSprite2D.play("Left")


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":  
		player = body
		player_chase = true
		



func _on_detection_area_body_exited(body):
	
	if body == player:
		player_chase = false
		player = null
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("Default")
