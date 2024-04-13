extends Label

var start_time = 0
var stop_time = 0
var paused_at = 0

func _process(delta):
	if start_time > 0 && stop_time == 0 && paused_at == 0:
		update_time()

func start():
	start_time = Time.get_unix_time_from_system()

func stop():
	stop_time = Time.get_unix_time_from_system()
	update_time()

func pause():
	paused_at = Time.get_unix_time_from_system()

func resume():
	var resumed_at = Time.get_unix_time_from_system()
	start_time = start_time + (resumed_at - paused_at)
	paused_at = 0

func update_time():
	var time = Time.get_unix_time_from_system()
	var minutes = "%02d" % [floor(time - start_time) / 60]
	var seconds = "%02d" % [ int(time - start_time) % 60 ]
	text = str(minutes) + ":" + str(seconds)
