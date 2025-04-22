extends Node


var config
var path_to_save_file := "user://IDWB1.cfg"
var section_name := "game"



var moneysprite = preload("res://Спрайты/icon_20250215202110.png")

var item_texture0 = preload("res://Спрайты/СкиллСпрайты/Без названия465_20250216194618.png")
var item_texture1 = preload("res://Спрайты/СкиллСпрайты/Без названия465_20250216195211.png")
var item_texture2 = preload("res://Спрайты/СкиллСпрайты/Без названия465_20250216204054.png")
var item_texture3 = preload("res://Спрайты/СкиллСпрайты/Без названия465_20250216204046.png")
var item_texture4 = preload("res://Спрайты/СкиллСпрайты/Без названия465_20250216204542.png")
var item_texture5 = preload("res://Спрайты/СкиллСпрайты/Без названия465_20250216205320.png")
var item_texture6 = preload("res://Спрайты/СкиллСпрайты/Без названия465_20250216210307.png")
var item_texture7 = preload("res://Спрайты/СкиллСпрайты/Без названия465_0000-47-38_20250216211158.png")
var item_texture8 = preload("res://Спрайты/СкиллСпрайты/Без названия465_20250216212001.png")



var skin1 = preload("res://Спрайты/Без названия463_20250214013024.png")
var skin2 = preload("res://Спрайты/mob_20250216230215.png")
var skin2name: String = "Берсеркер"
var skin2bought: bool = false
var skin3
var skin3name: String
var skin3bought: bool = false
var skin4
var skin4name: String
var skin4bought: bool = false
var skin5
var skin5name: String
var skin5bought: bool = false

var herospriteatm = skin1
var skinname: String = "Книжный колдун"


var cloathes1 = " "
var cloathessprite1 = moneysprite
var cloathes2 = " "
var cloathessprite2 = moneysprite
var cloathes3 = " "
var cloathessprite3 = moneysprite
var cloathes4 = " "
var cloathessprite4 = moneysprite


var dmgskill = -1
var defskill = -1
var spskill = -1
var playerstep: bool = true
var enemiestep: bool = false
var enemie1step: bool 
var enemie2step: bool 
var enemie3step: bool 
var enemies = 0
var stepchanged: bool = true

var enemie_1special: bool = false

var twoenmiesposclosed: bool = false

var fightisgoing:bool = false

var gpa = 4.5

#атака
var fizpoint = 4
var algebpoint = 5
var himpoint = 3

#защита
var geompoint = 3
var objpoint = 5
var biopoint = 5

#спешал
var litpoint = 5
var histpoint = 4
var infpoint = 3


var maxhp = gpa * 20
var hpatm = maxhp
var shield = 0
var resist = 1
var dodge = 0
var poison = 0

var might = 0
var barricade = 0
var showinf: bool = false

var money: int = 0
var moneywithwin: int = 0

func _ready() -> void:
	maxhp = gpa * 20
	hpatm = maxhp
	load_game()



func _process(delta: float) -> void:
	if hpatm < 0:
		hpatm = 0
	if hpatm > maxhp:
		hpatm = maxhp
	
	if enemies > 1:
		if enemiestep:
			if stepchanged:
				enemie1step = true
				enemie2step =  true
				if enemies == 3:
					enemie3step = true
				stepchanged = false
			elif enemies == 2 and enemie1step == false and enemie2step == false:
				enemiestep = false
				stepchanged = true
				await get_tree().create_timer(2.5).timeout
				playerstep = true
			elif enemies == 3 and enemie1step == false and enemie2step == false and enemie3step == false:
				enemiestep = false
				stepchanged = true
				await get_tree().create_timer(2.5).timeout
				playerstep = true
	




func save_game():
	config.set_value(section_name, "skin2bought", skin2bought)
	config.set_value(section_name, "skin3bought", skin3bought)
	config.set_value(section_name, "skin4bought", skin4bought)
	config.set_value(section_name, "skin5bought", skin5bought)
	config.set_value(section_name, "skinname", skinname)
	config.set_value(section_name, "herospriteatm", herospriteatm)
	config.set_value(section_name, "cloathes1", cloathes1)
	config.set_value(section_name, "cloathessprite1", cloathessprite1)
	config.set_value(section_name, "cloathes2", cloathes2)
	config.set_value(section_name, "cloathessprite2", cloathessprite2)
	config.set_value(section_name, "cloathes3", cloathes3)
	config.set_value(section_name, "cloathessprite3", cloathessprite3)
	config.set_value(section_name, "cloathes4", cloathes4)
	config.set_value(section_name, "cloathessprite4", cloathessprite4)
	config.set_value(section_name, "hpatm", hpatm)
	config.set_value(section_name, "money", money)
	config.set_value(section_name, "dmgskill", dmgskill)
	config.set_value(section_name, "defskill", defskill)
	config.set_value(section_name, "spskill", spskill)
	config.save(path_to_save_file)





func load_game():
	config = ConfigFile.new()
	config.load(path_to_save_file)
	skin2bought = config.get_value(section_name, "skin2bought", false)
	skin3bought = config.get_value(section_name, "skin3bought", false)
	skin4bought = config.get_value(section_name, "skin4bought", false)
	skin5bought = config.get_value(section_name, "skin5bought", false)
	skinname = config.get_value(section_name, "skinname", "Книжный колдун")
	herospriteatm = config.get_value(section_name, "herospriteatm", skin1)
	cloathes1 = config.get_value(section_name, "cloathes1", " ")
	cloathessprite1 = config.get_value(section_name, "cloathessprite1", moneysprite)
	cloathes2 = config.get_value(section_name, "cloathes2", " ")
	cloathessprite2 = config.get_value(section_name, "cloathessprite2", moneysprite)
	cloathes3 = config.get_value(section_name, "cloathes3", " ")
	cloathessprite3 = config.get_value(section_name, "cloathessprite3", moneysprite)
	cloathes4 = config.get_value(section_name, "cloathes4", " ")
	cloathessprite4 = config.get_value(section_name, "cloathessprite4", moneysprite)
	hpatm = config.get_value(section_name, "hpatm", 100)
	money = config.get_value(section_name, "money", 0)
	dmgskill = config.get_value(section_name, "dmgskill", -1)
	defskill = config.get_value(section_name, "defskill", -1)
	spskill = config.get_value(section_name, "spskill", -1)
	
	
	
