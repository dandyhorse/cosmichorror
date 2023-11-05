extends CharacterBody2D


@onready var cam = $PlayerCamera
@onready var legs = $Rotator/AnimatedSprite2D
@onready var rotator = $Rotator
var realVelocity = Vector2.ZERO
var zoom_step = 0.5

const SPEED = 120.0
const CROUCH_SPEED = 30.0
const ACELERATED_SPEED = 200.0
const JUMP_VELOCITY = -400.0
const max_cam_dist = 170.0
const max_mouse_radius = 600.0
const rotation_speed = 10.0
const min_rotation = -0.5
const max_rotation = 0.5


## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta: float) -> void:
	var mouse_position = get_local_mouse_position()
	cam.position = lerp(Vector2(),mouse_position.normalized() * max_cam_dist, mouse_position.length() / max_mouse_radius)
	look_at(get_global_mouse_position())


func _physics_process(delta):
	
	print(get_global_mouse_position())
	MovementLoop(delta)
	move_and_slide()

func MovementLoop(delta) -> void:
	var currentSpeed = SPEED;
	var direction_y := Input.get_axis("up", "down")
	var direction_x := Input.get_axis("left", "right")
	var isRunning = Input.is_action_pressed("run");
	var isCrouching = Input.is_action_pressed("crouch");	
	var isMoving = realVelocity != Vector2.ZERO;
	print()
	
	match true:
		isRunning:
			currentSpeed = ACELERATED_SPEED
		isCrouching:
			currentSpeed = CROUCH_SPEED
			
		_:
			currentSpeed = SPEED;

	velocity = Vector2(direction_x, direction_y).normalized() * currentSpeed
	
	realVelocity = get_real_velocity()
	
	legs.play("walk")
	if (realVelocity != Vector2.ZERO):
		legs.play("walk")
	else: 
		legs.play("idle")

# Legs Rotation: 
	var rotation = 0.0

	if Input.is_action_pressed("left"):
		rotation = -rotation_speed
	elif Input.is_action_pressed("right"):
		rotation = rotation_speed

	rotator.rotation += rotation * delta

	if rotator.rotation < min_rotation:
		rotator.rotation = min_rotation
	elif rotator.rotation > max_rotation:
		rotator.rotation = max_rotation

	if rotation == 0.0:
		rotator.rotation = 0.0
	
	
func changeCameraZoom(zoom_step: float) -> void:
	$PlayerCamera.zoom.x += zoom_step;
	$PlayerCamera.zoom.y += zoom_step;

func _input(event):
	if event.is_action_pressed("zoom_in"):
		changeCameraZoom(zoom_step)
	if event.is_action_pressed("zoom_out"):
		changeCameraZoom(-zoom_step)

#
		


