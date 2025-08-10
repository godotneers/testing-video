extends Node3D

@onready var nav_region:NavigationRegion3D = Assure.exists(%NavigationRegion3D)


func _ready():
	# must be called in next frame otherwise the bake does not work.
	nav_region.bake_navigation_mesh.call_deferred()
	
