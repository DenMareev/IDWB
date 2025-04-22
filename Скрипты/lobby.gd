extends Node2D

@onready var herosprite = $"БезНазвания46320250214010745"
@onready var itemlist = $"stut/ItemList"
@onready var youcnf = $Label
@onready var hpbar = $"hpbar"
@onready var stut = $"stut"
@onready var stutbutton = $"stutbutton"
@onready var fightbutton = $"fightbutton"
@onready var cloathesbutton = $cloathesbutton
@onready var shopbutton = $shopbutton
@onready var hplabel = $"hpbar/hplabel"
@onready var dmgsprite = $stut/damage_skill/dmgskillsprite
@onready var defsprite = $stut/def_skill/defskillsprite
@onready var spsprite = $stut/special_skill/spskillsprite
@onready var skillinfolabel = $stut/Panel/skillinfolabel
@onready var moneylabel = $moneylabel
@onready var shop = $CanvasLayer/shop
@onready var cloathes = $CanvasLayer/cloathes
@onready var cloathesitemlist = $CanvasLayer/cloathes/CloathesItemList
@onready var shopitemlist = $CanvasLayer/shop/shopItemList



var moneysprite = preload("res://Спрайты/icon_20250215202110.png")

var dmgskillmenuopen: bool = false
var defskillmenuopen: bool = false
var spskillmenuopen: bool = false
var skillmenuopen: bool = false

#атака
var fizpoint: String = "Плечо силы (Физика " + str(Global.fizpoint) + ")"
var algebpoint: String = "Н-ный период y=sinx (Алгебра " + str(Global.algebpoint) + ")"
var himpoint: String = "Серная кислота (Химия " + str(Global.himpoint) + ")"

#защита
var geompoint: String = "Укромный угол (Геометрия " + str(Global.geompoint) + ")"
var objpoint: String = "Избежание опасности (ОБЖ " + str(Global.objpoint) + ")"
var biopoint: String = "Хитин (Биология " + str(Global.biopoint) + ")"

#спешал
var litpoint: String = "Рапсодия победы (Литература " + str(Global.litpoint) + ")"
var histpoint: String = "Исскуство войны (История " + str(Global.histpoint) + ")"
var infpoint: String = "Авторасчет (Информатика " + str(Global.infpoint) + ")"







func _ready() -> void:
	hpbar.max_value = Global.maxhp
	
	if Global.skin2bought == false:
		shopitemlist.add_item("30", Global.skin2)
	if Global.skin3bought == false:
		#shopitemlist.add_item("40", Global.skin3)
		pass
	if Global.skin4bought == false:
		#shopitemlist.add_item("50", Global.skin4)
		pass
	if Global.skin5bought == false:
		#shopitemlist.add_item("60", Global.skin5)
		pass
	
	cloathesitemlist.add_item(" ")
	cloathesitemlist.add_item(" ")
	cloathesitemlist.add_item(" ")
	cloathesitemlist.add_item(" ")

func _process(delta: float) -> void:
	hpbar.value = Global.hpatm
	if dmgskillmenuopen or defskillmenuopen or spskillmenuopen:
		skillmenuopen = true
	else:
		skillmenuopen = false
	
	
	hplabel.text = str(Global.hpatm) + "/" + str(Global.maxhp)
	
	cloathesfunc()
	herospritefunc()
	skillsprite()
	moneylabel.text = str(Global.money)



func _on_stutbutton_pressed() -> void:
	stut.show()
	stutbutton.hide()
	fightbutton.hide()
	cloathesbutton.hide()
	shopbutton.hide()
func _on_fightbutton_pressed():
	if Global.dmgskill == -1 or Global.defskill == -1 or Global.spskill == -1:
		youcnf.text = "НУ НЕ ИДТИ ЖЕ В БОЙ С ПУСТОЙ КНИГОЙ"
		await get_tree().create_timer(2).timeout
		youcnf.text = ""
	elif Global.hpatm > 0:
		Global.fightisgoing = true
		get_tree().change_scene_to_file("res://Сцены/fight.tscn")
	else:
		youcnf.text = "ВЫ НЕ МОЖЕТЕ ДРАТЬСЯ
ЗДОРОВЬЯ НЕМА"
		await get_tree().create_timer(2).timeout
		youcnf.text = ""
func _on_shopbutton_pressed() -> void:
	shop.show()
	stutbutton.hide()
	fightbutton.hide()
	cloathesbutton.hide()
	shopbutton.hide()
func _on_cloathesbutton_pressed() -> void:
	cloathes.show()
	stutbutton.hide()
	fightbutton.hide()
	cloathesbutton.hide()
	shopbutton.hide()


func _on_stutbackbutton_pressed() -> void:
	stut.hide()
	stutbutton.show()
	fightbutton.show()
	cloathesbutton.show()
	shopbutton.show()
func _on_exitbutton_pressed() -> void:
	Global.save_game()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
func _on_shopbackbutton_pressed():
	shop.hide()
	stutbutton.show()
	fightbutton.show()
	cloathesbutton.show()
	shopbutton.show()
func _on_cloathesbackbutton_pressed():
	cloathes.hide()
	stutbutton.show()
	fightbutton.show()
	cloathesbutton.show()
	shopbutton.show()



func _on_damage_skill_pressed() -> void:
	if dmgskillmenuopen:
		itemlist.clear()
		skillinfolabel.text = " "
		dmgskillmenuopen = false
	elif skillmenuopen:
		itemlist.clear()
		skillinfolabel.text = " "
		itemlist.add_item(fizpoint, Global.item_texture0)
		itemlist.add_item(algebpoint, Global.item_texture1)
		itemlist.add_item(himpoint, Global.item_texture2)
		dmgskillmenuopen = true
		defskillmenuopen = false
		spskillmenuopen = false
	else:
		itemlist.add_item(fizpoint, Global.item_texture0)
		itemlist.add_item(algebpoint, Global.item_texture1)
		itemlist.add_item(himpoint, Global.item_texture2)
		dmgskillmenuopen = true
func _on_def_skill_pressed() -> void:
	if defskillmenuopen:
		itemlist.clear()
		skillinfolabel.text = " "
		defskillmenuopen = false
	elif skillmenuopen:
		itemlist.clear()
		skillinfolabel.text = " "
		itemlist.add_item(geompoint, Global.item_texture3)
		itemlist.add_item(objpoint, Global.item_texture4)
		itemlist.add_item(biopoint, Global.item_texture5)
		dmgskillmenuopen = false
		defskillmenuopen = true
		spskillmenuopen = false
	else:
		itemlist.add_item(geompoint, Global.item_texture3)
		itemlist.add_item(objpoint, Global.item_texture4)
		itemlist.add_item(biopoint, Global.item_texture5)
		defskillmenuopen = true
func _on_special_skill_pressed() -> void:
	if spskillmenuopen:
		itemlist.clear()
		skillinfolabel.text = " "
		spskillmenuopen = false
	elif skillmenuopen:
		itemlist.clear()
		skillinfolabel.text = " "
		itemlist.add_item(litpoint, Global.item_texture6)
		itemlist.add_item(histpoint, Global.item_texture7)
		itemlist.add_item(infpoint, Global.item_texture8)
		dmgskillmenuopen = false
		defskillmenuopen = false
		spskillmenuopen = true
	else:
		itemlist.add_item(litpoint, Global.item_texture6)
		itemlist.add_item(histpoint, Global.item_texture7)
		itemlist.add_item(infpoint, Global.item_texture8)
		spskillmenuopen = true


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
func herospritefunc():
	herosprite.texture = Global.herospriteatm

func opisanie(kind, index):
	if kind == 0:
		if index == 0:
			skillinfolabel.text = "НАНОСИТ ОДИН МОЩНЫЙ УДАР"
		if index == 1:
			skillinfolabel.text = "НАНОСИТ МНОЖЕСТВО СЛАБЫХ УДАРОВ"
		if index == 2:
			skillinfolabel.text = "НАКЛАДЫВАЕТ ЯД"
	if kind == 1:
		if index == 0:
			skillinfolabel.text = "ДАЕТ ЩИТЫ НА ОДИН ХОД"
		if index == 1:
			skillinfolabel.text = "ДАЕТ УКЛОНЕНИЕ НА ОДИН ХОД"
		if index == 2:
			skillinfolabel.text = "ПОНИЖАЕТ ПОЛУЧАЕМЫЙ УРОН НА ДВА ХОДА (НЕ СКЛАДЫВАЕТСЯ)"
	if kind == 2:
		if index == 0:
			skillinfolabel.text = "ДАЕТ СИЛУ"
		if index == 1:
			skillinfolabel.text = "ДАЕТ ЭФФЕКТ БАРРИКАДЫ НА 3 ХОДА (НЕ СКЛАДЫВАЕТСЯ): УСИЛИВАЕТ ЗАЩИТНЫЕ СПОСОБНОСТИ"
		if index == 2:
			skillinfolabel.text = "ПОДРОБНЕЕ ПОКАЗЫВАЕТ ДЕЙСТВИЕ ПРОТИВНИКА, ДЕЙСТВУЕТ 3 ХОДА"


func cloathesfunc():
	if Global.skin2bought:
		cloathesitemlist.set_item_icon(0, Global.cloathessprite1)
		cloathesitemlist.set_item_text(0, Global.cloathes1)
	else:
		cloathesitemlist.set_item_icon(0, moneysprite)
	if Global.skin3bought:
		cloathesitemlist.set_item_icon(1, Global.cloathessprite2)
		cloathesitemlist.set_item_text(1, Global.cloathes2)
	else:
		cloathesitemlist.set_item_icon(1, moneysprite)
	if Global.skin4bought:
		cloathesitemlist.set_item_icon(2, Global.cloathessprite3)
		cloathesitemlist.set_item_text(2, Global.cloathes3)
	else:
		cloathesitemlist.set_item_icon(2, moneysprite)
	if Global.skin5bought:
		cloathesitemlist.set_item_icon(3, Global.cloathessprite4)
		cloathesitemlist.set_item_text(3, Global.cloathes4)
	else:
		cloathesitemlist.set_item_icon(3, moneysprite)
	




func _on_cloathes_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var sprite = Global.herospriteatm
	var skinname: String = Global.skinname
	if index == 0 and Global.skin2bought:
		Global.herospriteatm = cloathesitemlist.get_item_icon(index)
		Global.skinname = cloathesitemlist.get_item_text(index)
		Global.cloathessprite1 = sprite
		Global.cloathes1 = skinname


func _on_shop_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var cost = int(shopitemlist.get_item_text(index))
	if Global.money >= cost:
		shopitemlist.remove_item(index)
		Global.money -= cost
		if cost == 30:
			Global.skin2bought = true
			Global.cloathes1 = Global.skin2name
			Global.cloathessprite1 = Global.skin2
		if cost == 40:
			Global.skin3bought = true
			Global.cloathes2 = Global.skin3name
			Global.cloathessprite2 = Global.skin3
		if cost == 50:
			Global.skin4bought = true
			Global.cloathes3 = Global.skin4name
			Global.cloathessprite3 = Global.skin4
		if cost == 60:
			Global.skin5bought = true
			Global.cloathes2 = Global.skin5name
			Global.cloathessprite2 = Global.skin5


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if dmgskillmenuopen:
		Global.dmgskill = index
		opisanie(0, index)
	if defskillmenuopen:
		Global.defskill = index
		opisanie(1, index)
	if spskillmenuopen:
		Global.spskill = index
		opisanie(2, index)
