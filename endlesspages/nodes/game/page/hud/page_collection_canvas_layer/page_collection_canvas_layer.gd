extends CanvasLayer

@export_group("Tweening")
@export var _number_tween_settings_list: Array[TweenSettings]

@export_group("References")
@export var _page_count_text_old: RichTextLabel
@export var _page_count_text_new: RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PageManager.instance.page_taken.connect(_on_page_taken)


func _update_count() -> void:
	_page_count_text_old.text = str(PageManager.instance.get_total_collected() - 1)
	_page_count_text_new.text = str(PageManager.instance.get_total_collected())


func _on_page_taken(_page: Page) -> void:
	_update_count()
