class_name PageGeneration
extends Node
## Handles randomly generating pages in a map.

signal page_taken(page: Page)

@export var settings: PageGenerationSettings

var _all_pages: Array[Page]
var _pool: Array[Page]
var _generated: Array[Page]

var _last_collected: Page
var _pages_until_refresh: int = 0


func _ready() -> void:
	setup()


func setup() -> void:
	# Get all pages in array
	var all = get_tree().get_nodes_in_group("Page")
	for page in all:
		if page is Page:
			_all_pages.push_back(page)
	
	refresh()


func refresh() -> void:
	print("Refresh")
	# Set all pages to inactive
	disable_all_pages()
	
	# Reset pages needed until refresh
	_pages_until_refresh = settings.pages_until_refresh
	
	# Reset page arrays
	_pool.clear()
	_generated.clear()
	
	# Get new page location pool
	refresh_pool()
	
	# Generate pages
	generate()


func disable_all_pages() -> void:
	for page in _all_pages:
		if page is Page:
			page.set_enabled(false)
			if page.taken.is_connected(_on_page_taken):
				page.taken.disconnect(_on_page_taken)


func refresh_pool() -> void:
	var all := _all_pages
	
	# Get all page locations in pool
	if settings.total_possible_locations <= 0:
		for page in all:
			_pool.push_back(page)
	
	for i in range(settings.total_possible_locations):
		var rand = all.pick_random()
		_pool.push_back(rand)
		all.erase(rand)
		if all.is_empty() and OS.is_debug_build():
			push_warning("PageGeneration: List of all pages ran out before pool could fill.")
			return


func generate() -> void:
	var pool := _pool
	
	if _last_collected:
		pool.erase(_last_collected)
	
	for i in range(settings.max_pages_to_generate):
		var rand = pool.pick_random()
		_generated.push_back(rand)
		pool.erase(rand)
		
		rand.generate()
		rand.taken.connect(_on_page_taken)
		
		print("Generate")
		if pool.is_empty() and OS.is_debug_build():
			push_warning("PageGeneration: Page pool ran out before all pages generated.")
			return


func _on_page_taken(page: Page) -> void:
	_last_collected = page
	page_taken.emit(page)
	_pages_until_refresh -= 1
	if _pages_until_refresh <= 0:
		refresh()
