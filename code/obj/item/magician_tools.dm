/obj/item/clothing/head/magician_tophat
	name = "magician's tophat"
	desc = "A magically looking hat."
	wear_image_icon = 'icons/mob/head.dmi'
	icon_state = "magician_tophat"
	item_state = "magician_tophat"

	april_fools
		desc = "A shinier version of a magically looking hat."
		icon_state = "magician_tophat-alt"
		item_state = "magician_tophat-alt"

/obj/item/clothing/head/magician_tophat/long
	name = "magician's long tophat"
	desc = "When you look at this hat you can only think of how many mice you could fit in it."
	wear_image_icon = 'icons/mob/bighat.dmi'
	icon_state = "magician_ltophat"
	item_state = "magician_ltophat"

	april_fools
		desc = "When you look at this hat you can only think of how many cockroaches you could fit in it."
		icon_state = "magician_ltophat-alt"
		item_state = "magician_ltophat-alt"

// Trashbag-like-magician-hat above!

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

// Wanna add additional features; quite like - clicking on a reagent-container transfers all reagents or into the users body.
