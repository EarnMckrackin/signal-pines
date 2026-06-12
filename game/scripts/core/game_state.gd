extends Node
## Autoload "GameState": session-wide story flags and captured evidence.
## Rumors, mission progress, and gadget ownership are all just flags so
## scenes stay decoupled; nothing here persists to disk yet.

signal flag_changed(flag: String, value: bool)
signal evidence_added(id: String)

var flags: Dictionary = {}
var evidence: Array[String] = []


func set_flag(flag: String, value := true) -> void:
	if flags.get(flag, false) == value:
		return
	flags[flag] = value
	flag_changed.emit(flag, value)


func has_flag(flag: String) -> bool:
	return flags.get(flag, false)


func add_evidence(id: String) -> void:
	if id in evidence:
		return
	evidence.append(id)
	evidence_added.emit(id)


func has_evidence(id: String) -> bool:
	return id in evidence
