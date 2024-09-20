extends CharacterBody2D

class_name EnemyPanda

signal healthChanged

 
var speed = 20
var player_chase = false
var player = null




@onready var animations = $AnimationPlayer
@onready var maxHP = 5
@onready var currentHP = maxHP

@export var pointkill = 5
@export var endPoint: Marker2D
@export var limit = 0.5
@onready var hurtTimer = $hurtTimer
@onready var hideHurtBox = $hurtBox/CollisionShape2D


var startPosition
var endPosition

var isHurt: bool= false
var isDead: bool = false


func _ready():
	startPosition = position
	endPosition = endPoint.global_position
	healthChanged.emit(currentHP)
	


func _physics_process(delta):
	if isDead: return
	if player_chase and player != null and player.has_method("get_position"):
		#position += (player.position - position).normalized() * speed * delta
		velocity = (player.position - position).normalized() * speed

		if player.position.x > position.x:
			$AnimatedSprite2D.play("Right")
		elif player.position.x < position.x:
			$AnimatedSprite2D.play("Left")
			
		move_and_slide()

	if isHurt == true:
		disable()
	if isHurt == false:
		enable()



func enable():
	hideHurtBox.disabled = false

func disable():
	hideHurtBox.disabled = true


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
	currentHP -= 1
	healthChanged.emit(currentHP)
	isHurt = true
	if isHurt:
		hurtTimer.start() 
		await hurtTimer.timeout
		isHurt = false
	
	if currentHP <= 0:
		isHurt = false
		Global.current_score += pointkill
		$hitBox.set_deferred("monitorable", false)
		isDead = true
		animations.play("Death")
		await animations.animation_finished
		queue_free()





func changeDirection():
	var tempend = endPosition
	endPosition = startPosition
	startPosition = tempend

func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized()*speed	
