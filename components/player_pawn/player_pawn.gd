class_name PlayerPawn
extends Pawn

## Signal emitted when a pickup is detected
## @param pickup: The pickup that was detected
signal pickup_detected(pickup: Pickup)

## Signal emitted when a pickup is no longer detected
## @param pickup: The pickup that was lost
signal pickup_lost(pickup: Pickup)

## Signal emitted when an interactable is detected
## @param interactable: The interactable that was detected
signal interactable_detected(interactable: Interactable)

## Signal emitted when an interactable is no longer detected
## @param interactable: The interactable that was lost
signal interactable_lost(interactable: Interactable)

## The currently held pickup
var held_pickup: Pickup:
	get:
		return _held_pickup

@onready var _detection_area: Area3D = Assure.exists(%DetectionArea as Area3D)
@onready var _hand_attachment: BoneAttachment3D = Assure.exists(%HandAttachment as BoneAttachment3D)

var _held_pickup: Pickup = null

func _ready() -> void:
	_detection_area.area_entered.connect(_on_detection_area_entered)
	_detection_area.area_exited.connect(_on_detection_area_exited)

## Called when an area enters the detection area
## @param area: The area that entered the detection area
func _on_detection_area_entered(area: Area3D) -> void:
	var owner_node: Node = area.owner
	if owner_node is Pickup:
		pickup_detected.emit(owner_node)
	if owner_node is Interactable:
		interactable_detected.emit(owner_node)

## Called when an area exits the detection area
## @param area: The area that exited the detection area
func _on_detection_area_exited(area: Area3D) -> void:
	var owner_node: Node = area.owner
	if owner_node is Pickup:
		pickup_lost.emit(owner_node)
	if owner_node is Interactable:
		interactable_lost.emit(owner_node)

## Picks up the specified pickup
## If the player is already holding a pickup, the current pickup will be dropped first
## @param pickup: The pickup to pick up
func pick_up(pickup: Pickup) -> void:
	if not is_instance_valid(pickup):
		return

	# Drop any currently held pickup
	if is_instance_valid(_held_pickup):
		drop()

	# Set the pickup's position to be at the hand attachment
	_held_pickup = pickup
	pickup.reparent(_hand_attachment)
	pickup.position = Vector3.ZERO

	# Call the pickup's pick_up method, so it can do additional setup
	pickup.pick_up()

## Drops the currently held pickup
## Does nothing if no pickup is currently held
func drop() -> void:
	if not is_instance_valid(_held_pickup):
		return
	
	# Reparent the pickup to the player's parent
	_held_pickup.reparent(get_parent())

	# Set the pickup's global position to be the player's global position
	_held_pickup.global_position = global_position

	# Call the pickup's drop method, so it can do additional cleanup
	_held_pickup.drop()

	#  And we no longer hold a pickup
	_held_pickup = null
