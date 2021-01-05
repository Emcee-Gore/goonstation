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

	var/max_stuff = 5 // can't hold more than this many stuff
	var/current_stuff = 0 // w_class is added together here, not allowed to add something that would put this > max_stuff

	// proc/shit_goes_everywhere_hat()
 	// 	src.visible_message("<span class='alert'>Everything inside [src] comes out flying!</span>")
 	// 	return
	proc/shit_goes_everywhere_hat()
	 	return

	get_desc(dist)
		..()
		if (dist <= 2)
			if (src.current_stuff > src.max_stuff)
				. += "All the stuff inside is spilling out!"
				src.remove_random_item() // dunno how this would even happen but uhh there, there you go. a way to remove items if there's too much in there! :v
			else if (src.current_stuff == src.max_stuff)
				. += "It's totally full."
			else
				. += "It's [get_fullness(current_stuff / max_stuff * 100)]."

	equipped(var/mob/user)
		..()
		if (src.contents.len)
			for (var/i=src.contents.len, i>0, i--)
				if (prob(66))
					continue
				else
					src.remove_random_item(user)
			src.calc_w_class(user)

	attackby(obj/item/W as obj, mob/user as mob)
		if (W.cant_self_remove)
			boutput(user, "<span class='alert'>You can't get [W] to come off of you!</span>")
			return
		else if ((src.current_stuff + W.w_class) > src.max_stuff) // we too full
			boutput(user, "<span class='alert'>\The [src] is too full for [W] to fit!</span>")
			return
		else
			if (istype(src.loc, /obj/item/storage))
				var/obj/item/storage/S = src.loc
				if (S.max_wclass < W.w_class) // too big to fit in the thing we're in already!
					boutput(user, "<span class='alert'>You can't fit [W] in [src] while [src] is inside [S]!</span>")
					return
			user.u_equip(W)
			W.set_loc(src)
			playsound(src.loc, "rustle", 50, 1, -5)
			boutput(user, "You stuff [W] into [src].")
			if (ishuman(src.loc)) // person be wearin this
				var/mob/living/carbon/human/H = src.loc
				if (H.w_uniform == src)
					if (prob(66))
						src.remove_random_item(H)
			src.calc_w_class(user)

	attack_hand(mob/user as mob)
		if (!user.find_in_hand(src))
			return ..()
		if (!src.contents.len)
			boutput(user, "<span class='alert'>\The [src] is empty!</span>")
			return
		else
			var/obj/item/I = pick(src.contents)
			playsound(src.loc, "rustle", 50, 1, -5)
			var/flavor = rand(1,13)
			switch (flavor)
				if (1)
					flavor = "mischievously"
				if (2)
					flavor = "hastily"
				if (3)
					flavor = "furiously"
				if (4)
					flavor = "strangely"
				if (5)
					flavor = "creatively"
				if (6)
					flavor = "sneakily"
				if (7)
					flavor = "skillfully"
				if (8)
					flavor = "mysteriously"
				if (9)
					flavor = "wonderfully"
				if (10)
					flavor = "competently"
				if (11)
					flavor = "masterfully"
				if (12)
					flavor = "dexteriously"
				if (13)
					flavor = "nimbly"
				else
					flavor = "brokenly" //This better be not happening! D:
			var/hex = rand(1,8)
			switch (hex)
				if (1)
					hex = "<font color='#FF0000'>"
				if (2)
					hex = "<font color='#FF9900'>"
				if (3)
					hex = "<font color='#FFff00'>"
				if (4)
					hex = "<font color='#00FF00'>"
				if (5)
					hex = "<font color='#0000FF'>"
				if (6)
					hex = "<font color='#FF00FF'>"
				if (7)
					hex =	"<font color='#660066'>"
				if (8)
					hex = "<font color='#000000'>"

			boutput(user, "You rummage around [hex]<i>[flavor]</i></font> in [src] and pull out [I].")
			user.put_in_hand_or_drop(I)
		if (src.contents.len && ishuman(src.loc)) // person be wearin this
			var/mob/living/carbon/human/H = src.loc
			if (H.w_uniform == src)
				if (prob(66))
					src.remove_random_item(user)
		src.calc_w_class(user)

	proc/calc_w_class(var/mob/user)
		src.current_stuff = 0
		if (!src.contents.len)
			src.w_class = 1.0
			if (ishuman(user))
				var/mob/living/carbon/human/H = user
				if (H.w_uniform == src)
					return
			if (ismob(user))
				user.update_inhands()
			return
		// can maybe do something more interesting later than just "as big as the biggest thing inside" later but idc right now
		for (var/obj/item/I in src.contents)
			src.w_class = max(I.w_class, src.w_class) // as it turns out there are some w_class things above 5 so fuck it this is just a max() now
			src.current_stuff += I.w_class
			tooltip_rebuild = 1
		if (src.contents.len == 1)
			if (ismob(user))
				user.update_inhands()

	proc/remove_random_item(var/mob/user)
		if (!src.contents.len)
			return
		var/atom/movable/A = pick(src.contents)
		if (A)
			if (user)
				user.visible_message("\An [A] falls out of [user]'s [src.name]!",\
				"<span class='alert'>\An [A] falls out of your [src.name]!</span>")
			else
				src.loc.visible_message("\An [A] falls out of [src]!")
			A.set_loc(get_turf(src))

	MouseDrop(atom/over_object, src_location, over_location)
		..()
		if (!usr || usr.stat || usr.restrained() || get_dist(src, usr) > 1 || get_dist(usr, over_object) > 1)
			return
		if (usr.is_in_hands(src))
			var/turf/T = over_object
			if (istype(T, /obj/table))
				T = get_turf(T)
			if (!(usr in range(1, T)))
				return
			if (istype(T))
				for (var/obj/O in T)
					if (O.density && !istype(O, /obj/table) && !istype(O, /obj/rack))
						return
				if (!T.density)
					return//usr.visible_message("<span class='alert'>[usr] dumps the contents of [src] onto [T]!</span>")

	// proc/shit_goes_everywhere_hat()
	// 	src.visible_message("<span class='alert'>Everything inside [src] comes out flying!</span>")
	// 	for (var/i = 1, i <= ordered_contents.len, i++)
	// 		throw_targets += get_offset_target_turf(src.loc, rand(throw_dist)-rand(throw_dist), rand(throw_dist)-rand(throw_dist))

	// 	while (ordered_contents.len > 0)
	// 		var/obj/item/F = ordered_contents[1]
	// 		src.remove_contents(F)
	// 		src.update_icon()
	// 		F.set_loc(get_turf(src))
	// 		F.throw_at(pick(throw_targets), 5, 1)


		// 	attack(mob/M as mob, mob/user as mob)
		// if(user.a_intent == INTENT_HARM)
		// 	if(M == user)
		// 		boutput(user, "<span class='alert'><B>You smash [src] over your own head!</b></span>")
		// 	else
		// 		M.visible_message("<span class='alert'><B>[user] smashes [src] over [M]'s head!</B></span>")
		// 		logTheThing("combat", user, M, "smashes [src] over [constructTarget(M,"combat")]'s head! ")
		// 	if(ordered_contents.len != 0)
		// 		src.shit_goes_everywhere()
		// 	unique_attack_garbage_fuck(M, user)
		// else
		// 	M.visible_message("<span class='alert'>[user] taps [M] over the head with [src].</span>")
		// 	unique_tap_garbage_fluck(M,user)
		// 	logTheThing("combat", user, M, "taps [constructTarget(M,"combat")] over the head with [src].")


//1. when *twirl emote then squatter all items around
//2. Flavor-text when pulling out of the hat.
//3. Reducing max items inside hat.

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
