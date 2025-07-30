class_name PlayerPawn
extends Pawn

## Signal emitted when a pickup is detected
## @param pickup: The pickup that was detected
signal pickup_detected(pickup: Pickup)

## Signal emitted when a pickup is no longer detected
## @param pickup: The pickup that was lost
signal pickup_lost(pickup: Pickup)

## The currently held pickup
var held_pickup: Pickup:
	get:
		return _held_pickup

@onready var _pickup_detection_area: Area3D = Assure.exists(%PickupDetectionArea as Area3D)
@onready var _hand_attachment: BoneAttachment3D = Assure.exists(%HandAttachment as BoneAttachment3D)

var _held_pickup: Pickup = null

func _ready() -> void:
	_pickup_detection_area.area_entered.connect(_on_pickup_detection_area_entered)
	_pickup_detection_area.area_exited.connect(_on_pickup_detection_area_exited)

## Called when an area enters the pickup detection area
## @param area: The area that entered the pickup detection area
func _on_pickup_detection_area_entered(area: Area3D) -> void:
	var potential_pickup:Node = area.owner
	if potential_pickup is Pickup:
		pickup_detected.emit(potential_pickup)

## Called when an area exits the pickup detection area
## @param area: The area that exited the pickup detection area
func _on_pickup_detection_area_exited(area: Area3D) -> void:
	var potential_pickup:Node = area.owner
	if potential_pickup is Pickup:
		pickup_lost.emit(potential_pickup)

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
