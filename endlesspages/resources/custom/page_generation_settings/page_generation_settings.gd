class_name PageGenerationSettings
extends Resource
## Holds all data about page generation in a map.

@export var modified_pages: Array[PageData] = []

## How many pages are generated out of the total locations.
@export var max_pages_to_generate: int = 5:
	get:
		if total_possible_locations > 0:
			return clampi(max_pages_to_generate, pages_until_refresh, total_possible_locations)
		return max_pages_to_generate

## How many pages need to be collected until a refresh occurs.
@export var pages_until_refresh: int = 5:
	get:
		if total_possible_locations > 0:
			return clampi(pages_until_refresh, 1, total_possible_locations)
		return pages_until_refresh

## How many possible locations there are. 0 or below will get all locations on the map.
@export var total_possible_locations: int = 0
