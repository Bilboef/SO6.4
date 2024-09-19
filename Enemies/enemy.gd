extends CharacterBody2D


var speed = 20
var player_chase = false
var player = null


signal healthChanged

@onready var animations = $AnimationPlayer
@onready var maxHP = 2
@onready var currentHP = maxHP
@export var endPoint: Marker2D
@export var limit = 0.5

var startPosition
var endPosition

var isDead: bool = false

func _physics_process(delta):
	if isDead: return
	if player_chase and player != null and player.has_method("get_position"):
		#position += (player.position - position).normalized() * speed * delta
		velocity = (player.position - position).normalized() * speed

		#print(velocity)
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
	animations.play("Death")
	await animations.animation_finished
	queue_free()



func _ready():
	startPosition = position
	endPosition = endPoint.global_position
	healthChanged.emit(currentHP)
	

func changeDirection():
	var tempend = endPosition
	endPosition = startPosition
	startPosition = tempend

func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized()*speed	

func updateAnimation():
	if velocity.length()==0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "Forward"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Back"
	
		animations.play("Forward" + direction)
