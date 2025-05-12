extends Node

## The main game scene
@export var game_scene: PackedScene

@export var player_scene: PackedScene

@onready var tree := get_tree()

var peer := ENetMultiplayerPeer.new()

const PORT := 56554


func join_game(addr: String = "localhost") -> void:
	tree.change_scene_to_packed(game_scene)
	await tree.create_timer(0).timeout
	peer.create_client(addr, PORT)
	var game: GameManager = tree.current_scene
	game.multiplayer.multiplayer_peer = peer


func host_game() -> void:
	tree.change_scene_to_packed(game_scene)
	await tree.create_timer(0).timeout
	peer.create_server(PORT)
	peer.peer_connected.connect(peer_connected)
	var game: GameManager = tree.current_scene
	game.multiplayer.multiplayer_peer = peer
	spawn_player(1)


func peer_connected(pid: int) -> void:
	print("Peer %d connected" % pid)
	spawn_player(pid)


func spawn_player(pid: int) -> void:
	var player := player_scene.instantiate()
	player.position.y = 3
	player.name = "Player " + str(pid)
	tree.current_scene.player_parent.add_child(player, true)
	player.game_manager = tree.current_scene
