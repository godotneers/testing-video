## Utility node that moves things between two transforms.
@tool
class_name ThingMover
extends Node3D


signal arrived_at_end()
signal arrived_at_start()
signal departed_from_start()
signal departed_from_end()

## Duration in seconds to move between the start and end transforms.
## Higher values slow the motion; lower values make it snappier.
@export var duration:float = 3

## Easing curve used by the tween while moving between endpoints.
## Controls acceleration/deceleration feel (e.g., in, out, in-out).
@export var easing:Tween.EaseType = Tween.EASE_IN_OUT

## Transition function shaping the interpolation curve between values.
## Choose how the easing is applied over time (e.g., sine, cubic).
@export var transition:Tween.TransitionType = Tween.TRANS_CUBIC

## The transform representing the origin pose to move from.
## This anchors where the object returns when reset and where movement begins.
@export_storage var start_transform:Transform3D

## The transform representing the destination pose to move to.
## This defines where the object travels when triggered to move.
@export_storage var end_transform:Transform3D

## Editor utility: Captures the node's current transform as start_transform for quick authoring.
## Not used at runtime; here to speed up scene setup in the editor.

@export_tool_button("Set Start") var set_start_button = _set_start

## Editor utility: Captures the node's current transform as end_transform for quick authoring.
## Not used at runtime; here to speed up scene setup in the editor.
@export_tool_button("Set End") var set_end_button = _set_end

## Editor utility: Triggers run() in the editor to preview movement between endpoints.
## Useful for tuning duration/easing/transition; not used at runtime.
@export_tool_button("Test") var toggle = run

## Editor utility: Calls _editor_reset() to restore start pose during authoring.
## Not used at runtime.
@export_tool_button("Reset") var reset_button = _editor_reset

var _at_start:bool = true
var _current_tween:Tween
var _spent:bool = false

func _set_start():
	var undo = EditorInterface.get_editor_undo_redo()
	undo.create_action("Set start")
	undo.add_do_property(self, "start_transform", transform)
	undo.add_undo_property(self, "start_transform", start_transform)
	undo.commit_action()
		
	
func _set_end():
	var undo = EditorInterface.get_editor_undo_redo()
	undo.create_action("Set end")
	undo.add_do_property(self, "end_transform", transform)
	undo.add_undo_property(self, "end_transform", end_transform)
	undo.commit_action()


## Starts or reverses movement between start and end transforms.
## Emits departed_* at the start and arrived_* when the tween finishes.
## No effect if the mover is spent or the node is not inside the tree.
func run():
	if _spent or not is_inside_tree():
		return
	
	if is_instance_valid(_current_tween):
		_current_tween.kill()
	
	if _at_start:
		departed_from_start.emit()
	else:
		departed_from_end.emit()
		
	_at_start = not _at_start
	_current_tween = get_tree().create_tween()
	_current_tween \
		.set_ease(easing) \
		.set_trans(transition) \
		.tween_property(self, "transform", 
			end_transform if not _at_start else start_transform, 
			duration)
			
	if _at_start:
		_current_tween.finished.connect(func(): arrived_at_start.emit())	
	else:			
		_current_tween.finished.connect(func(): arrived_at_end.emit())	
	

## This is a special reset function for the editor which also resets the _spent flag, 
## which is something that we do not do in game. 
func _editor_reset():
	_spent = false
	reset()

## Resets the thing mover and puts it back at its starting position.
## Any currently running tween is aborted. 
## @return void
func reset():
	if _spent:
		return
	
	if is_instance_valid(_current_tween):
		_current_tween.kill()
		
	transform = start_transform
	_at_start = true	

## Runs the animation from the start to the destination position and then sets 
## the _spent flag, so this thing mover will no longer accept any more input. 	
## @return void
func run_once():
	if _spent:
		return
	run()
	_spent = true
