// proc/magic_color_call(color)
// 	var/color = rand(1,5)
// 	switch (color)
// 		if (1)
// 			color = "<font color='#27fdf5'>"
// 		if (2)
// 			color = "<font color='#a8f6f8'>"
// 		if (3)
// 			color = "<font color='#d7fffe'>"
// 		if (4)
// 			color = "<font color='#f98dc9'>"
// 		if (5)
// 			color = "<font color='#f765b8'>"

//	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	* HELP PROCS!

/obj/item/clothing/head/magician_tophat
	name = "magician's tophat"
	desc = "A magically looking hat."
	wear_image_icon = 'icons/mob/head.dmi'
	icon_state = "magician_tophat"
	item_state = "magician_tophat"
	setupProperties()
		..()
		setProperty("meleeprot_head", 1)
		setProperty("coldprot", 10)
		setProperty("heatprot", 5)

	april_fools
		desc = "A shinier version of a magically looking hat."
		icon_state = "magician_tophat-alt"
		item_state = "magician_tophat-alt"

	var/max_stuff = 5 // can't hold more than this many stuff
	var/current_stuff = 0 // w_class is added together here, not allowed to add something that would put this > max_stuff

	// var/list/ordered_contents = list()
	var/list/throw_targets = list()
	var/throw_dist = 3

	proc/shit_hat(var/mob/user) //Sehr viel Hass und Liebe!
		if (!src.contents.len)
			user.visible_message("<span class='alert'>A bunch of daunting air bursts out of the [src]!</span>")
			src.calc_w_class(user)
			return
		else
			user.visible_message("<span class='alert'>Everything inside [src] comes out flying!</span>")
		while (src.contents.len)
			throw_targets += get_offset_target_turf(src.loc, rand(throw_dist)-rand(throw_dist), rand(throw_dist)-rand(throw_dist))
		//	var/atom/movable/A = pick(src.contents)
			var/obj/item/A = pick(src.contents)
			if (A)
				A.set_loc(get_turf(src))
				A.throw_at(pick(throw_targets), 5, 1)
				throw_targets = null
		src.calc_w_class(user)

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
			//. += "It's [get_fullness(current_stuff / max_stuff * 100)]."
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
			var/hex = rand(1,5)
			switch (hex)
				if (1)
					hex = "<font color='#27fdf5'>"
				if (2)
					hex = "<font color='#a8f6f8'>"
				if (3)
					hex = "<font color='#d7fffe'>"
				if (4)
					hex = "<font color='#f98dc9'>"
				if (5)
					hex = "<font color='#f765b8'>"
				// if (1)
				// 	hex = "<font color='#FF0000'>"
				// if (2)
				// 	hex = "<font color='#FF9900'>"
				// if (3)
				// 	hex = "<font color='#FFff00'>"
				// if (4)
				// 	hex = "<font color='#00FF00'>"
				// if (5)
				// 	hex = "<font color='#0000FF'>"
				// if (6)
				// 	hex = "<font color='#FF00FF'>"
				// if (7)
				// 	hex =	"<font color='#d73715'>"
				// if (8)
				// 	hex = "<font color='#8d1422'>"
				// if (9)
				// 	hex = "<font color = '#8c139a'>"
				// if (10)
				// 	hex = "<font color = '#411068'>"

			//boutput(user, "You rummage around [hex]<i>[flavor]</i></font> in [src] and pull out [I].")
			var/output = rand(1,3)
			switch (output)
				if (1)
					boutput(user, "Yo[hex]u</font> rum[hex]m</font>age ar[hex]ou</font>n[hex]d</font> [hex]<b>[flavor]</b></font> i[hex]n</font> [src] and p[hex]ul</font>l ou[hex]t</font> [I].")
				if (2)
					boutput(user, "Y[hex]ou</font> r[hex]u</font>mm[hex]ag</font>e a[hex]rou</font>nd [hex]<b>[flavor]</b></font> i[hex]n</font> [src] and p[hex]ul</font>l [hex]o</font>ut [hex][I].</font>")
				if (3)
					boutput(user, "[hex]Y</font>o[hex]u</font> r[hex]u</font>m[hex]mage</font> ar[hex]o</font>u[hex]nd</font> [hex]<b>[flavor]</b></font> in [hex][src]</font> an[hex]d p</font>ul[hex]l</font> o[hex]u</font>t [I].")
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

/obj/item/clothing/head/magician_tophat/long
	name = "magician's long tophat"
	desc = "When you look at this hat you can only think of how many mice you could fit in it."
	wear_image_icon = 'icons/mob/bighat.dmi'
	icon_state = "magician_ltophat"
	item_state = "magician_ltophat"
	setupProperties()
		..()
		setProperty("meleeprot_head", 1)
		setProperty("coldprot", 10)
		setProperty("heatprot", 5)

	april_fools
		desc = "When you look at this hat you can only think of how many cockroaches you could fit in it."
		icon_state = "magician_ltophat-alt"
		item_state = "magician_ltophat-alt"

// Trashbag-like-magician-hat above!

/obj/item/clothing/under/rank/magician
	icon = 'icons/obj/clothing/uniforms/item_js_rank.dmi'
	wear_image_icon = 'icons/mob/jumpsuits/worn_js_rank.dmi'
	inhand_image_icon = 'icons/mob/inhand/jumpsuit/hand_js_rank.dmi'
	name = "magician's suit"
	desc = "Too many nights and too much booze, but the show must go on!"
	icon_state = "magician"
	item_state = "magician"
	setupProperties()
		..()
		setProperty("meleeprot", 1)
		setProperty("coldprot", 5)
		setProperty("heatprot", 5)

	april_fools
		desc = "Only the most fancy suit for the most handsome entertainer!"
		icon_state = "magician-alt"
		item_state = "magician-alt"

/obj/item/clothing/suit/magician
	icon = 'icons/obj/clothing/overcoats/item_suit.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit.dmi'
	setupProperties()
		..()
		setProperty("meleeprot", 2)
		setProperty("coldprot", 10)
		setProperty("heatprot", 10)
	name = "magician's cape"
	desc = "A fancy cape and jacket to keep the cold of space kinda outside and the warmth of magic definitely inside your heart!"
	icon_state = "magician_cape"
	item_state = "magician_cape"

	april_fools
		desc = "One has to wonder if the shiny coat of paint helps to keep you warm or not."
		icon_state = "magician_cape-alt"
		item_state = "magician_cape-alt"

// Magician's suit and cape above! Wooh!
//
//
//
//

/obj/item/clothing/head/magician_tophat/syndicate
	wear_image_icon = 'icons/mob/bighat.dmi'
	icon_state = "magician_ltophat"
	item_state = "magician_ltophat"
	max_stuff = 20
	desc = "Not only is this large tophat one of the most fancy gizmos the Syndicate has been able to produce but one has to wonder how they managed to cram a tiny storage dimension into this most magical piece of headwear!"
	c_flags = SPACEWEAR
	name = "shiny magician's long tophat"
	mat_changename = 0
	mat_changedesc = 0
	mat_appearances_to_ignore = list("gold")
	setupProperties()
		..()
		src.setMaterial(getMaterial("gold"))
		setProperty("meleeprot_head", 3)
		setProperty("rangedprot", 1)
		setProperty("coldprot", 15)
		setProperty("heatprot", 10)

/obj/item/clothing/suit/magician/syndicate
	protective_temperature = 4000
	icon_state = "magician_cape"
	item_state = "magician_cape"
	desc = "Tailored by the most advanced robots of the Syndicate - this cape and jacket will not just protect you from the demoralizing coldness of space but also from the heat of NanoTrasen security officers!"
	c_flags = SPACEWEAR
	name = "shiny magician's cape"
	mat_changename = 0
	mat_changedesc = 0
	mat_appearances_to_ignore = list("gold")
	setupProperties()
		..()
		src.setMaterial(getMaterial("gold"))
		setProperty("meleeprot", 5)
		setProperty("coldprot", 30)
		setProperty("heatprot", 30)

/obj/item/clothing/under/rank/magician/syndicate
	icon_state = "magician"
	item_state = "magician"
	desc = "This neat suit is quite bedazzling! The clothing tag is decorated with the most finest shapes and on closer inspection a red 'S' can be noticed, hinting to the origins of this handsome piece of clothing."
	name = "shiny magician's suit"
	mat_changename = 0
	mat_changedesc = 0
	mat_appearances_to_ignore = list("gold")
	setupProperties()
		..()
		src.setMaterial(getMaterial("gold"))
		setProperty("meleeprot", 3)
		setProperty("coldprot", 25)
		setProperty("heatprot", 20)

/obj/item/clothing/gloves/yellow/syndicate_magician
	desc = "These gloves have been prepared by Syndicate engineers to ensure every trusty magician is able to have a shockingly-safe time during deployment!"
	name = "magician's shockingly-safe gloves"
	material_prints = "insulative fibers and a hint of white paint"
	icon_state = "latex"
	item_state = "lgloves"
	can_be_charged = 1

/obj/item/storage/box/syndicate_magician
	name = "syndicate magician's special suit-set"
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "magician"
	inhand_image_icon = 'icons/mob/inhand/hand_storage.dmi'
	item_state = "box"
	desc = "Inside this tiny box awaits a whole lot of magical fun! A set of clothes of great magnitude await the upcoming Syndicate entertainer!"
	spawn_contents = list(/obj/item/clothing/head/magician_tophat/syndicate,\
	/obj/item/clothing/under/rank/magician/syndicate,\
	/obj/item/clothing/suit/magician/syndicate,\
	/obj/item/clothing/gloves/yellow/syndicate_magician)

	// Syndicate gear above! D:<
	//
	//
	//
	//

/obj/item/magician_tools/wand
	name = "magician's wand"
	icon = 'icons/obj/items/sparklers.dmi'
	inhand_image_icon = 'icons/obj/items/sparklers.dmi'
	icon_state = "magician_wand"
	item_state = "magician_wand"
	flags = FPRINT | TABLEPASS| CONDUCT | ONBELT
	force = 3.0
	stamina_damage = 10
	stamina_cost = 4
	stamina_crit_chance = 5
	hitsound = "punch"
	w_class = 3.0
	throwforce = 3.0
	throw_range = 15
	throw_speed = 3
	desc = "A cheap toy. This is an unlicensed knock-off magic-wand."
	//m_amt = 50
	//g_amt = 20
	//mats = list("CRY-1", "CON-2")
	//var/heal_amt = 10

	var/list/vomit_prizes = list(/obj/item/canned_laughter/crushed,\
	/obj/item/cigbutt,\
	/obj/item/coin,\
	/obj/item/dice,\
	/obj/item/dice/d10,\
	/obj/item/dice/d12,\
	/obj/item/dice/d4,\
	/obj/item/dice/d8,\
	/obj/item/casing/small,\
	/obj/item/reagent_containers/balloon,\
	/obj/item/kitchen/utensil/knife/plastic,\
	/obj/item/kitchen/utensil/fork/plastic,\
	/obj/item/kitchen/utensil/spoon/plastic,\
	/obj/item/hairball,\
	/obj/item/match,\
	/obj/item/reagent_containers/food/drinks/paper_cup)
	var/list/vomit_prizes_rare = list(/obj/item/toy/plush/small/stress_ball,\
	/obj/item/pen/crayon/random,\
	/obj/item/dice/d20,\
	/obj/item/scrap,\
	/obj/item/casing,\
	/obj/item/casing/rifle,\
	/obj/item/device/light/glowstick/green_on,\
	/obj/item/spacecash/random/really_small,\
	/obj/item/spacecash/random/small,\
	/obj/item/reagent_containers/food/drinks/duo)
	var/list/vomit_prizes_ultra_rare = list(/obj/item/pen/crayon/rainbow,\
	/obj/item/dice/magic8ball,\
	/obj/item/dice/d100,\
	/obj/item/canned_laughter,\
	/obj/item/ticket/golden,\
	/obj/item/spacecash/five,\
	/obj/item/bluntwrap,\
	/obj/item/reagent_containers/food/snacks/pickle/trash,\
	/obj/item/reagent_containers/pill/cyberpunk)

	var/Spell = null //Checks if spells were successfully cast! Leave like this.

	New()
		..()
		START_TRACKING
		src.setItemSpecial(/datum/item_special/wandspark)

	disposing()
		..()
		STOP_TRACKING


	proc/vomitcast(mob/M as mob, var/mob/user, var/vomit_amount=0) //var/exclude_center=1
		var/mob/living/affected_mob = M
		if( istype(affected_mob) )
			if(vomit_amount < 1) //Set maximum vomit around.
				var/Vomit_Spot = pick(alldirs)
				var/turf/T = get_step(affected_mob, Vomit_Spot)
				if(isfloor(T))
					if (prob(20))
						make_cleanable( /obj/decal/cleanable/greenpuke,T)
					else
						make_cleanable( /obj/decal/cleanable/vomit,T)
					vomit_amount = 1
					playsound(affected_mob.loc, "sound/misc/meat_plop.ogg", 25, 0)
					playsound(src.loc, "sound/impact_sounds/Slimy_Splat_1.ogg", 25, 1)

					var/obj/item/P = pick(prob(20) ? (prob(33) ? vomit_prizes_ultra_rare : vomit_prizes_rare) : vomit_prizes)
					P = new P(T)
					P.pixel_y = rand(-6,4)
					P.pixel_x = rand(-8,8)

					var/hex = rand(1,5)
					switch (hex)
						if (1)
							hex = "<font color='#27fdf5'>"
						if (2)
							hex = "<font color='#a8f6f8'>"
						if (3)
							hex = "<font color='#d7fffe'>"
						if (4)
							hex = "<font color='#f98dc9'>"
						if (5)
							hex = "<font color='#f765b8'>"

					var/hex2 = rand(1,5)
					switch (hex2)
						if (1)
							hex2 = "<font color='#27fdf5'>"
						if (2)
							hex2 = "<font color='#a8f6f8'>"
						if (3)
							hex2 = "<font color='#d7fffe'>"
						if (4)
							hex2 = "<font color='#f98dc9'>"
						if (5)
							hex2 = "<font color='#f765b8'>"

					//M.visible_message("<span class='notice'>You tap yourself violently with the [src] and begin to feel really ill - so you vomit up [P]!</span>")
					//M.visible_message("<span class='notice'>[user] taps [M] harshly with [src]. The Magician murmurs something and suddenly [M] begins to vomit up [P]!</span>")
					if (M == user)
						var/output = rand(1,3)
						switch (output)
							if (1)
								M.visible_message("<span class='notice'>Y[hex]ou</font> t[hex]a</font>p yo[hex]u</font>rse[hex]lf v</font>iol[hex]e</font>ntly wi[hex]th</font> th[hex2]e [src] an</font>d b[hex]e</font>gin to f[hex]eel</font> re[hex]a</font>lly i[hex]ll</font> - s[hex]o y</font>ou v[hex]omi</font>t u[hex]p <b>[P]</b>!</font></span>")
							if (2)
								M.visible_message("<span class='notice'>[hex]Y</font>ou [hex]tap</font> your[hex]self</font> vi[hex]o</font>lently wi[hex]t</font>h th[hex2]e [src] an</font>d beg[hex]i</font>n to [hex]f</font>eel re[hex]ally</font> ill [hex]- so y</font>ou vo[hex]mit u</font>p [hex2]<b>[P]</b></font>!</span>")
							if (3)
								M.visible_message("<span class='notice'>You t[hex]ap yo</font>ursel[hex]f vio</font>len[hex]tl</font>y with [hex]th</font>e [hex2][src] and b</font>egin to f[hex]eel</font> r[hex]e</font>ally ill - so [hex]you</font> vom[hex]it u</font>p [hex2]<b>[P]</b></font>!</span>")
					else
						var/output = rand(1,3)
						switch (output)
							if (1)
								M.visible_message("<span class='notice'>[user] t[hex]ap</font>s [hex2]<b>[M]</b> h</font>arsh[hex]ly w</font>ith [src]. T[hex]h</font>e Mag[hex]ic</font>ia[hex]n mu</font>rmurs [hex]some</font>thi[hex]ng</font> an[hex]d</font> su[hex]dd</font>enly [M] be[hex]gin</font>s to vomit [hex2]up <b>[P]</b></font>!</span>")
							if (2)
								M.visible_message("<span class='notice'>[user] [hex]taps</font> [M] har[hex]shly</font> w[hex]i</font>th [hex2][src]. T</font>he Magic[hex]ian mu</font>rmurs [hex]so</font>mething [hex]and</font> su[hex]d</font>de[hex]nl</font>y [hex2]<b>[M]</b> begi</font>ns t[hex]o</font> vo[hex]mit</font> up [hex2]<b>[P]</b></font>!</span>")
							if (3)
								M.visible_message("<span class='notice'>[user] tap[hex2]s <b>[M]</b></font> ha[hex]rsh</font>l[hex]y</font> wi[hex]t</font>h [src]. [hex]The Ma</font>gician murmurs s[hex]omet</font>hin[hex]g a</font>nd [hex]sudd</font>enl[hex2]y <b>[M]</b> beg</font>ins to [hex]vomit</font> u[hex2]p <b>[P]</b>!</font></span>")

				else //Fail condition if you are just surrounded by walls or the mob you targeted is!
					if (M == user)
						boutput(M, "<span class='notice'>Not even magical enough to amaze yourself, huh?!</span>")
					else
						M.visible_message("<span class='alert'>[user] hits [M] with [src] but nothing happens! Silly magician!?</span>")
					Spell = "fail"
					return
			var/nutrition = rand(3,5)
			affected_mob.nutrition -= nutrition
			Spell = "success"
			return


	attack(mob/M as mob, mob/user as mob)
		var/magician = 0
		var/mob/H = M

		if (user.bioHolder && user.bioHolder.HasEffect("clumsy") && prob(40)) //Honk!
			user.visible_message("<span class='alert'><b>[user]</b> fumbles and drops the fizzling [src] on \his foot.</span>")
			playsound(src.loc, "punch", 25, 1, -1)
			playsound(src.loc, 'sound/effects/sparks5.ogg', 35, 1, -1)
			random_burn_damage(user, 5)
			user.changeStatus("stunned", 3 SECONDS)
			user.emote("scream")
			user.drop_item(src)
			JOB_XP(user, "Clown", 1)
			return

		if (user.traitHolder && user.traitHolder.hasTrait("training_magician"))
			magician = 1

		if (!magician && !isdead(M)) //None magician attacking somebody with the wand! Weapon-time!
			if (M == user)
				boutput(M, "<span class='alert'>Stop hitting yourself with [src]!</span>")
			else
				M.visible_message("<span class='alert'>[user] slaps [M] with [src] like it is an amazing sword! Silly!</span>")
				boutput(M, "<span class='alert'>[user] hits you with the blunt force of [src]! Oof!</span>")
			playsound(src.loc, "punch", 25, 1, -1)
			user.remove_stamina(4)
			M.remove_stamina(10)
			random_brute_damage(M, 3)
			return

		else if (isdead(M)) //Corpse beatings!
			M.visible_message("<span class='alert'><B>[user] pokes [M]'s lifeless corpse with [src].</B></span>")
			if (narrator_mode)
				playsound(src.loc, 'sound/vox/hit.ogg', 25, 1, -1)
			else
				playsound(src.loc, "punch", 25, 1, -1)
				user.remove_stamina(4)
				random_brute_damage(M, 3)
			return

		else if (!isdead(M) && magician == 1) //Spell cast! * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
			if ((ishuman(H)))
				if (prob(15)) //Add switch and different spells here.
					vomitcast(M, user) //! ! ! VOMITCAST ! ! !
					logTheThing("combat", user, M, "cast vomit magic on [constructTarget(M,"combat")]")

					if (Spell == "success")	//Spell cast and success!
						playsound(src.loc, 'sound/impact_sounds/Slap.ogg', 40, 1)
						var/turf = M.loc
						magicspark(turf,0, power=2, exclude_center = 0)
						user.remove_stamina(10)
						M.remove_stamina(12)
						random_brute_damage(M, 1)
						random_burn_damage(M, rand(1,3))
						Spell = null

					if (Spell == "fail")	//Spell cast but fail condition within proc activated!
						playsound(src.loc, "punch", 25, 1, -1)
						user.remove_stamina(4)
						M.remove_stamina(10)
						random_brute_damage(M, 3)
						Spell = null

				else	//Spell not cast! General fail!
					if (M == user)
						boutput(M, "<span class='notice'>Not even magical enough to amaze yourself, huh?</span>")
					else
						M.visible_message("<span class='alert'>[user] hits [M] with [src] but nothing happens! Silly magician!</span>")
						boutput(M, "<span class='alert'>The magician [user] tries his best - but is unable to display his skills! What a shame! Ouch!</span>")
					if (narrator_mode)
						playsound(src.loc, 'sound/vox/hit.ogg', 25, 1, -1)
					else
						playsound(src.loc, "punch", 25, 1, -1)
						user.remove_stamina(4)
						M.remove_stamina(10)
						random_brute_damage(M, 3)

// Wanna add additional features; quite like - clicking on a reagent-container transfers all reagents or into the users body.
// Next spell should cause a character to make an animal sound and speak out something of an animal (Cat, Cow, Pig, Woof, Moskito)
// Spell to paint a random equipment item of the targeted player in paint

/obj/item/device/light/candle/mystical
	name = "mystical candle"
	desc = "A common favorite of mystics and cult leaders."
	icon = 'icons/obj/items/alchemy.dmi'
	icon_state = "magic_candle-off"
	icon_off = "magic_candle-off"
	icon_on = "magic_candle"
	col_r = 0.35
	col_g = 0.55
	col_b = 0.95
	brightness = 0.7
	var/did_thing = 0

	New()
		..()

		if (!src.reagents)
			var/datum/reagents/R = new /datum/reagents(50)
			src.reagents = R
			R.my_atom = src

	// yes this is dumb as hell but it makes me laugh a bunch
		src.reagents.add_reagent("wax", 20)
		src.reagents.add_reagent("green_goop", 30)
		return

	light(var/mob/user as mob, var/message as text)
		..()
		if(src.on && src.did_thing)
			src.visible_message("<span class:'notice'>It seems that the unnatural energy of this candle has been used up!</span>")
		if(src.on && !src.did_thing)
			src.did_thing = 1
			playsound(get_turf(src), pick('sound/ambience/station/Station_SpookyAtmosphere1.ogg','sound/ambience/station/Station_SpookyAtmosphere2.ogg'), 65, 0)
			smoke_reaction(src.reagents, 1, get_turf(src), do_sfx = 0)
			..()
		return

// CANDLE-TIME!!!
//
//
//
//

/obj/item/katana/trick_sword
	name = "trick sword"
	desc = "It looks like one of those cheap gimmicky swords - but be warned! The tip of this entertainer's stage-prop is quite pointy indeed."
	icon = 'icons/obj/items/weapons.dmi'
	icon_state = "trick_sword"
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	hit_type = DAMAGE_CUT
	flags = FPRINT | TABLEPASS | NOSHIELD | USEDELAY
	force = 12 //Like the baseball-bat but the real deal here is the bleeding damage further down below!
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	is_syndicate = 1
	contraband = 7 //Fun fact: swallowing this sword makes you 100% less likely to have your sword taken away...unless security forces you to get drunk! D:
	w_class = 6 //Was 4 - but I do not want people to stuff it into their magician's tophat! Either hide it in a trashbag if you are not the magician or swallow it if you are one!
	hitsound = 'sound/impact_sounds/Blade_Small_Bloody.ogg'
	pickup_sfx = "sound/items/blade_pull.ogg"
	delimb_prob = 5

	New()
		..()
		src.setItemSpecial(/datum/item_special/rangestab)

	attack(mob/M as mob, mob/user as mob)
		var/magician = 0

		if (user.traitHolder && user.traitHolder.hasTrait("training_magician"))
			magician = 1

		if (M == user && user.a_intent == INTENT_HELP && magician == 1)
			if (user.wear_mask && user.wear_mask.is_muzzle)
				boutput(user, "<span class='hint'>Swallowing a sword with a mask resting on your face proves to be quite difficult!</span>")
			else
				boutput(user, "<span class='hint'>You swallow trick sword. (Use the burp emote after gulping down the trick sword to retrieve it.)</span>")
				//playsound(M.loc, "sound/voice/gasps/gasp.ogg", 15, 0, 0, M.get_age_pitch())
				user.emote("gasp")
				user.u_equip(src)
				src.set_loc(M)
				src.dropped(user)
		else
			if (iscarbon(M))
				var/mob/living/carbon/C = M
				if (handle_parry(C, user))
					return
				if (!isdead(C))
					take_bleeding_damage(C, user, 7, DAMAGE_STAB)
			..()
			return

/obj/item/katana/trick_sword/suicide(var/mob/living/carbon/human/user as mob) //Swallowing a sword can be dangerous!
	if (!istype(user) || !user.organHolder || !src.user_can_suicide(user))
		return 0
	else
		if (user.wear_mask && user.wear_mask.is_muzzle)
			boutput(user, "<span class='hint'>Clear the path to your mouth before you attempt to kill yourself!</span>")
			return 0
		else
			user.visible_message("<span class='alert'><b>[user] swallows the [pick("dangerous","pointy","terrible")] [pick("trick sword","stage prop")]! [pick("What a show", "Not everyone can make it in the showbusiness", "Someone should look for their assistant")]!</b></span>")
			user.TakeDamage("head", 20, 0)
			user.TakeDamage("chest", 40, 0)
			take_bleeding_damage(user, user, 120, DAMAGE_STAB)

			user.u_equip(src)
			src.set_loc(user)
			src.dropped(user)
			//playsound(user.loc, "sound/voice/gasps/gasp.ogg", 15, 0, 0, user.get_age_pitch())
			user.emote("gasp")

			SPAWN_DBG(10 SECONDS)
			if (user)
				user.suiciding = 0
			return 1
