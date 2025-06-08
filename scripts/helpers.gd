
enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

static func directionToEnglish(direction: Direction) -> String:
	var map = {
		Direction.UP: "up",
		Direction.DOWN: "down",
		Direction.LEFT: "left",
		Direction.RIGHT: "right"
	}
	return map[direction]
	
static func englishToDirection(direction: String) -> Direction:
	var map = {
		"up": Direction.UP,
		"down": Direction.DOWN,
		"left": Direction.LEFT,
		"right": Direction.RIGHT
	}
	return map[direction]

static func directionToVec2(direction: Direction, multiplier: int = 1) -> Vector2:
	var map = {
		Direction.UP: Vector2(0, -multiplier),
		Direction.DOWN: Vector2(0, multiplier),
		Direction.LEFT: Vector2(-multiplier, 0),
		Direction.RIGHT: Vector2(multiplier, 0)
	}
	return map[direction]
	
