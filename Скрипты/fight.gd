extends Node2D

@onready var herosprite = $"БезНазвания46320250214010745"
@onready var dmgsprite = $skillbutton1/skillbutton1sprite
@onready var defsprite = $skillbutton2/skillbutton2sprite
@onready var spsprite = $skillbutton3/skillbutton3sprite
@onready var hpbar = $hpbar
@onready var hplabel = $"hpbar/hplabel"
@onready var steplabel = $steplabel
@onready var poisonsprite = $Hp20250214224847
@onready var poisonlabel = $Hp20250214224847/poisonlabel
@onready var shieldsprite = $Shit20240831060236
@onready var brokenshieldsprite = $Shit20240831060239
@onready var shieldlabel = $deflabel
@onready var mightsprite = $Hp20250214224848
@onready var mightlabel = $Hp20250214224848/mightlabel
@onready var spellchsprite0 = $"БезНазвания46520250215012754"
@onready var spellchsprite1 = $"БезНазвания46520250215012753"
@onready var spellchsprite2 = $"БезНазвания46520250215012755"
@onready var spspellactsprite = $"БезНазвания46520250215012743"
@onready var winloselabel = $winloselabel
@onready var dodgesprite = $Icon20250215204359
@onready var bgsprite = $Bg1
@onready var bgfight = preload("res://Спрайты/bg3_20250216034839.png")
@onready var bgelite = preload("res://Спрайты/bg3_20250216034748.png")



@onready var enemie0scene = preload("res://Сцены/enemie_0.tscn")

@onready var enemie1scene = preload("res://Сцены/enemie_1.tscn")
@onready var enemie1minion0 = preload("res://Сцены/enemie_1_0.tscn")
@onready var enemie1minion1 = preload("res://Сцены/enemie_1_1.tscn")

@onready var enemie2scene = preload("res://Сцены/enemie_2.tscn")


var bartimer = 0
var resisttimer = 0
var inftimer = 0
var dmgprocess: bool = false
var defprocess: bool = false
var spprocess: bool = false
var stepchanged = null

var run: bool = false

func _ready() -> void:
	randomize()
	herosprite.texture = Global.herospriteatm
	GlobalSignals.connect("enemiechosen", Callable(self, "choosesignal"))
	GlobalSignals.connect("phurt", Callable(self, "hurt"))
	
	spawn_enemie(Vector2(0, 0))
	
	hpbar.max_value = Global.maxhp
	
	
	stepchanged = Global.playerstep
	steplabel.text = "ВАШ ХОД"

func _process(delta: float) -> void:
	hpbar.value = Global.hpatm
	skillsprite()
	spritefunc()
	win()
	lose()
	
	if Global.enemie_1special:
		var eninstance0 = enemie1minion0.instantiate()
		eninstance0.position = Vector2(0, 0)
		add_child(eninstance0)
		if Global.enemies == 2: GlobalSignals.emit_ennumassigment(1)
		else: GlobalSignals.emit_ennumassigment(2)
		var eninstance1 = enemie1minion1.instantiate()
		eninstance1.position = Vector2(0, 0)
		add_child(eninstance1)
		if Global.enemies == 2: GlobalSignals.emit_ennumassigment(2)
		else: GlobalSignals.emit_ennumassigment(3)
		Global.enemie_1special = false
	
	hplabel.text = str(Global.hpatm) + "/" + str(Global.maxhp)
	
	if stepchanged != Global.playerstep:
		if Global.playerstep:
			Global.shield = 0
			Global.dodge = 0
			
			Global.hpatm -= int(Global.poison * Global.resist)
			if Global.poison > 0:
				Global.poison -= 1
			
			if resisttimer == 0:
				Global.resist = 1
			else:
				resisttimer -= 1
			if bartimer == 0:
				Global.barricade = 0
			else:
				bartimer -= 1
			if inftimer == 0:
				Global.showinf = false
			else:
				inftimer -= 1
			
			steplabel.text = "ВАШ ХОД"
			stepchanged = Global.playerstep
		else:
			steplabel.text = "ХОД ПРОТИВНИКА"
			stepchanged = Global.playerstep



func _on_giveupbutton_pressed() -> void:
	run = true
	Global.hpatm -= Global.maxhp / 5
	winloselabel.text = "БЕГСТВО..."
	varnull()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Сцены/lobby.tscn")
	run = false
func win():
	if Global.enemies == 0 and run == false:
		winloselabel.text = "ВЫ ПОБЕДИЛИ"
		Global.money += Global.moneywithwin
		varnull()
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Сцены/lobby.tscn")
func lose():
	if Global.hpatm <= 0 and run == false:
		winloselabel.text = "ВЫ ПРОИГРАЛИ"
		varnull()
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Сцены/lobby.tscn")
func varnull():
	Global.fightisgoing = false
	Global.moneywithwin = 0
	Global.shield = 0
	Global.resist = 1
	Global.dodge = 0
	Global.poison = 0
	Global.might = 0
	Global.barricade = 0
	Global.showinf = false
	Global.playerstep = true
	Global.enemiestep = false
	Global.enemie1step = false
	Global.enemie2step = false
	Global.enemie3step = false
	Global.enemies = 0
	Global.stepchanged = true
	Global.enemie_1special = false
	Global.twoenmiesposclosed = false

func enemierandomiser():
	var randomint = randi() % 5 + 1
	return randomint
func spawn_enemie(position: Vector2):
	var number = enemierandomiser() 
	if number == 1:
		Global.enemies += 1
		var eninstance = enemie0scene.instantiate()
		eninstance.position = position
		add_child(eninstance)
		GlobalSignals.emit_ennumassigment(1)
		Global.moneywithwin = 16
		bgsprite.texture = bgfight
	
	elif number == 2:
		Global.enemies += 1
		var eninstance = enemie1scene.instantiate()
		eninstance.position = position
		add_child(eninstance)
		GlobalSignals.emit_ennumassigment(1)
		Global.moneywithwin = 21
		bgsprite.texture = bgfight
	
	elif number == 3:
		Global.enemies += 2
		var eninstance = enemie0scene.instantiate()
		eninstance.position = position
		add_child(eninstance)
		GlobalSignals.emit_ennumassigment(1)
		var eninstance1 = enemie1scene.instantiate()
		eninstance.position = position
		add_child(eninstance1)
		GlobalSignals.emit_ennumassigment(2)
		Global.moneywithwin = 45
		bgsprite.texture = bgelite
	
	elif number == 4:
		Global.enemies += 2
		var eninstance = enemie0scene.instantiate()
		eninstance.position = position
		add_child(eninstance)
		GlobalSignals.emit_ennumassigment(1)
		var eninstance1 = enemie2scene.instantiate()
		eninstance.position = position
		add_child(eninstance1)
		GlobalSignals.emit_ennumassigment(2)
		Global.moneywithwin = 52
		bgsprite.texture = bgelite
	
	elif number == 5:
		Global.enemies += 2
		var eninstance = enemie2scene.instantiate()
		eninstance.position = position
		add_child(eninstance)
		GlobalSignals.emit_ennumassigment(1)
		var eninstance1 = enemie1scene.instantiate()
		eninstance.position = position
		add_child(eninstance1)
		GlobalSignals.emit_ennumassigment(2)
		Global.moneywithwin = 64
		bgsprite.texture = bgelite



func skillsprite():
	if Global.dmgskill == 0:
		dmgsprite.texture = Global.item_texture0
	elif Global.dmgskill == 1:
		dmgsprite.texture = Global.item_texture1
	elif Global.dmgskill == 2:
		dmgsprite.texture = Global.item_texture2
	else:
		dmgsprite.texture = null
	
	if Global.defskill == 0:
		defsprite.texture = Global.item_texture3
	elif Global.defskill == 1:
		defsprite.texture = Global.item_texture4
	elif Global.defskill == 2:
		defsprite.texture = Global.item_texture5
	else:
		defsprite.texture = null
	
	if Global.spskill == 0:
		spsprite.texture = Global.item_texture6
	elif Global.spskill == 1:
		spsprite.texture = Global.item_texture7
	elif Global.spskill == 2:
		spsprite.texture = Global.item_texture8
	else:
		spsprite.texture = null
func spritefunc():
	if Global.poison > 0:
		poisonsprite.show()
		poisonlabel.text = str(Global.poison)
	else:
		poisonsprite.hide()
		poisonlabel.text = " "
	
	
	if Global.shield > 0 or Global.dodge > 0 or Global.resist < 1:
		shieldsprite.show()
		brokenshieldsprite.hide()
		if Global.shield > 0:
			shieldlabel.text = str(Global.shield)
		if Global.resist < 1:
			shieldlabel.text = str(Global.resist)
	else:
		shieldsprite.hide()
		brokenshieldsprite.show()
		shieldlabel.text = " "
	if Global.dodge > 0:
		dodgesprite.show()
	else:
		dodgesprite.hide()
	
	
	if Global.barricade > 0 or Global.showinf:
		spspellactsprite.show()
	else:
		spspellactsprite.hide()
	
	
	
	if Global.might > 0:
		mightsprite.show()
		mightlabel.text = str(Global.might)
	else:
		mightsprite.hide()
		mightlabel.text = " "
	
	
	if dmgprocess:
		spellchsprite0.show()
	else:
		spellchsprite0.hide()
	if defprocess:
		spellchsprite1.show()
	else:
		spellchsprite1.hide()
	if spprocess:
		spellchsprite2.show()
	else:
		spellchsprite2.hide()




func choosesignal(index):
	if dmgprocess:
		fizdmg(index)
		algebdmg(index)
		himdmg(index)
	if defprocess:
		geomdef()
		objdef()
		biodef()
	if spprocess:
		litsp()
		hissp()
		infsp()

func hurt(status, quantity):
	if status == "damage":
		if Global.dodge >= 1:
			Global.dodge -= 1
		elif Global.shield > 0:
			if int(quantity * Global.resist) <= Global.shield:
				Global.shield -= int(quantity * Global.resist)
			else:
				Global.shield = 0
				Global.hpatm -= (int(quantity * Global.resist) - Global.shield)
		else:
			Global.hpatm -= int(quantity * Global.resist)
	if status == "poison":
			Global.poison += quantity

func dmgdeal(index, quantity):
	GlobalSignals.emit_target(index, "damage", quantity)


func _on_skillbutton_1_pressed() -> void:
	if Global.playerstep:
		if defprocess or spprocess:
			defprocess = false
			spprocess = false
			dmgprocess = true
		else:
			dmgprocess = true

func _on_skillbutton_2_pressed() -> void:
	if Global.playerstep:
		if dmgprocess or spprocess:
			defprocess = true
			spprocess = false
			dmgprocess = false
		else:
			defprocess = true

func _on_skillbutton_3_pressed() -> void:
	if Global.playerstep:
		if defprocess or dmgprocess:
			defprocess = false
			spprocess = true
			dmgprocess = false
		else:
			spprocess = true


func fizdmg(index):
	if Global.dmgskill == 0:
		dmgdeal(index, int(5.5 * Global.fizpoint) + Global.might)
		dmgprocess = false
		await get_tree().create_timer(1).timeout
		Global.playerstep = false
		Global.enemiestep = true
func algebdmg(index):
	if Global.dmgskill == 1:
		dmgdeal(index, 3 + Global.might)
		await get_tree().create_timer(0.2).timeout
		dmgdeal(index, 3 + Global.might)
		if Global.algebpoint > 2:
			await get_tree().create_timer(0.4).timeout
			dmgdeal(index, 3 + Global.might)
		if Global.algebpoint > 3:
			await get_tree().create_timer(0.6).timeout
			dmgdeal(index, 3 + Global.might)
		if Global.algebpoint > 4:
			await get_tree().create_timer(0.8).timeout
			dmgdeal(index, 3 + Global.might)
		dmgprocess = false
		await get_tree().create_timer(1).timeout
		Global.playerstep = false
		Global.enemiestep = true
func himdmg(index):
	if Global.dmgskill == 2:
		GlobalSignals.emit_target(index, "poison", int(1.7 * Global.himpoint + Global.might * 0.7))
		dmgprocess = false
		await get_tree().create_timer(1).timeout
		Global.playerstep = false
		Global.enemiestep = true

func geomdef():
	if Global.defskill == 0:
		Global.shield += int(Global.geompoint * 4.8) + Global.barricade
		defprocess = false
		await get_tree().create_timer(1).timeout
		Global.playerstep = false
		Global.enemiestep = true
func objdef():
	if Global.defskill == 1:
		Global.dodge += 1
		if Global.barricade > 0:
			Global.resist = 0.5
		defprocess = false
		await get_tree().create_timer(1).timeout
		Global.playerstep = false
		Global.enemiestep = true
func biodef():
	if Global.defskill == 2:
		Global.resist = 1 - ((Global.biopoint * 0.12) + (Global.barricade * 0.01))
		resisttimer = 1
		defprocess = false
		await get_tree().create_timer(1).timeout
		Global.playerstep = false
		Global.enemiestep = true

func litsp():
	if Global.spskill == 0:
		Global.might += 1
		if Global.litpoint == 4 or Global.litpoint == 5:
			Global.might += 1
		spprocess = false
		await get_tree().create_timer(1).timeout
		Global.playerstep = false
		Global.enemiestep = true
func hissp():
	if Global.spskill == 1:
		Global.barricade = Global.histpoint * 2
		bartimer = 2
		spprocess = false
		await get_tree().create_timer(1).timeout
		Global.playerstep = false
		Global.enemiestep = true
func infsp():
	if Global.spskill == 2:
		Global.showinf = true
		inftimer = 2
		spprocess = false
		await get_tree().create_timer(1).timeout
		Global.playerstep = false
		Global.enemiestep = true
