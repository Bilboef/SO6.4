extends CharacterBody2D


var speed = 20
var player_chase = false
var player = null

var isDead: bool = false

func _physics_process(delta):
	if isDead: return
	if player_chase and player != null and player.has_method("get_position"):
		#position += (player.position - position).normalized() * speed * delta
		velocity = (player.position - position).normalized() * speed

		print(velocity)
		if player.position.x > position.x:
			$AnimatedSprite2D.play("Right")
		elif player.position.x < position.x:
			$AnimatedSprite2D.play("Left")
			
		move_and_slide()



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


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area == $hitBox: return
	isDead = true
	queue_free()
	$AnimatedSprite2D.play("Death")
 	#if $AnimatedSprite2D.animation_finished("Death"):
		
	
