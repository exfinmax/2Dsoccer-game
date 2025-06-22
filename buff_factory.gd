class_name BuffFactory

var buff : Dictionary

func _init() -> void:
	buff = {
		PlayerBuff.Buff.FIRE_SPEED: PlayerFireSpeed,
		PlayerBuff.Buff.POWER: PlayerPower,
		PlayerBuff.Buff.SPEED: PlayerSpeed,
		PlayerBuff.Buff.SUSPICIOUS: PlayerFireSpeed,
	}

func get_fresh_buff(current_buff: PlayerBuff.Buff) -> PlayerBuff:
	assert(buff.has(current_buff), "Buff doesn't exist!")
	return buff.get(current_buff).new()
