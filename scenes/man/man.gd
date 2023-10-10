extends CharacterBody2D

@onready var cam = $PlayerCamera
var realVelocity = Vector2.ZERO
var zoom_step = 0.5

const SPEED = 120.0
const ACELERATED_SPEED = 200.0
const JUMP_VELOCITY = -400.0
const max_cam_dist = 100.0
const max_mouse_radius = 500.0

## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta: float) -> void:
	var mouse_position = get_local_mouse_position()
	cam.position = lerp(Vector2(),mouse_position.normalized() * max_cam_dist, mouse_position.length() / max_mouse_radius)
	look_at(get_global_mouse_position())


func _physics_process(delta):
	MovementLoop()
	move_and_slide()

func MovementLoop() -> void:
	var direction_y := Input.get_axis("up", "down")
	var direction_x := Input.get_axis("left", "right")
	
	var isRunning = Input.is_action_pressed("run");
	var currentSpeed = SPEED;
	
	if (isRunning): 
		currentSpeed = ACELERATED_SPEED
	else:
		currentSpeed = SPEED;
	
	velocity = Vector2(direction_x, direction_y).normalized() * currentSpeed
	
	realVelocity = get_real_velocity()
	
	if (realVelocity != Vector2.ZERO):
		$AnimatedSprite2D.play("walk")
	else: 
		$AnimatedSprite2D.play("idle")
	
	
func changeCameraZoom(zoom_step: float) -> void:
	$PlayerCamera.zoom.x += zoom_step;
	$PlayerCamera.zoom.y += zoom_step;

func _input(event):
	if event.is_action_pressed("zoom_in"):
		changeCameraZoom(zoom_step)
	if event.is_action_pressed("zoom_out"):
		changeCameraZoom(-zoom_step)

#
		


