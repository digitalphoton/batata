#Camera2D.gd
extends Camera2D

func _ready():
	var map = owner.get_parent().get_node("TileMap")
	var map_size = map.map_size + Vector2(1,1)
	var cell_size = map.cell_size
	
	set_limit(MARGIN_LEFT,0)
	set_limit(MARGIN_RIGHT,map_size.x*cell_size.x)
	set_limit(MARGIN_TOP,0)
	set_limit(MARGIN_BOTTOM,map_size.y*cell_size.y)
