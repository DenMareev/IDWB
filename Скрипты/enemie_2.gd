extends Node2D

@onready var dmgstepsprite = $Hp20250214010553
@onready var spstepsprite = $Hp20250214010331
@onready var hplabel = $Label
@onready var shiedsprite = $Shit20240831060236
@onready var shieldlabel = $Shit20240831060236/shieldlabel
@onready var inflabel = $inflabel
@onready var poisonsprite = $Hp20250214224847
@onready var poisonlabel = $Hp20250214224847/poisonlabel
@onready var mightsprite = $Hp20250214224848
@onready var mightlabel = $Hp20250214224848/mightlabel
@onready var dodgesprite = $Icon20250215204359
@onready var selfsprite = $Sprite2D

var randomint
var maxhp = 80
var hp = 80
var shield = 0
var poison = 0
var might = 0
var dodge = 1
var notdead: bool = true
var ennum = 0 #изменить определение при спавне

var speed: float = 2
var amplitude: float = 30
var offset = 0.0

func _ready() -> void:
	randomize()
	GlobalSignals.connect("target", Callable(self, "hurt"))
	GlobalSignals.connect("ennumassigment", Callable(self, "ennumassigment"))
	steprandomiser()

func _process(delta: float) -> void:
	if Global.enemies == 1:
		self.position = Vector2(870, 290)
	if Global.enemies == 2:
		if ennum == 1:
			self.position = Vector2(700, 290)
		elif ennum == 3:
			self.position = Vector2(950, 290)
			Global.twoenmiesposclosed = true
		elif ennum == 2:
			if Global.twoenmiesposclosed and self.position != Vector2(950, 290):
				self.position = Vector2(700, 290)
			else:
				self.position = Vector2(950, 290)
				Global.twoenmiesposclosed = true
	if Global.enemies == 3:
		if ennum == 1:
			self.position = Vector2(530, 290)
		elif ennum == 2:
			self.position = Vector2(780, 290)
		else:
			self.position = Vector2(1030, 290)
	
	offset += speed * delta
	var y_position = amplitude * sin(offset)
	selfsprite.position.y = y_position
	
	hplabel.text = str(hp) + "/" + str(maxhp)
	inflabelfunc()
	spritefunc()
	
	if shield > 0:
		shiedsprite.show()
		shieldlabel.text = str(shield)
	else:
		shiedsprite.hide()
		shieldlabel.text = " "
	
	death()
	stepmark()
	if Global.enemies > 1:
		if self.position == Vector2(700, 290) or self.position == Vector2(530, 290):
			if Global.enemie1step and notdead:
				Global.enemie1step = false
				step()
		if self.position == Vector2(950, 290) or self.position == Vector2(780, 290):
			if Global.enemie2step and notdead:
				Global.enemie2step = false
				step()
		if self.position == Vector2(1030, 290):
			if Global.enemie3step and notdead:
				Global.enemie3step = false
				step()
	else:
		if Global.enemiestep and notdead:
			Global.enemiestep = false
			step()
			await get_tree().create_timer(2).timeout
			Global.playerstep = true




func _on_texture_button_pressed() -> void:
	GlobalSignals.emit_enemiechosen(ennum)
func ennumassigment(ennumsignal):
	if ennum == 0:
		ennum = ennumsignal
func hurt(index, status, quantity):
	if ennum == index:
		if status == "damage":
			if dodge >= 1:
				dodge -= 1
			elif shield > 0:
				if quantity <= shield:
					shield -= quantity
				else:
					shield = 0
					hp -= (quantity - shield)
			else:
				hp -= quantity
		if status == "poison":
			poison += quantity
		if status == "might":
			might += quantity
		if status == "shield":
			shield += quantity
func inflabelfunc():
	if Global.showinf:
		if randomint == 1:
			inflabel.text = "ОДИН УДАР"
		elif randomint == 2:
			inflabel.text = "СИЛА ВСЕМ"
		elif randomint == 3:
			inflabel.text = "ЩИТ ВСЕМ"
	else:
		inflabel.text = " "
func spritefunc():
	if poison > 0:
		poisonsprite.show()
		poisonlabel.text = str(poison)
	else:
		poisonsprite.hide()
		poisonlabel.text = " "
	
	
	if might > 0:
		mightsprite.show()
		mightlabel.text = "+" + str(might)
	else:
		mightsprite.hide()
		mightlabel.text = " "
	
	
	if dodge > 0:
		dodgesprite.show()
	else:
		dodgesprite.hide()


func death():
	if notdead and hp < 1:
		Global.enemies -= 1
		if self.position == Vector2(950, 290):
			Global.twoenmiesposclosed = false
		queue_free()
		notdead = false


func damagedeal(quantity):
	GlobalSignals.emit_phurt("damage", quantity)

func steprandomiser():
	randomint = randi() % 3 + 1

func stepmark():
	if randomint == 1:
		dmgstepsprite.show()
		spstepsprite.hide()
	if randomint == 3 or randomint == 2:
		dmgstepsprite.hide()
		spstepsprite.show()


func step():
	shield = 0
	dodge = 0
	hp -= poison
	if poison > 0:
		poison -= 1
	if randomint == 1:
		atk1()
	if randomint == 2:
		sp1()
	if randomint == 3:
		sp2()


func atk1():
	await get_tree().create_timer(2).timeout
	damagedeal(2 + might)
	steprandomiser()
func sp1():
	await get_tree().create_timer(2.1).timeout
	GlobalSignals.emit_target(1, "might", 1)
	GlobalSignals.emit_target(2, "might", 1)
	GlobalSignals.emit_target(3, "might", 1)
	steprandomiser()
func sp2():
	await get_tree().create_timer(2.1).timeout
	GlobalSignals.emit_target(1, "shield", 12)
	GlobalSignals.emit_target(2, "shield", 13)
	GlobalSignals.emit_target(3, "shield", 14)
	steprandomiser()
