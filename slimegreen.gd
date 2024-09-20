extends CharacterBody2D

class_name SlimeGreen

signal healthChanged_green

@export var speed = 20
@export var limit = 0.5
@export var endPoint: Marker2D
@export var pointkill = 2

@onready var maxHP = 3
@onready var currentHP = maxHP
@onready var animations = $AnimationPlayer
@onready var hurtTimer = $hurtTimer
@onready var hideHurtBox = $hurtBox/CollisionShape2D

var startPosition
var endPosition

var isHurt: bool= false

var isDead: bool = false

func _ready():
	startPosition = position
	endPosition = endPoint.global_position
	healthChanged_green.emit(currentHP)
	

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
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
	
		animations.play("walk" + direction)

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var 	collider = collision.get_collider()

func _physics_process(delta: float) -> void:
	if isDead: return
	updateVelocity()
	move_and_slide()
	handleCollision()
	updateAnimation()
	if isHurt == true:
		disable()
	if isHurt == false:
		enable()
	


func enable():
	hideHurtBox.disabled = false

func disable():
	hideHurtBox.disabled = true

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area == $hitBox: return
	currentHP -= 1
	healthChanged_green.emit(currentHP)
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
		$Sprite.visible = false
		animations.play("death")
		await animations.animation_finished
		queue_free()
