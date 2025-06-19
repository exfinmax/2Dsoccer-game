class_name BallData

var lock_duration :int

static func build() -> BallData:
	return BallData.new()

func set_lock_duration(duration: int) -> BallData:
	lock_duration = duration
	return self
