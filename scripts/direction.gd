
# Direction based helpers

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

static var englishDirections = [
	"up",
	"down",
	"left",
	"right"
]

static var vecDirections = [
	Vector2(0, -1),
	Vector2(0, 1),
	Vector2(-1, 0),
	Vector2(1, 0)
]

static func toEnglish(direction: Direction) -> String:
	return englishDirections[direction]

static func toEnum(direction: String) -> Direction:
	return englishDirections.find(direction)

static func toVec2(direction: Direction, multiplier: int = 1) -> Vector2:
	return vecDirections[direction] * multiplier
	
