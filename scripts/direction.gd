
# Direction based helpers

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

static var english_directions = [
	"up",
	"down",
	"left",
	"right"
]

static var vec2_directions = [
	Vector2(0, -1),
	Vector2(0, 1),
	Vector2(-1, 0),
	Vector2(1, 0)
]

static func to_english(direction: Direction) -> String:
	return english_directions[direction]

static func to_enum(direction: String) -> Direction:
	return english_directions.find(direction)

static func to_vec2(direction: Direction, multiplier: int = 1) -> Vector2:
	return vec2_directions[direction] * multiplier
	
