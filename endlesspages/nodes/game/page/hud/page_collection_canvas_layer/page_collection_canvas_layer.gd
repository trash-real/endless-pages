extends CanvasLayer

@export_group("Tweening")
@export var _number_tween_settings_list: Array[TweenSettings]

@export_group("References")
@export var _page_count_container: BoxContainer
@export var _page_count_text_old: RichTextLabel
@export var _page_count_text_new: RichTextLabel
@export var _fade_up_anim: UIFadeUpAnimation

var _count_tween: Tween
var _newest_page: Page

const COUNT_START_POS: Vector2 = Vector2(0.0, -22.0)
const COUNT_END_POS: Vector2 = Vector2(0.0, 22.0)
const FADE_OUT_BUFFER: float = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PageManager.instance.page_taken.connect(_on_page_taken)


func _update_count() -> void:
	_page_count_text_old.text = str(PageManager.instance.get_total_collected() - 1)
	_page_count_text_new.text = str(PageManager.instance.get_total_collected())
	_page_count_container.offset_transform_position = COUNT_START_POS


func _on_page_taken(page: Page) -> void:
	_newest_page = page
	if _count_tween:
		_count_tween.kill()
	
	_update_count()
	
	if _should_continue(page):
		await _fade_up_anim.fade_in().finished
	
	if _should_continue(page):
		await _tween_page_count().finished
	
	if _should_continue(page):
		await get_tree().create_timer(FADE_OUT_BUFFER).timeout
	
	if _should_continue(page):
		_fade_up_anim.fade_out()


func _tween_page_count() -> Tween:
	var settings = _number_tween_settings_list.pick_random()
	
	_count_tween = create_tween()
	_count_tween.tween_property(_page_count_container, "offset_transform_position", COUNT_END_POS, settings.time)\
		.set_ease(settings.ease).set_trans(settings.trans)
	
	return _count_tween


func _should_continue(page: Page) -> bool:
	if page == _newest_page:
		return true
	else:
		return false
