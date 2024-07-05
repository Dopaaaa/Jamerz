extends Camera2D

# Exported variables for customization
@export var zoom_min = 1.0
@export var zoom_max = 3.0
@export var margin = 200.0
@export var smoothness = 0.1

# Player nodes
var players = []

func _ready():
	make_current()  # Set this camera as the current one
	print("Camera set to current.")

	# Find player nodes using absolute paths
	var player1 = get_node_or_null("/root/Main/Player")
	var player2 = get_node_or_null("/root/Main/Enemy")
	
	if player1:
		players.append(player1)
		print("Player node found: ", player1.name)
	else:
		print("Player node not found.")
		
	if player2:
		players.append(player2)
		print("Enemy node found: ", player2.name)
	else:
		print("Enemy node not found.")

func _process(delta):
	if players.size() < 2:
		print("Not enough players found.")
		return

	# Get player positions
	var pos1 = players[0].position
	var pos2 = players[1].position

	# Calculate center and size of the bounding box containing both players
	var center = (pos1 + pos2) / 2
	var size = (pos1 - pos2).abs()

	# Calculate the distance between the players
	var distance = size.length()
	print("Distance: ", distance)

	# Directly calculate zoom level based on distance
	var new_zoom = 1.0 + (distance / 400.0)  # Adjust 400.0 for desired effect
	new_zoom = clamp(new_zoom, zoom_min, zoom_max)
	print("Calculated new_zoom: ", new_zoom)

	# Reverse the zoom level for correct behavior
	new_zoom = zoom_max - (new_zoom - zoom_min)
	new_zoom = clamp(new_zoom, zoom_min, zoom_max)
	print("Reversed new_zoom: ", new_zoom)

	# Smoothly interpolate the camera position and zoom
	position = lerp(position, center, smoothness)
	zoom = lerp(zoom, Vector2(new_zoom, new_zoom), smoothness)

	# Final debug prints
	print("Camera position: ", position)
	print("Camera zoom: ", zoom)
