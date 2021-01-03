/obj/item/magician_tools/wand
	name = "magician's wand"
	icon = 'icons/obj/items/sparklers.dmi'
	inhand_image_icon = 'icons/obj/items/sparklers.dmi'
	icon_state = "magician_wand"
	item_state = "magician_wand"
	flags = FPRINT | TABLEPASS| CONDUCT | ONBELT
	force = 4.0
	stamina_damage = 10
	stamina_cost = 4
	stamina_crit_chance = 5
	hitsound = 'sound/impact_sounds/Slap.ogg'
	w_class = 3.0
	throwforce = 3.0
	throw_range = 15
	throw_speed = 3
	desc = "A cheap toy. This is an unlicensed knock-off magic-wand."
	//m_amt = 50
	//g_amt = 20
	//mats = list("CRY-1", "CON-2")

	New()
		..()
		src.setItemSpecial(/datum/item_special/wandspark)
