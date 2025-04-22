extends Node


signal enemiechosen(index)
func emit_enemiechosen(index):
	emit_signal("enemiechosen", index)

signal target(index, status, quantity)
func emit_target(index, status, quantity):
	emit_signal("target", index, status, quantity)
	
signal phurt(status, quantity)
func emit_phurt(status, quantity):
	emit_signal("phurt", status, quantity)

signal ennumassigment(ennum)
func emit_ennumassigment(ennum):
	emit_signal("ennumassigment", ennum)
