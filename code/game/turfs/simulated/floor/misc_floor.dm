/turf/open/floor/goonplaque
	name = "commemorative plaque"
	icon_state = "plaque"
	desc = "\"This is a plaque in honour of our comrades on the G4407 Stations. Hopefully TG4407 model can live up to your fame and fortune.\" Scratched in beneath that is a crude image of a meteor and a spaceman. The spaceman is laughing. The meteor is exploding."
	floor_tile = /obj/item/stack/tile/plasteel

/turf/open/floor/vault
	icon_state = "rockvault"
	floor_tile = /obj/item/stack/tile/plasteel

/turf/open/floor/bluegrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "bcircuit"
	floor_tile = /obj/item/stack/tile/plasteel

/turf/open/floor/bluegrid/New()
	..()
	nuke_tiles += src

/turf/open/floor/bluegrid/Destroy()
	nuke_tiles -= src
	return ..()

/turf/open/floor/greengrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "gcircuit"
	floor_tile = /obj/item/stack/tile/plasteel


/turf/open/floor/pod
	name = "pod floor"
	icon_state = "podfloor"
	icon_regular_floor = "podfloor"
	floor_tile = /obj/item/stack/tile/pod

/turf/open/floor/pod/light
	icon_state = "podfloor_light"
	icon_regular_floor = "podfloor_light"
	floor_tile = /obj/item/stack/tile/pod/light

/turf/open/floor/pod/dark
	icon_state = "podfloor_dark"
	icon_regular_floor = "podfloor_dark"
	floor_tile = /obj/item/stack/tile/pod/dark


/turf/open/floor/noslip
	name = "high-traction floor"
	icon_state = "noslip"
	floor_tile = /obj/item/stack/tile/noslip
	broken_states = list("noslip-damaged1","noslip-damaged2","noslip-damaged3")
	burnt_states = list("noslip-scorched1","noslip-scorched2")
	slowdown = -0.3

/turf/open/floor/noslip/MakeSlippery()
	return

/turf/open/floor/oldshuttle
	icon = 'icons/turf/shuttleold.dmi'
	icon_state = "floor"
	floor_tile = /obj/item/stack/tile/plasteel

//Clockwork floor: Slowly heals toxin damage on nearby servants.
/turf/open/floor/clockwork
	name = "clockwork floor"
	desc = "Tightly-pressed brass tiles. They emit minute vibration."
	icon_state = "plating"
	var/obj/effect/clockwork/overlay/floor/realappearence

/turf/open/floor/clockwork/New()
	..()
	PoolOrNew(/obj/effect/overlay/temp/ratvar/floor, src)
	PoolOrNew(/obj/effect/overlay/temp/ratvar/beam, src)
	realappearence = PoolOrNew(/obj/effect/clockwork/overlay/floor, src)
	realappearence.linked = src
	change_construction_value(1)

/turf/open/floor/clockwork/Destroy()
	be_removed()
	return ..()

/turf/open/floor/clockwork/ChangeTurf(path, defer_change = FALSE)
	if(path != type)
		be_removed()
	return ..()

/turf/open/floor/clockwork/proc/be_removed()
	STOP_PROCESSING(SSobj, src)
	change_construction_value(-1)
	qdel(realappearence)
	realappearence = null

/turf/open/floor/clockwork/Entered(atom/movable/AM)
	..()
	START_PROCESSING(SSobj, src)

/turf/open/floor/clockwork/process()
	if(!healservants())
		STOP_PROCESSING(SSobj, src)

/turf/open/floor/clockwork/proc/healservants()
	for(var/mob/living/L in src)
		if(L.stat == DEAD || !is_servant_of_ratvar(L))
			continue
		var/swapdamage = FALSE
		if(L.has_dna()) //if has_dna() is true they're at least carbon
			var/mob/living/carbon/C = L
			if(TOXINLOVER in C.dna.species.specflags)
				swapdamage = TRUE
		if(isanimal(L))
			var/mob/living/simple_animal/A = L
			if(A.damage_coeff[TOX] < 0)
				swapdamage = TRUE
		if(swapdamage) //they'd take damage, we need to swap it
			L.adjustToxLoss(3)
		else
			L.adjustToxLoss(-3)
		. = 1

/turf/open/floor/clockwork/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/weapon/crowbar))
		user.visible_message("<span class='notice'>[user] begins slowly prying up [src]...</span>", "<span class='notice'>You begin painstakingly prying up [src]...</span>")
		playsound(src, 'sound/items/Crowbar.ogg', 20, 1)
		if(!do_after(user, 70 / I.toolspeed, target = src))
			return 0
		user.visible_message("<span class='notice'>[user] pries up [src]!</span>", "<span class='notice'>You pry up [src], destroying it!</span>")
		playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
		make_plating()
		return 1
	return ..()

/turf/open/floor/clockwork/make_plating()
	new/obj/item/clockwork/alloy_shards/small(src)
	new/obj/item/clockwork/alloy_shards/medium(src)
	return ..()

/turf/open/floor/clockwork/ratvar_act()
	for(var/mob/M in src)
		M.ratvar_act()

/turf/open/floor/clockwork/narsie_act()
	..()
	if(istype(src, /turf/open/floor/clockwork)) //if we haven't changed type
		var/previouscolor = color
		color = "#960000"
		animate(src, color = previouscolor, time = 8)


/turf/open/floor/bluespace
	slowdown = -1
	icon_state = "bluespace"
	desc = "Through a series of micro-teleports these tiles let people move at incredible speeds"
	floor_tile = /obj/item/stack/tile/bluespace


/turf/open/floor/sepia
	slowdown = 2
	icon_state = "sepia"
	desc = "Time seems to flow very slowly around these tiles"
	floor_tile = /obj/item/stack/tile/sepia

