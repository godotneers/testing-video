@tool
class_name TestArea
extends Area3D

signal occupied()
signal vacant()

@onready var _label: Label3D = Assure.exists(%Label3D as Label3D)
@onready var _collision_shape: CollisionShape3D = Assure.exists(%CollisionShape3D as CollisionShape3D)

var _shape: CylinderShape3D
var _material: StandardMaterial3D

@export var radius: float = 1:
	set(value):
		radius = value
		_refresh()

@export var height: float = 2:
	set(value):
		height = value
		_refresh()

@export var color: Color = Color.GREEN:
	set(value):
		color = value
		_refresh()

@export var text: String = "":
	set(value):
		text = value
		_refresh()

@export var groups: Array[StringName] = []:
	set(value):
		groups = value
		_refresh()

@export_tool_button("Test color") var tc = _test_color

var _enter_count:int = 0
var enter_count:int:
	get: return _enter_count
	
var was_entered:bool:
	get: return enter_count > 0

var _bodies:Array[Node3D] = []

var is_occupied:bool:
	get: return not _bodies.is_empty()

var is_vacant:bool:
	get: return not is_occupied

func _ready():
	var light: CSGCylinder3D = Assure.exists(%Light as CSGCylinder3D)
	_material = Assure.exists(light.material as StandardMaterial3D)
	
	_shape = Assure.exists(_collision_shape.shape as CylinderShape3D)
	
	body_entered.connect(_update_light.bind(true))
	body_exited.connect(_update_light.bind(false))
	
	_refresh()

func _reset():
	_bodies.clear()
	_enter_count = 0
	_material.albedo_color = Color.BLACK
	_material.emission = Color.BLACK

func _update_light(body:Node3D, entered:bool):
	var occupied_before:bool = is_occupied
	if not entered:
		_bodies.erase(body)
	else:
		if groups.is_empty() or groups.any(func(it): return body.is_in_group(it)):
			_bodies.append(body)
			enter_count += 1
	
	var occupied_now:bool = is_occupied
	
	if occupied_before and not occupied_now:
		vacant.emit()
		
	if not occupied_before and occupied_now:
		occupied.emit()
				
	var new_color: Color = color if occupied_now else Color.BLACK
	_material.albedo_color = new_color
	_material.emission = new_color


func _test_color():
	_material.albedo_color = color
	_material.emission = color
	await get_tree().create_timer(2).timeout
	_material.albedo_color = Color.BLACK
	_material.emission = Color.BLACK


func _refresh():
	if not is_node_ready():
		return
	
	_label.text = text
	_shape.height = height
	_shape.radius = radius
	_collision_shape.position.y = height/2.0
	
