extends Node

#player attack
var player_current_attack = false

#Scenes
var current_scene = "world"
var current_scene2 = "cliff_side"
var transition_scene = false

#player positions
var player_exit_cliffside_posx = 597
var player_exit_cliffside_posy = 161
var player_start_posx = 16
var player_start_posy = 129
var game_first_loadin = true

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"
