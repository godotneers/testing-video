class_name PlayerPawn
extends Pawn

## Signal emitted when a pickup is detected
## @param pickup: The pickup that was detected
signal pickup_detected(pickup: Pickup)

## Signal emitted when a pickup is no longer detected
## @param pickup: The pickup that was lost
signal pickup_lost(pickup: Pickup)

@onready var _pickup_detection_area: Area3D = Assure.exists(%PickupDetectionArea as Area3D)

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
