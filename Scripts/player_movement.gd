extends CharacterBody2D

@export_group("Player Movement")
@export var speed: int = 175  # move speed in pixels/sec
@export var friction = 0.18

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var dust_scene: PackedScene

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
			_spwan_dust_particle()
	elif move_direction.x < 0:
		if last_direction != Direction.LEFT:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("walk_right")
			last_direction = Direction.LEFT
			_spwan_dust_particle()
	elif move_direction.y < 0:
		if last_direction != Direction.UP:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("walk_up")
			last_direction = Direction.UP
			_spwan_dust_particle()
	elif move_direction.y > 0:
		if last_direction != Direction.DOWN:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("walk_down")
			last_direction = Direction.DOWN
			_spwan_dust_particle()
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


func _spwan_dust_particle(count: int = 2):
	for n in count:
		var instance = dust_scene.instantiate()
		add_child(instance)
		instance.offset.x += randf_range(-5, 5)
		instance.offset.y += randf_range(-5, 5)
		instance.reparent(get_tree().get_root())

