extends CharacterBody2D

class_name Player

signal healthChanged

@export var speed: int = 35
@export var run_speed: int = 70
@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var hurtBox = $hurtBox
@onready var hurtTimer = $hurtTimer
@onready var weapon = $weapon

@export var maxHealth = 3
@onready var currentHealth: int = maxHealth

@export var knockBackPower: int = 500

@export var inventory: Inventory

var lastAnimDirection: String = "Down"
var isHurt: bool = false
var isAttacking: bool = false

func _ready() -> void:
	effects.play("RESET")
	weapon.visible = false

func handleInput():
	var moveDirection = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	if Input.is_action_just_pressed("run") == true:
		print("true")
		velocity = moveDirection * run_speed
	elif Input.is_action_just_pressed("run") != true:
		velocity = moveDirection * speed


func attack(): 
	animations.play("attack"+lastAnimDirection)
	isAttacking= true
	weapon.enable()
	await animations.animation_finished
	weapon.disable()
	isAttacking=false

func updateAnimation():
	if isAttacking: return
	
	if velocity.length()==0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
	
		animations.play("walk" + direction)
		lastAnimDirection = direction


func _physics_process(delta):
	handleInput()
	move_and_slide()
	updateAnimation()
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitBox":
				hurtByEnemy(area)

func hurtByEnemy(area):
	currentHealth -=1
	if currentHealth < 0:
		currentHealth = maxHealth
		
	healthChanged.emit(currentHealth)
	isHurt = true
		
	knockBack(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt=false 

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.has_method("collect"):
		area.collect(inventory)


		
		
func knockBack(enemyVelocity: Vector2):
	var knockBackDirection = (enemyVelocity - velocity).normalized()*knockBackPower
	velocity = knockBackDirection
	move_and_slide()


func _on_hurt_box_area_exited(area: Area2D) -> void:
	pass
