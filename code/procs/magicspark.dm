var/global/mutable_appearance/magicspark_ma = null

/proc/magicspark(var/atom/center, var/radius = 0, var/power=1, var/exclude_center = 1)//power 1 to 6
	if (!center || center.qdeled || center.pooled || center.disposed)
		return

	var/turf/center_turf = get_turf(center)
	if (!magicspark_ma)
		magicspark_ma = new
		magicspark_ma.name = "electricity"
		magicspark_ma.icon = 'icons/effects/glitter.dmi'
		magicspark_ma.alpha = 255
		magicspark_ma.invisibility = 0
		magicspark_ma.layer = TURF_LAYER
		magicspark_ma.plane = PLANE_OVERLAY_EFFECTS
		magicspark_ma.mouse_opacity = 0

	var/sound = "sound/effects/mag_iceburstlaunch.ogg"
	var/sprite = rand(1,4)
	switch(sprite)
		if (1)
			magicspark_ma.icon_state = "animglitter1"
		if (2)
			magicspark_ma.icon_state = "animglitter2"
		if (3)
			magicspark_ma.icon_state = "animglitter3"
		if (4)
			magicspark_ma.icon_state = "animglitter4"
	var/atom/E = null

	var/list/chain_to = list()

	if (exclude_center)
		for (var/turf/T in oview(radius,center_turf))
			chain_to += T
	else
		for (var/turf/T in view(radius,center_turf))
			chain_to += T
	if (radius <= 0)
		for (var/turf/T in oview(1,center_turf))
			if (prob(25))
				chain_to += T
		if (chain_to.len < 2)
			chain_to += get_step(center_turf,pick(alldirs))


	var/turf/T = null


	var/matrix/M = matrix()
	M.Scale(0,0)

	var/list/magics = list()
	for (var/x in chain_to)
		if(!x)
			continue
		T = x
		E = new/obj/overlay/tile_effect(T)
		E.appearance = magicspark_ma
		T.hotspot_expose(1000,100,usr, electric = power)
		magics += E
		if (radius <= 0 && chain_to.len < 8 && center_turf)
			E.pixel_x = (center_turf.x - E.x) * 20
			E.pixel_y = (center_turf.y - E.y) * 20
			animate(E, transform = M, pixel_x = rand(-20,20), pixel_y = rand(-20,20), time = (1.33 SECONDS) + (power * (0.12 SECONDS)), easing = CUBIC_EASING | EASE_OUT)
		else
			animate(E, alpha = 0, time = (1.3 SECONDS) + (power * (0.12 SECONDS)), easing = BOUNCE_EASING | EASE_IN)


	playsound(center_turf, sound, 50, 1)
