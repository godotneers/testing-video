## Utility node that moves things between two transforms.
@tool
class_name ThingMover
extends Node3D


signal arrived_at_end()
signal arrived_at_start()
signal departed_from_start()
signal departed_from_end()

@export_node_path("Node3D") var target:NodePath
@export var duration:float = 3
@export var ease:Tween.EaseType = Tween.EASE_IN_OUT
@export var transition:Tween.TransitionType = Tween.TRANS_CUBIC
@export_tool_button("Set Start") var set_start_button = _set_start
@export_storage var start_transform:Transform3D
@export_tool_button("Set End") var set_end_button = _set_end
@export_storage var end_transform:Transform3D
@export_tool_button("Test") var toggle = run
@export_tool_button("Reset") var reset_button = reset

var _at_start:bool = true
var _current_tween:Tween
var _dying:bool = false

func _set_start():
	var node:Node3D = _get_target_or_null()
	if node == null:
		return
	
	var undo = EditorInterface.get_editor_undo_redo()
	undo.create_action("Set start")
	undo.add_do_property(self, "start_transform", node.transform)
	undo.add_undo_property(self, "start_transform", start_transform)
	undo.commit_action()
		
	
func _set_end():
	var node:Node3D = _get_target_or_null()
	if node == null:
		return
	
	var undo = EditorInterface.get_editor_undo_redo()
	undo.create_action("Set end")
	undo.add_do_property(self, "end_transform", node.transform)
	undo.add_undo_property(self, "end_transform", end_transform)
	undo.commit_action()

func run():
	if _dying or not is_inside_tree():
		return
	
	if is_instance_valid(_current_tween):
		_current_tween.kill()
	
	var node:Node3D = _get_target_or_null()
	if node == null:
		return
	
	if _at_start:
		print("departed from start")
		departed_from_start.emit()
	else:
		print("delaprted from end")
		departed_from_end.emit()
		
	_at_start = not _at_start
	_current_tween = get_tree().create_tween()
	_current_tween \
		.set_ease(ease) \
		.set_trans(transition) \
		.tween_property(node, "transform", 
			end_transform if not _at_start else start_transform, 
			duration)
			
	if _at_start:
		_current_tween.finished.connect(func(): arrived_at_start.emit())	
	else:			
		_current_tween.finished.connect(func(): arrived_at_end.emit())	
	

func reset():
	if _dying:
		return
	
	if is_instance_valid(_current_tween):
		_current_tween.kill()
	
	var node:Node3D = _get_target_or_null()
	if node == null:
		return
		
	node.transform = start_transform
	_at_start = true	
	
func run_once():
	if _dying:
		return
	run()
	_current_tween.finished.connect(func(): queue_free())
	_dying = true

func _get_target_or_null() -> Node3D:
	var result:Node3D = get_node_or_null(target)
	if result == null:
		push_warning("Target node not found")
	return result
