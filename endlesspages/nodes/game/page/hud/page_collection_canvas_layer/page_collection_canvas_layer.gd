extends CanvasLayer

@export_group("Tweening")
@export var _number_tween_settings_list: Array[TweenSettings]

@export_group("References")
@export var _page_count_text_old: RichTextLabel
@export var _page_count_text_new: RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func display_collection_text() -> void:
	pass
