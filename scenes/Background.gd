extends AnimatedSprite

func _ready():
	var screen_size = get_viewport_rect().size
	self.position = Vector2(screen_size.x/2, screen_size.y/2) 
