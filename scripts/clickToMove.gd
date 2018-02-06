extends RigidBody

var mousePos = null
var camera
var ray
var space_state
var ray_origin
var ray_direction
var hit = null
var lookMe

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	#Acess the node World and get the camera
	camera = get_parent().get_node("MainCamera")

func _input(ev):
	if ev.type == InputEvent.MOUSE_BUTTON:
		mousePos = ev.pos

func _fixed_process(delta):	
	if Input.get_mouse_button_mask() == 1 && mousePos != null:
		# Project mouse into a 3D ray
		ray_origin = camera.project_ray_origin(mousePos)
		ray_direction = camera.project_ray_normal(mousePos)
		
		# Raycast
		ray = ray_origin + ray_direction * 1000.0
		space_state = get_world().get_direct_space_state()
		hit = space_state.intersect_ray(ray_origin, ray)
		#To prevent Pauli exclusion principle violation :p
		hit['position'].y += 1
		lookMe = Vector3(hit['position'].x, hit['position'].y, hit['position'].z)
	if hit != null:
		if hit.size() != 0:
			# Hope it move to the point clicked by time
			set_translation(get_translation().linear_interpolate(hit['position'], delta * 1))
			look_at(lookMe, Vector3(0,1,0))