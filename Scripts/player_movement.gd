extends CharacterBody2D

@export_group("Player Movement")
@export var speed: int = 175  # move speed in pixels/sec
@export var friction = 0.18

@onready var animated_sprite_2d = $AnimatedSprite2D

var last_direction = Direction.DOWN

enum Direction {
	UP,
	DOWN,
	RIGHT,
	LEFT,
	NONE
}

func _ready():
	animated_sprite_2d.play("idle_down")

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	_change_sprite_direction(direction)
	velocity = direction * speed
	move_and_slide()


func _change_sprite_direction(move_direction: Vector2):
	if move_direction.x > 0:
		if last_direction != Direction.RIGHT:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("walk_right")
			last_direction = Direction.RIGHT
	elif move_direction.x < 0:
		if last_direction != Direction.LEFT:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("walk_right")
			last_direction = Direction.LEFT
	elif move_direction.y < 0:
		if last_direction != Direction.UP:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("walk_up")
			last_direction = Direction.UP
	elif move_direction.y > 0:
		if last_direction != Direction.DOWN:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("walk_down")
			last_direction = Direction.DOWN
	else:
		match last_direction:
			Direction.RIGHT:
				animated_sprite_2d.flip_h = false
				animated_sprite_2d.play("idle_right")
			Direction.LEFT:
				animated_sprite_2d.flip_h = true
				animated_sprite_2d.play("idle_right")
			Direction.UP:
				animated_sprite_2d.flip_h = false
				animated_sprite_2d.play("idle_up")
			Direction.DOWN:
				animated_sprite_2d.flip_h = false
				animated_sprite_2d.play("idle_down")
		last_direction = Direction.NONE
