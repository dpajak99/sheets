///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	String get title => 'Untitled spreadsheet';
	String get share => 'Share';
	late final TranslationsMenuEn menu = TranslationsMenuEn._(_root);
	late final TranslationsToolbarEn toolbar = TranslationsToolbarEn._(_root);
	late final TranslationsCellMenuEn cell_menu = TranslationsCellMenuEn._(_root);
	late final TranslationsColumnMenuEn column_menu = TranslationsColumnMenuEn._(_root);
	late final TranslationsRowMenuEn row_menu = TranslationsRowMenuEn._(_root);
	late final TranslationsHeaderEn header = TranslationsHeaderEn._(_root);
	late final TranslationsBottomBarEn bottom_bar = TranslationsBottomBarEn._(_root);
}

// Path: menu
class TranslationsMenuEn {
	TranslationsMenuEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsMenuFontEn font = TranslationsMenuFontEn._(_root);
	late final TranslationsMenuFileEn file = TranslationsMenuFileEn._(_root);
	late final TranslationsMenuEditEn edit = TranslationsMenuEditEn._(_root);
	late final TranslationsMenuViewEn view = TranslationsMenuViewEn._(_root);
	late final TranslationsMenuInsertEn insert = TranslationsMenuInsertEn._(_root);
	late final TranslationsMenuFormatEn format = TranslationsMenuFormatEn._(_root);
	late final TranslationsMenuDataEn data = TranslationsMenuDataEn._(_root);
	late final TranslationsMenuToolsEn tools = TranslationsMenuToolsEn._(_root);
	late final TranslationsMenuHelpEn help = TranslationsMenuHelpEn._(_root);
}

// Path: toolbar
class TranslationsToolbarEn {
	TranslationsToolbarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsToolbarMenusEn menus = TranslationsToolbarMenusEn._(_root);
	late final TranslationsToolbarUndoEn undo = TranslationsToolbarUndoEn._(_root);
	late final TranslationsToolbarRedoEn redo = TranslationsToolbarRedoEn._(_root);
	late final TranslationsToolbarPrintEn print = TranslationsToolbarPrintEn._(_root);
	late final TranslationsToolbarPaintFormatEn paint_format = TranslationsToolbarPaintFormatEn._(_root);
	late final TranslationsToolbarZoomEn zoom = TranslationsToolbarZoomEn._(_root);
	late final TranslationsToolbarCurrencyEn currency = TranslationsToolbarCurrencyEn._(_root);
	late final TranslationsToolbarPercentEn percent = TranslationsToolbarPercentEn._(_root);
	late final TranslationsToolbarDecreaseDecimalEn decrease_decimal = TranslationsToolbarDecreaseDecimalEn._(_root);
	late final TranslationsToolbarIncreaseDecimalEn increase_decimal = TranslationsToolbarIncreaseDecimalEn._(_root);
	late final TranslationsToolbarMoreFormatsEn more_formats = TranslationsToolbarMoreFormatsEn._(_root);
	late final TranslationsToolbarFontEn font = TranslationsToolbarFontEn._(_root);
	late final TranslationsToolbarDecreaseFontSizeEn decrease_font_size = TranslationsToolbarDecreaseFontSizeEn._(_root);
	late final TranslationsToolbarFontSizeEn font_size = TranslationsToolbarFontSizeEn._(_root);
	late final TranslationsToolbarIncreaseFontSizeEn increase_font_size = TranslationsToolbarIncreaseFontSizeEn._(_root);
	late final TranslationsToolbarBoldEn bold = TranslationsToolbarBoldEn._(_root);
	late final TranslationsToolbarItalicEn italic = TranslationsToolbarItalicEn._(_root);
	late final TranslationsToolbarStrikethroughEn strikethrough = TranslationsToolbarStrikethroughEn._(_root);
	late final TranslationsToolbarTextColorEn text_color = TranslationsToolbarTextColorEn._(_root);
	late final TranslationsToolbarFillColorEn fill_color = TranslationsToolbarFillColorEn._(_root);
	late final TranslationsToolbarBordersEn borders = TranslationsToolbarBordersEn._(_root);
	late final TranslationsToolbarMergeEn merge = TranslationsToolbarMergeEn._(_root);
	late final TranslationsToolbarMergeTypesEn merge_types = TranslationsToolbarMergeTypesEn._(_root);
	late final TranslationsToolbarAlignEn align = TranslationsToolbarAlignEn._(_root);
	late final TranslationsToolbarValignEn valign = TranslationsToolbarValignEn._(_root);
	late final TranslationsToolbarWrapEn wrap = TranslationsToolbarWrapEn._(_root);
	late final TranslationsToolbarRotateEn rotate = TranslationsToolbarRotateEn._(_root);
	late final TranslationsToolbarLinkEn link = TranslationsToolbarLinkEn._(_root);
	late final TranslationsToolbarCommentEn comment = TranslationsToolbarCommentEn._(_root);
	late final TranslationsToolbarChartEn chart = TranslationsToolbarChartEn._(_root);
	late final TranslationsToolbarFilterEn filter = TranslationsToolbarFilterEn._(_root);
	late final TranslationsToolbarFilterViewsEn filter_views = TranslationsToolbarFilterViewsEn._(_root);
	late final TranslationsToolbarFunctionsEn functions = TranslationsToolbarFunctionsEn._(_root);
}

// Path: cell_menu
class TranslationsCellMenuEn {
	TranslationsCellMenuEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cut => 'Cut';
	String get copy => 'Copy';
	String get paste => 'Paste';
	String get paste_special => 'Paste special';
	late final TranslationsCellMenuPasteSpecialOptionsEn paste_special_options = TranslationsCellMenuPasteSpecialOptionsEn._(_root);
	String get insert_row_above => 'Insert 1 row above';
	String get insert_column_left => 'Insert 1 column left';
	String get insert_cells => 'Insert cells';
	late final TranslationsCellMenuInsertCellsOptionsEn insert_cells_options = TranslationsCellMenuInsertCellsOptionsEn._(_root);
	String get delete_row => 'Delete row';
	String get delete_column => 'Delete column';
	String get delete_cells => 'Delete cells';
	late final TranslationsCellMenuDeleteCellsOptionsEn delete_cells_options = TranslationsCellMenuDeleteCellsOptionsEn._(_root);
	String get convert_to_table => 'Convert to table';
	String get create_filter => 'Create a filter';
	String get filter_by_cell_value => 'Filter by cell value';
	String get show_edit_history => 'Show edit history';
	String get insert_link => 'Insert link';
	String get comment => 'Comment';
	String get insert_note => 'Insert note';
	String get tables => 'Tables';
	String get dropdown => 'Dropdown';
	String get smart_chips => 'Smart chips';
	late final TranslationsCellMenuSmartChipsOptionsEn smart_chips_options = TranslationsCellMenuSmartChipsOptionsEn._(_root);
	String get more => 'View more cell actions';
	late final TranslationsCellMenuMoreOptionsEn more_options = TranslationsCellMenuMoreOptionsEn._(_root);
}

// Path: column_menu
class TranslationsColumnMenuEn {
	TranslationsColumnMenuEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cut => 'Cut';
	String get copy => 'Copy';
	String get paste => 'Paste';
	String get paste_special => 'Paste special';
	late final TranslationsColumnMenuPasteSpecialOptionsEn paste_special_options = TranslationsColumnMenuPasteSpecialOptionsEn._(_root);
	String get insert_column_left => 'Insert 1 column left';
	String get insert_column_right => 'Insert 1 column right';
	String get delete_column => 'Delete column';
	String get clear_column => 'Clear column';
	String get hide_column => 'Hide column';
	String get resize_column => 'Resize column';
	String get create_filter => 'Create a filter';
	String get sort_asc => 'Sort sheet A to Z';
	String get sort_desc => 'Sort sheet Z to A';
	String get conditional_formatting => 'Conditional formatting';
	String get data_validation => 'Data validation';
	String get column_stats => 'Column stats';
	String get dropdown => 'Dropdown';
	String get smart_chips => 'Smart chips';
	late final TranslationsColumnMenuSmartChipsOptionsEn smart_chips_options = TranslationsColumnMenuSmartChipsOptionsEn._(_root);
	String get more => 'View more column actions';
	late final TranslationsColumnMenuMoreOptionsEn more_options = TranslationsColumnMenuMoreOptionsEn._(_root);
}

// Path: row_menu
class TranslationsRowMenuEn {
	TranslationsRowMenuEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cut => 'Cut';
	String get copy => 'Copy';
	String get paste => 'Paste';
	String get paste_special => 'Paste special';
	late final TranslationsRowMenuPasteSpecialOptionsEn paste_special_options = TranslationsRowMenuPasteSpecialOptionsEn._(_root);
	String get insert_row_above => 'Insert 1 row above';
	String get insert_row_below => 'Insert 1 row below';
	String get delete_row => 'Delete row';
	String get clear_row => 'Clear row';
	String get hide_row => 'Hide row';
	String get resize_row => 'Resize row';
	String get create_filter => 'Create a filter';
	String get conditional_formatting => 'Conditional formatting';
	String get data_validation => 'Data validation';
	String get more => 'View more row actions';
	late final TranslationsRowMenuMoreOptionsEn more_options = TranslationsRowMenuMoreOptionsEn._(_root);
}

// Path: header
class TranslationsHeaderEn {
	TranslationsHeaderEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsHeaderStarEn star = TranslationsHeaderStarEn._(_root);
	late final TranslationsHeaderMoveEn move = TranslationsHeaderMoveEn._(_root);
	late final TranslationsHeaderStatusEn status = TranslationsHeaderStatusEn._(_root);
	late final TranslationsHeaderHistoryEn history = TranslationsHeaderHistoryEn._(_root);
	late final TranslationsHeaderCommentsEn comments = TranslationsHeaderCommentsEn._(_root);
	late final TranslationsHeaderCallEn call = TranslationsHeaderCallEn._(_root);
	late final TranslationsHeaderShareEn share = TranslationsHeaderShareEn._(_root);
}

// Path: bottom_bar
class TranslationsBottomBarEn {
	TranslationsBottomBarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String tab_name({required Object index}) => 'Sheet${index}';
	String get add_sheet => 'Add sheet';
	String get all_sheets => 'All sheets';
	String get show_side_panel => 'Show side panel';
}

// Path: menu.font
class TranslationsMenuFontEn {
	TranslationsMenuFontEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String kDefault({required Object name}) => 'Default (${name})';
	String get more_fonts => 'More fonts';
	String get theme => 'Theme';
	String get recent => 'Recent';
}

// Path: menu.file
class TranslationsMenuFileEn {
	TranslationsMenuFileEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'File';
	String get kNew => 'New';
	late final TranslationsMenuFileNewOptionsEn new_options = TranslationsMenuFileNewOptionsEn._(_root);
	String get open => 'Open';
	String get import => 'Import';
	String get make_copy => 'Make a copy';
	String get share => 'Share';
	late final TranslationsMenuFileShareOptionsEn share_options = TranslationsMenuFileShareOptionsEn._(_root);
	String get email => 'Email';
	late final TranslationsMenuFileEmailOptionsEn email_options = TranslationsMenuFileEmailOptionsEn._(_root);
	String get download => 'Download';
	late final TranslationsMenuFileDownloadOptionsEn download_options = TranslationsMenuFileDownloadOptionsEn._(_root);
	String get rename => 'Rename';
	String get move => 'Move';
	String get add_to_drive => 'Add to drive';
	String get move_to_trash => 'Move to trash';
	String get version_history => 'Version history';
	late final TranslationsMenuFileVersionHistoryOptionsEn version_history_options = TranslationsMenuFileVersionHistoryOptionsEn._(_root);
	String get make_available_offline => 'Make available offline';
	String get details => 'Details';
	String get security_limitations => 'Security limitations';
	String get settings => 'Settings';
	String get language => 'Language';
	String get print => 'Print';
}

// Path: menu.edit
class TranslationsMenuEditEn {
	TranslationsMenuEditEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Edit';
	String get undo => 'Undo';
	String get redo => 'Redo';
	String get cut => 'Cut';
	String get copy => 'Copy';
	String get paste => 'Paste';
	String get paste_special => 'Paste special';
	late final TranslationsMenuEditPasteSpecialOptionsEn paste_special_options = TranslationsMenuEditPasteSpecialOptionsEn._(_root);
	String get move => 'Move';
	String get delete => 'Delete';
	late final TranslationsMenuEditDeleteOptionsEn delete_options = TranslationsMenuEditDeleteOptionsEn._(_root);
	String get find_and_replace => 'Find and replace';
}

// Path: menu.view
class TranslationsMenuViewEn {
	TranslationsMenuViewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'View';
	String get show => 'Show';
	late final TranslationsMenuViewShowOptionsEn show_options = TranslationsMenuViewShowOptionsEn._(_root);
	String get freeze => 'Freeze';
	late final TranslationsMenuViewFreezeOptionsEn freeze_options = TranslationsMenuViewFreezeOptionsEn._(_root);
	String get group => 'Group';
	late final TranslationsMenuViewGroupOptionsEn group_options = TranslationsMenuViewGroupOptionsEn._(_root);
	String get comments => 'Comments';
	late final TranslationsMenuViewCommentsOptionsEn comments_options = TranslationsMenuViewCommentsOptionsEn._(_root);
	String get hidden_sheets => 'Hidden sheets';
	String get zoom => 'Zoom';
	String get full_screen => 'Full screen';
}

// Path: menu.insert
class TranslationsMenuInsertEn {
	TranslationsMenuInsertEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Insert';
	String get cells => 'Cells';
	late final TranslationsMenuInsertCellsOptionsEn cells_options = TranslationsMenuInsertCellsOptionsEn._(_root);
	String get rows => 'Rows';
	late final TranslationsMenuInsertRowsOptionsEn rows_options = TranslationsMenuInsertRowsOptionsEn._(_root);
	String get columns => 'Columns';
	late final TranslationsMenuInsertColumnsOptionsEn columns_options = TranslationsMenuInsertColumnsOptionsEn._(_root);
	String get sheet => 'Sheet';
	String get tables => 'Tables';
	String get chart => 'Chart';
	String get pivot_table => 'Pivot table';
	String get image => 'Image';
	late final TranslationsMenuInsertImageOptionsEn image_options = TranslationsMenuInsertImageOptionsEn._(_root);
	String get drawing => 'Drawing';
	String get function => 'Function';
	String get link => 'Link';
	String get checkbox => 'Checkbox';
	String get dropdown => 'Dropdown';
	String get emoji => 'Emoji';
	String get smart_chips => 'Smart chips';
	late final TranslationsMenuInsertSmartChipsOptionsEn smart_chips_options = TranslationsMenuInsertSmartChipsOptionsEn._(_root);
	String get comment => 'Comment';
	String get note => 'Note';
}

// Path: menu.format
class TranslationsMenuFormatEn {
	TranslationsMenuFormatEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Format';
	String get theme => 'Theme';
	String get number => 'Number';
	late final TranslationsMenuFormatNumberOptionsEn number_options = TranslationsMenuFormatNumberOptionsEn._(_root);
	String get text => 'Text';
	late final TranslationsMenuFormatTextOptionsEn text_options = TranslationsMenuFormatTextOptionsEn._(_root);
	String get alignment => 'Alignment';
	late final TranslationsMenuFormatAlignmentOptionsEn alignment_options = TranslationsMenuFormatAlignmentOptionsEn._(_root);
	String get wrapping => 'Wrapping';
	late final TranslationsMenuFormatWrappingOptionsEn wrapping_options = TranslationsMenuFormatWrappingOptionsEn._(_root);
	String get rotation => 'Rotation';
	late final TranslationsMenuFormatRotationOptionsEn rotation_options = TranslationsMenuFormatRotationOptionsEn._(_root);
	String get font_size => 'Font size';
	String get merge_cells => 'Merge cells';
	late final TranslationsMenuFormatMergeCellsOptionsEn merge_cells_options = TranslationsMenuFormatMergeCellsOptionsEn._(_root);
	String get convert_to_table => 'Convert to table';
	String get conditional_formatting => 'Conditional formatting';
	String get alternating_colors => 'Alternating colors';
	String get clear_formatting => 'Clear formatting';
}

// Path: menu.data
class TranslationsMenuDataEn {
	TranslationsMenuDataEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Data';
	String get sort_sheet => 'Sort sheet';
	late final TranslationsMenuDataSortSheetOptionsEn sort_sheet_options = TranslationsMenuDataSortSheetOptionsEn._(_root);
	String get sort_range => 'Sort range';
	late final TranslationsMenuDataSortRangeOptionsEn sort_range_options = TranslationsMenuDataSortRangeOptionsEn._(_root);
	String get create_filter => 'Create a filter';
	String get create_group_by_view => 'Create group by view';
	String get create_filter_view => 'Create filter view';
	String get add_slicer => 'Add a slicer';
	String get protect_sheet => 'Protect sheet and ranges';
	String get named_ranges => 'Named ranges';
	String get named_functions => 'Named functions';
	String get randomize_range => 'Randomize range';
	String get column_stats => 'Column stats';
	String get data_validation => 'Data validation';
	String get data_cleanup => 'Data cleanup';
	late final TranslationsMenuDataDataCleanupOptionsEn data_cleanup_options = TranslationsMenuDataDataCleanupOptionsEn._(_root);
	String get split_to_columns => 'Split text to columns';
	String get data_extraction => 'Data extraction';
}

// Path: menu.tools
class TranslationsMenuToolsEn {
	TranslationsMenuToolsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Tools';
	String get create_new_form => 'Create a new form';
	String get spelling => 'Spelling';
	late final TranslationsMenuToolsSpellingOptionsEn spelling_options = TranslationsMenuToolsSpellingOptionsEn._(_root);
	String get suggestion_controls => 'Suggestion controls';
	late final TranslationsMenuToolsSuggestionControlsOptionsEn suggestion_controls_options = TranslationsMenuToolsSuggestionControlsOptionsEn._(_root);
	String get notifications_settings => 'Notifications settings';
	late final TranslationsMenuToolsNotificationsSettingsOptionsEn notifications_settings_options = TranslationsMenuToolsNotificationsSettingsOptionsEn._(_root);
	String get accessibility => 'Accessibility';
}

// Path: menu.help
class TranslationsMenuHelpEn {
	TranslationsMenuHelpEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name => 'Help';
	String get search => 'Search the menus';
	String get sheets_help => 'Sheets help';
	String get training => 'Training';
	String get updates => 'Updates';
	String get help_sheets_improve => 'Help Sheets improve';
	String get privacy_policy => 'Privacy policy';
	String get terms_of_service => 'Terms of service';
	String get function_list => 'Function list';
	String get keyboard_shortcuts => 'Keyboard shortcuts';
}

// Path: toolbar.menus
class TranslationsToolbarMenusEn {
	TranslationsToolbarMenusEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get hint => 'Menus';
	String get tooltip => 'Search the menus (Alt+/)';
}

// Path: toolbar.undo
class TranslationsToolbarUndoEn {
	TranslationsToolbarUndoEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Undo (Ctrl+Z)';
}

// Path: toolbar.redo
class TranslationsToolbarRedoEn {
	TranslationsToolbarRedoEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Redo (Ctrl+Y)';
}

// Path: toolbar.print
class TranslationsToolbarPrintEn {
	TranslationsToolbarPrintEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Print (Ctrl+P)';
}

// Path: toolbar.paint_format
class TranslationsToolbarPaintFormatEn {
	TranslationsToolbarPaintFormatEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Paint format';
}

// Path: toolbar.zoom
class TranslationsToolbarZoomEn {
	TranslationsToolbarZoomEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Zoom';
}

// Path: toolbar.currency
class TranslationsToolbarCurrencyEn {
	TranslationsToolbarCurrencyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Format as currency';
}

// Path: toolbar.percent
class TranslationsToolbarPercentEn {
	TranslationsToolbarPercentEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Format as percent';
}

// Path: toolbar.decrease_decimal
class TranslationsToolbarDecreaseDecimalEn {
	TranslationsToolbarDecreaseDecimalEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Decrease decimal places';
}

// Path: toolbar.increase_decimal
class TranslationsToolbarIncreaseDecimalEn {
	TranslationsToolbarIncreaseDecimalEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Increase decimal places';
}

// Path: toolbar.more_formats
class TranslationsToolbarMoreFormatsEn {
	TranslationsToolbarMoreFormatsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'More formats';
}

// Path: toolbar.font
class TranslationsToolbarFontEn {
	TranslationsToolbarFontEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Font';
	String get options => 'More fonts';
}

// Path: toolbar.decrease_font_size
class TranslationsToolbarDecreaseFontSizeEn {
	TranslationsToolbarDecreaseFontSizeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Decrease font size (Ctrl+Shift+,)';
}

// Path: toolbar.font_size
class TranslationsToolbarFontSizeEn {
	TranslationsToolbarFontSizeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Font size';
}

// Path: toolbar.increase_font_size
class TranslationsToolbarIncreaseFontSizeEn {
	TranslationsToolbarIncreaseFontSizeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Increase font size (Ctrl+Shift+.)';
}

// Path: toolbar.bold
class TranslationsToolbarBoldEn {
	TranslationsToolbarBoldEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Bold (Ctrl+B)';
}

// Path: toolbar.italic
class TranslationsToolbarItalicEn {
	TranslationsToolbarItalicEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Italic (Ctrl+I)';
}

// Path: toolbar.strikethrough
class TranslationsToolbarStrikethroughEn {
	TranslationsToolbarStrikethroughEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Strikethrough (Alt+Shift+5)';
}

// Path: toolbar.text_color
class TranslationsToolbarTextColorEn {
	TranslationsToolbarTextColorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Text color';
}

// Path: toolbar.fill_color
class TranslationsToolbarFillColorEn {
	TranslationsToolbarFillColorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Fill color';
	String get alternating_colors => 'Alternating colors';
}

// Path: toolbar.borders
class TranslationsToolbarBordersEn {
	TranslationsToolbarBordersEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Borders';
	late final TranslationsToolbarBordersOptionsEn options = TranslationsToolbarBordersOptionsEn._(_root);
}

// Path: toolbar.merge
class TranslationsToolbarMergeEn {
	TranslationsToolbarMergeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Merge cells';
	late final TranslationsToolbarMergeOptionsEn options = TranslationsToolbarMergeOptionsEn._(_root);
}

// Path: toolbar.merge_types
class TranslationsToolbarMergeTypesEn {
	TranslationsToolbarMergeTypesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Select merge type';
}

// Path: toolbar.align
class TranslationsToolbarAlignEn {
	TranslationsToolbarAlignEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Horizontal align';
	late final TranslationsToolbarAlignOptionsEn options = TranslationsToolbarAlignOptionsEn._(_root);
}

// Path: toolbar.valign
class TranslationsToolbarValignEn {
	TranslationsToolbarValignEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Vertical align';
	late final TranslationsToolbarValignOptionsEn options = TranslationsToolbarValignOptionsEn._(_root);
}

// Path: toolbar.wrap
class TranslationsToolbarWrapEn {
	TranslationsToolbarWrapEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Text wrapping';
	late final TranslationsToolbarWrapOptionsEn options = TranslationsToolbarWrapOptionsEn._(_root);
}

// Path: toolbar.rotate
class TranslationsToolbarRotateEn {
	TranslationsToolbarRotateEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Text rotation';
	late final TranslationsToolbarRotateOptionsEn options = TranslationsToolbarRotateOptionsEn._(_root);
}

// Path: toolbar.link
class TranslationsToolbarLinkEn {
	TranslationsToolbarLinkEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Insert link (Ctrl+K)';
}

// Path: toolbar.comment
class TranslationsToolbarCommentEn {
	TranslationsToolbarCommentEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Insert comment (Ctrl+Alt+M)';
}

// Path: toolbar.chart
class TranslationsToolbarChartEn {
	TranslationsToolbarChartEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Insert chart';
}

// Path: toolbar.filter
class TranslationsToolbarFilterEn {
	TranslationsToolbarFilterEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Create a filter';
}

// Path: toolbar.filter_views
class TranslationsToolbarFilterViewsEn {
	TranslationsToolbarFilterViewsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Filter views';
	late final TranslationsToolbarFilterViewsOptionsEn options = TranslationsToolbarFilterViewsOptionsEn._(_root);
}

// Path: toolbar.functions
class TranslationsToolbarFunctionsEn {
	TranslationsToolbarFunctionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Functions';
}

// Path: cell_menu.paste_special_options
class TranslationsCellMenuPasteSpecialOptionsEn {
	TranslationsCellMenuPasteSpecialOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get values => 'Paste values only';
	String get formatting => 'Paste format only';
	String get formulas => 'Paste formula only';
	String get conditional_formatting => 'Conditional formatting only';
	String get data_validation => 'Data validation only';
	String get transposed => 'Transposed';
	String get column_width => 'Column width only';
	String get all_without_borders => 'All except borders';
}

// Path: cell_menu.insert_cells_options
class TranslationsCellMenuInsertCellsOptionsEn {
	TranslationsCellMenuInsertCellsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cells_and_shift_right => 'Insert cells and shift right';
	String get cells_and_shift_down => 'Insert cells and shift down';
}

// Path: cell_menu.delete_cells_options
class TranslationsCellMenuDeleteCellsOptionsEn {
	TranslationsCellMenuDeleteCellsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cells_and_shift_left => 'Insert cells and shift left';
	String get cells_and_shift_up => 'Insert cells and shift up';
}

// Path: cell_menu.smart_chips_options
class TranslationsCellMenuSmartChipsOptionsEn {
	TranslationsCellMenuSmartChipsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get people => 'People';
	String get file => 'File';
	String get calendar => 'Calendar events';
	String get place => 'Place';
	String get finance => 'Finance';
	String get rating => 'Rating';
}

// Path: cell_menu.more_options
class TranslationsCellMenuMoreOptionsEn {
	TranslationsCellMenuMoreOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get conditional_formatting => 'Conditional formatting';
	String get data_validation => 'Data validation';
	String get get_link_to_cell => 'Get link to this cell';
	String get define_named_range => 'Define named range';
	String get protect_range => 'Protect range';
}

// Path: column_menu.paste_special_options
class TranslationsColumnMenuPasteSpecialOptionsEn {
	TranslationsColumnMenuPasteSpecialOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get values => 'Paste values only';
	String get formatting => 'Paste format only';
	String get formulas => 'Paste formula only';
	String get conditional_formatting => 'Conditional formatting only';
	String get data_validation => 'Data validation only';
	String get transposed => 'Transposed';
	String get column_width => 'Column width only';
	String get all_without_borders => 'All except borders';
}

// Path: column_menu.smart_chips_options
class TranslationsColumnMenuSmartChipsOptionsEn {
	TranslationsColumnMenuSmartChipsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get people => 'People';
	String get file => 'File';
	String get calendar => 'Calendar events';
	String get place => 'Place';
	String get finance => 'Finance';
	String get rating => 'Rating';
}

// Path: column_menu.more_options
class TranslationsColumnMenuMoreOptionsEn {
	TranslationsColumnMenuMoreOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String freeze({required Object index}) => 'Freeze up to column ${index}';
	String get group => 'Group column';
	String get get_link_to_range => 'Get link to this range';
	String get randomize_range => 'Randomize range';
	String get define_named_range => 'Define named range';
	String get protect_range => 'Protect range';
}

// Path: row_menu.paste_special_options
class TranslationsRowMenuPasteSpecialOptionsEn {
	TranslationsRowMenuPasteSpecialOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get values => 'Paste values only';
	String get formatting => 'Paste format only';
	String get formulas => 'Paste formula only';
	String get conditional_formatting => 'Conditional formatting only';
	String get data_validation => 'Data validation only';
	String get transposed => 'Transposed';
	String get column_width => 'Column width only';
	String get all_without_borders => 'All except borders';
}

// Path: row_menu.more_options
class TranslationsRowMenuMoreOptionsEn {
	TranslationsRowMenuMoreOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String freeze({required Object index}) => 'Freeze up to row ${index}';
	String get group => 'Group row';
	String get get_link_to_range => 'Get link to this range';
	String get define_named_range => 'Define named range';
	String get protect_range => 'Protect range';
}

// Path: header.star
class TranslationsHeaderStarEn {
	TranslationsHeaderStarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Star';
}

// Path: header.move
class TranslationsHeaderMoveEn {
	TranslationsHeaderMoveEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Move';
}

// Path: header.status
class TranslationsHeaderStatusEn {
	TranslationsHeaderStatusEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'See document status';
}

// Path: header.history
class TranslationsHeaderHistoryEn {
	TranslationsHeaderHistoryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Show document history';
}

// Path: header.comments
class TranslationsHeaderCommentsEn {
	TranslationsHeaderCommentsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Show all comments';
}

// Path: header.call
class TranslationsHeaderCallEn {
	TranslationsHeaderCallEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Join a call here or present this tab to the cell';
}

// Path: header.share
class TranslationsHeaderShareEn {
	TranslationsHeaderShareEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tooltip => 'Quick sharing actions';
}

// Path: menu.file.new_options
class TranslationsMenuFileNewOptionsEn {
	TranslationsMenuFileNewOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get spreadsheet => 'Spreadsheet';
	String get template => 'From template gallery';
}

// Path: menu.file.share_options
class TranslationsMenuFileShareOptionsEn {
	TranslationsMenuFileShareOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get email => 'Share with others';
	String get web => 'Publish to web';
}

// Path: menu.file.email_options
class TranslationsMenuFileEmailOptionsEn {
	TranslationsMenuFileEmailOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get file => 'Email this file';
	String get collaborators => 'Email collaborators';
}

// Path: menu.file.download_options
class TranslationsMenuFileDownloadOptionsEn {
	TranslationsMenuFileDownloadOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get xlsx => 'Microsoft Excel (.xlsx)';
	String get ods => 'OpenDocument (.ods)';
	String get pdf => 'PDF (.pdf)';
	String get html => 'Web page (.html)';
	String get csv => 'Comma-separated values (.csv)';
	String get tsv => 'Tab-separated values (.tsv)';
}

// Path: menu.file.version_history_options
class TranslationsMenuFileVersionHistoryOptionsEn {
	TranslationsMenuFileVersionHistoryOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get name_current_version => 'Name current version';
	String get see_version_history => 'See version history';
}

// Path: menu.edit.paste_special_options
class TranslationsMenuEditPasteSpecialOptionsEn {
	TranslationsMenuEditPasteSpecialOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get values => 'Paste values only';
	String get formatting => 'Paste format only';
	String get formulas => 'Paste formula only';
	String get conditional_formatting => 'Conditional formatting only';
	String get data_validation => 'Data validation only';
	String get transposed => 'Transposed';
	String get column_width => 'Column width only';
	String get all_without_borders => 'All except borders';
}

// Path: menu.edit.delete_options
class TranslationsMenuEditDeleteOptionsEn {
	TranslationsMenuEditDeleteOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get values => 'Values';
	String row({required Object index}) => 'Row ${index}';
	String column({required Object index}) => 'Column ${index}';
	String get cells_shift_up => 'Cells and shift up';
	String get cells_shift_left => 'Cells and shift left';
	String get notes => 'Notes';
}

// Path: menu.view.show_options
class TranslationsMenuViewShowOptionsEn {
	TranslationsMenuViewShowOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get formula_bar => 'Formula bar';
	String get gridlines => 'Gridlines';
	String get formulas => 'Formulas';
	String get protected_ranges => 'Protected ranges';
}

// Path: menu.view.freeze_options
class TranslationsMenuViewFreezeOptionsEn {
	TranslationsMenuViewFreezeOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get no_rows => 'No rows';
	String get k1Row => '1 row';
	String get k2Rows => '2 rows';
	String up_to_current_row({required Object index}) => 'Up to row ${index}';
	String get no_columns => 'No columns';
	String get k1Column => '1 column';
	String get k2Columns => '2 columns';
	String up_to_current_column({required Object index}) => 'Up to column ${index}';
}

// Path: menu.view.group_options
class TranslationsMenuViewGroupOptionsEn {
	TranslationsMenuViewGroupOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get group => 'Group';
	String get ungroup => 'Ungroup';
}

// Path: menu.view.comments_options
class TranslationsMenuViewCommentsOptionsEn {
	TranslationsMenuViewCommentsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get hide_comments => 'Hide comments';
	String get minimize_comments => 'Minimize comments';
	String get show_all => 'Show all comments';
}

// Path: menu.insert.cells_options
class TranslationsMenuInsertCellsOptionsEn {
	TranslationsMenuInsertCellsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cells_and_shift_right => 'Insert cells and shift right';
	String get cells_and_shift_down => 'Insert cells and shift down';
}

// Path: menu.insert.rows_options
class TranslationsMenuInsertRowsOptionsEn {
	TranslationsMenuInsertRowsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get above => 'Insert 1 row above';
	String get below => 'Insert 1 row below';
}

// Path: menu.insert.columns_options
class TranslationsMenuInsertColumnsOptionsEn {
	TranslationsMenuInsertColumnsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get left => 'Insert 1 column left';
	String get right => 'Insert 1 column right';
}

// Path: menu.insert.image_options
class TranslationsMenuInsertImageOptionsEn {
	TranslationsMenuInsertImageOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get in_cell => 'Insert image in cell';
	String get over_cells => 'Insert image over cells';
}

// Path: menu.insert.smart_chips_options
class TranslationsMenuInsertSmartChipsOptionsEn {
	TranslationsMenuInsertSmartChipsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get people => 'People';
	String get file => 'File';
	String get calendar => 'Calendar events';
	String get place => 'Place';
	String get finance => 'Finance';
	String get rating => 'Rating';
}

// Path: menu.format.number_options
class TranslationsMenuFormatNumberOptionsEn {
	TranslationsMenuFormatNumberOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get automatic => 'Automatic';
	String get plain_text => 'Plain text';
	String get number => 'Number';
	String get percent => 'Percent';
	String get scientific => 'Scientific';
	String get accounting => 'Accounting';
	String get financial => 'Financial';
	String get currency => 'Currency';
	String get currency_rounded => 'Currency rounded';
	String get date => 'Date';
	String get time => 'Time';
	String get date_time => 'Date time';
	String get duration => 'Duration';
	String get custom_currency => 'Custom currency';
	String get custom_date => 'Custom date and time';
	String get custom_number => 'Custom number format';
}

// Path: menu.format.text_options
class TranslationsMenuFormatTextOptionsEn {
	TranslationsMenuFormatTextOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get bold => 'Bold';
	String get italic => 'Italic';
	String get underline => 'Underline';
	String get strikethrough => 'Strikethrough';
}

// Path: menu.format.alignment_options
class TranslationsMenuFormatAlignmentOptionsEn {
	TranslationsMenuFormatAlignmentOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get left => 'Left';
	String get center => 'Center';
	String get right => 'Right';
	String get top => 'Top';
	String get middle => 'Middle';
	String get bottom => 'Bottom';
}

// Path: menu.format.wrapping_options
class TranslationsMenuFormatWrappingOptionsEn {
	TranslationsMenuFormatWrappingOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get overflow => 'Overflow';
	String get wrap => 'Wrap';
	String get clip => 'Clip';
}

// Path: menu.format.rotation_options
class TranslationsMenuFormatRotationOptionsEn {
	TranslationsMenuFormatRotationOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get none => 'None';
	String get tilt_up => 'Tilt up';
	String get tilt_down => 'Tilt down';
	String get stack_vertically => 'Stack vertically';
	String get rotate_up => 'Rotate up';
	String get rotate_down => 'Rotate down';
	String get custom_angle => 'Custom angle';
}

// Path: menu.format.merge_cells_options
class TranslationsMenuFormatMergeCellsOptionsEn {
	TranslationsMenuFormatMergeCellsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get merge_all => 'Merge all';
	String get merge_vertically => 'Merge vertically';
	String get merge_horizontally => 'Merge horizontally';
	String get unmerge => 'Unmerge';
}

// Path: menu.data.sort_sheet_options
class TranslationsMenuDataSortSheetOptionsEn {
	TranslationsMenuDataSortSheetOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String by_column_asc({required Object index}) => 'Sort sheet by column ${index} (A to Z)';
	String by_column_desc({required Object index}) => 'Sort sheet by column ${index} (Z to A)';
}

// Path: menu.data.sort_range_options
class TranslationsMenuDataSortRangeOptionsEn {
	TranslationsMenuDataSortRangeOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String by_column_asc({required Object index}) => 'Sort range by column ${index} (A to Z)';
	String by_column_desc({required Object index}) => 'Sort range by column ${index} (Z to A)';
	String get advanced => 'Advanced range sorting options';
}

// Path: menu.data.data_cleanup_options
class TranslationsMenuDataDataCleanupOptionsEn {
	TranslationsMenuDataDataCleanupOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cleanup_suggestions => 'Cleanup suggestions';
	String get remove_duplicates => 'Remove duplicates';
	String get trim_whitespace => 'Trim whitespace';
}

// Path: menu.tools.spelling_options
class TranslationsMenuToolsSpellingOptionsEn {
	TranslationsMenuToolsSpellingOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get spell_check => 'Spell check';
	String get personal_dictionary => 'Personal dictionary';
}

// Path: menu.tools.suggestion_controls_options
class TranslationsMenuToolsSuggestionControlsOptionsEn {
	TranslationsMenuToolsSuggestionControlsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get enable_autocomplete => 'Enable autocomplete';
	String get enable_formula_suggestions => 'Enable formula suggestions';
	String get enable_formula_corrections => 'Enable formula corrections';
	String get enable_named_functions_suggestions => 'Enable named functions suggestions';
	String get enable_pivot_table_suggestions => 'Enable pivot table suggestions';
	String get enable_dropdown_chip_suggestions => 'Enable dropdown chip suggestions';
	String get enable_people_suggestions => 'Enable smart people chip suggestions';
	String get enable_table_suggestions => 'Enable table suggestions';
	String get enable_data_analysis_suggestions => 'Enable data analysis suggestions';
}

// Path: menu.tools.notifications_settings_options
class TranslationsMenuToolsNotificationsSettingsOptionsEn {
	TranslationsMenuToolsNotificationsSettingsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get edit_notifications => 'Edit notifications';
	String get comment_notifications => 'Comment notifications';
}

// Path: toolbar.borders.options
class TranslationsToolbarBordersOptionsEn {
	TranslationsToolbarBordersOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get all => 'All borders';
	String get inner => 'Inner borders';
	String get horizontal => 'Horizontal borders';
	String get vertical => 'Vertical borders';
	String get outer => 'Outer borders';
	String get left => 'Left border';
	String get top => 'Top border';
	String get right => 'Right border';
	String get bottom => 'Bottom border';
	String get clear => 'Clear borders';
	String get border_color => 'Border color';
	String get border_style => 'Border style';
}

// Path: toolbar.merge.options
class TranslationsToolbarMergeOptionsEn {
	TranslationsToolbarMergeOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get merge_all => 'Merge all';
	String get merge_vertically => 'Merge vertically';
	String get merge_horizontally => 'Merge horizontally';
	String get unmerge => 'Unmerge';
}

// Path: toolbar.align.options
class TranslationsToolbarAlignOptionsEn {
	TranslationsToolbarAlignOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get left => 'Left';
	String get center => 'Center';
	String get right => 'Right';
}

// Path: toolbar.valign.options
class TranslationsToolbarValignOptionsEn {
	TranslationsToolbarValignOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get top => 'Top';
	String get middle => 'Middle';
	String get bottom => 'Bottom';
}

// Path: toolbar.wrap.options
class TranslationsToolbarWrapOptionsEn {
	TranslationsToolbarWrapOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get overflow => 'Overflow';
	String get wrap => 'Wrap';
	String get clip => 'Clip';
}

// Path: toolbar.rotate.options
class TranslationsToolbarRotateOptionsEn {
	TranslationsToolbarRotateOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get none => 'None';
	String get tilt_up => 'Tilt up';
	String get tilt_down => 'Tilt down';
	String get stack_vertically => 'Stack vertically';
	String get rotate_up => 'Rotate up';
	String get rotate_down => 'Rotate down';
	String get custom_angle => 'Custom angle';
}

// Path: toolbar.filter_views.options
class TranslationsToolbarFilterViewsOptionsEn {
	TranslationsToolbarFilterViewsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get create_group_by_view => 'Create group by view';
	String get create_filter_view => 'Create filter view';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'title': return 'Untitled spreadsheet';
			case 'share': return 'Share';
			case 'menu.font.kDefault': return ({required Object name}) => 'Default (${name})';
			case 'menu.font.more_fonts': return 'More fonts';
			case 'menu.font.theme': return 'Theme';
			case 'menu.font.recent': return 'Recent';
			case 'menu.file.name': return 'File';
			case 'menu.file.kNew': return 'New';
			case 'menu.file.new_options.spreadsheet': return 'Spreadsheet';
			case 'menu.file.new_options.template': return 'From template gallery';
			case 'menu.file.open': return 'Open';
			case 'menu.file.import': return 'Import';
			case 'menu.file.make_copy': return 'Make a copy';
			case 'menu.file.share': return 'Share';
			case 'menu.file.share_options.email': return 'Share with others';
			case 'menu.file.share_options.web': return 'Publish to web';
			case 'menu.file.email': return 'Email';
			case 'menu.file.email_options.file': return 'Email this file';
			case 'menu.file.email_options.collaborators': return 'Email collaborators';
			case 'menu.file.download': return 'Download';
			case 'menu.file.download_options.xlsx': return 'Microsoft Excel (.xlsx)';
			case 'menu.file.download_options.ods': return 'OpenDocument (.ods)';
			case 'menu.file.download_options.pdf': return 'PDF (.pdf)';
			case 'menu.file.download_options.html': return 'Web page (.html)';
			case 'menu.file.download_options.csv': return 'Comma-separated values (.csv)';
			case 'menu.file.download_options.tsv': return 'Tab-separated values (.tsv)';
			case 'menu.file.rename': return 'Rename';
			case 'menu.file.move': return 'Move';
			case 'menu.file.add_to_drive': return 'Add to drive';
			case 'menu.file.move_to_trash': return 'Move to trash';
			case 'menu.file.version_history': return 'Version history';
			case 'menu.file.version_history_options.name_current_version': return 'Name current version';
			case 'menu.file.version_history_options.see_version_history': return 'See version history';
			case 'menu.file.make_available_offline': return 'Make available offline';
			case 'menu.file.details': return 'Details';
			case 'menu.file.security_limitations': return 'Security limitations';
			case 'menu.file.settings': return 'Settings';
			case 'menu.file.language': return 'Language';
			case 'menu.file.print': return 'Print';
			case 'menu.edit.name': return 'Edit';
			case 'menu.edit.undo': return 'Undo';
			case 'menu.edit.redo': return 'Redo';
			case 'menu.edit.cut': return 'Cut';
			case 'menu.edit.copy': return 'Copy';
			case 'menu.edit.paste': return 'Paste';
			case 'menu.edit.paste_special': return 'Paste special';
			case 'menu.edit.paste_special_options.values': return 'Paste values only';
			case 'menu.edit.paste_special_options.formatting': return 'Paste format only';
			case 'menu.edit.paste_special_options.formulas': return 'Paste formula only';
			case 'menu.edit.paste_special_options.conditional_formatting': return 'Conditional formatting only';
			case 'menu.edit.paste_special_options.data_validation': return 'Data validation only';
			case 'menu.edit.paste_special_options.transposed': return 'Transposed';
			case 'menu.edit.paste_special_options.column_width': return 'Column width only';
			case 'menu.edit.paste_special_options.all_without_borders': return 'All except borders';
			case 'menu.edit.move': return 'Move';
			case 'menu.edit.delete': return 'Delete';
			case 'menu.edit.delete_options.values': return 'Values';
			case 'menu.edit.delete_options.row': return ({required Object index}) => 'Row ${index}';
			case 'menu.edit.delete_options.column': return ({required Object index}) => 'Column ${index}';
			case 'menu.edit.delete_options.cells_shift_up': return 'Cells and shift up';
			case 'menu.edit.delete_options.cells_shift_left': return 'Cells and shift left';
			case 'menu.edit.delete_options.notes': return 'Notes';
			case 'menu.edit.find_and_replace': return 'Find and replace';
			case 'menu.view.name': return 'View';
			case 'menu.view.show': return 'Show';
			case 'menu.view.show_options.formula_bar': return 'Formula bar';
			case 'menu.view.show_options.gridlines': return 'Gridlines';
			case 'menu.view.show_options.formulas': return 'Formulas';
			case 'menu.view.show_options.protected_ranges': return 'Protected ranges';
			case 'menu.view.freeze': return 'Freeze';
			case 'menu.view.freeze_options.no_rows': return 'No rows';
			case 'menu.view.freeze_options.k1Row': return '1 row';
			case 'menu.view.freeze_options.k2Rows': return '2 rows';
			case 'menu.view.freeze_options.up_to_current_row': return ({required Object index}) => 'Up to row ${index}';
			case 'menu.view.freeze_options.no_columns': return 'No columns';
			case 'menu.view.freeze_options.k1Column': return '1 column';
			case 'menu.view.freeze_options.k2Columns': return '2 columns';
			case 'menu.view.freeze_options.up_to_current_column': return ({required Object index}) => 'Up to column ${index}';
			case 'menu.view.group': return 'Group';
			case 'menu.view.group_options.group': return 'Group';
			case 'menu.view.group_options.ungroup': return 'Ungroup';
			case 'menu.view.comments': return 'Comments';
			case 'menu.view.comments_options.hide_comments': return 'Hide comments';
			case 'menu.view.comments_options.minimize_comments': return 'Minimize comments';
			case 'menu.view.comments_options.show_all': return 'Show all comments';
			case 'menu.view.hidden_sheets': return 'Hidden sheets';
			case 'menu.view.zoom': return 'Zoom';
			case 'menu.view.full_screen': return 'Full screen';
			case 'menu.insert.name': return 'Insert';
			case 'menu.insert.cells': return 'Cells';
			case 'menu.insert.cells_options.cells_and_shift_right': return 'Insert cells and shift right';
			case 'menu.insert.cells_options.cells_and_shift_down': return 'Insert cells and shift down';
			case 'menu.insert.rows': return 'Rows';
			case 'menu.insert.rows_options.above': return 'Insert 1 row above';
			case 'menu.insert.rows_options.below': return 'Insert 1 row below';
			case 'menu.insert.columns': return 'Columns';
			case 'menu.insert.columns_options.left': return 'Insert 1 column left';
			case 'menu.insert.columns_options.right': return 'Insert 1 column right';
			case 'menu.insert.sheet': return 'Sheet';
			case 'menu.insert.tables': return 'Tables';
			case 'menu.insert.chart': return 'Chart';
			case 'menu.insert.pivot_table': return 'Pivot table';
			case 'menu.insert.image': return 'Image';
			case 'menu.insert.image_options.in_cell': return 'Insert image in cell';
			case 'menu.insert.image_options.over_cells': return 'Insert image over cells';
			case 'menu.insert.drawing': return 'Drawing';
			case 'menu.insert.function': return 'Function';
			case 'menu.insert.link': return 'Link';
			case 'menu.insert.checkbox': return 'Checkbox';
			case 'menu.insert.dropdown': return 'Dropdown';
			case 'menu.insert.emoji': return 'Emoji';
			case 'menu.insert.smart_chips': return 'Smart chips';
			case 'menu.insert.smart_chips_options.people': return 'People';
			case 'menu.insert.smart_chips_options.file': return 'File';
			case 'menu.insert.smart_chips_options.calendar': return 'Calendar events';
			case 'menu.insert.smart_chips_options.place': return 'Place';
			case 'menu.insert.smart_chips_options.finance': return 'Finance';
			case 'menu.insert.smart_chips_options.rating': return 'Rating';
			case 'menu.insert.comment': return 'Comment';
			case 'menu.insert.note': return 'Note';
			case 'menu.format.name': return 'Format';
			case 'menu.format.theme': return 'Theme';
			case 'menu.format.number': return 'Number';
			case 'menu.format.number_options.automatic': return 'Automatic';
			case 'menu.format.number_options.plain_text': return 'Plain text';
			case 'menu.format.number_options.number': return 'Number';
			case 'menu.format.number_options.percent': return 'Percent';
			case 'menu.format.number_options.scientific': return 'Scientific';
			case 'menu.format.number_options.accounting': return 'Accounting';
			case 'menu.format.number_options.financial': return 'Financial';
			case 'menu.format.number_options.currency': return 'Currency';
			case 'menu.format.number_options.currency_rounded': return 'Currency rounded';
			case 'menu.format.number_options.date': return 'Date';
			case 'menu.format.number_options.time': return 'Time';
			case 'menu.format.number_options.date_time': return 'Date time';
			case 'menu.format.number_options.duration': return 'Duration';
			case 'menu.format.number_options.custom_currency': return 'Custom currency';
			case 'menu.format.number_options.custom_date': return 'Custom date and time';
			case 'menu.format.number_options.custom_number': return 'Custom number format';
			case 'menu.format.text': return 'Text';
			case 'menu.format.text_options.bold': return 'Bold';
			case 'menu.format.text_options.italic': return 'Italic';
			case 'menu.format.text_options.underline': return 'Underline';
			case 'menu.format.text_options.strikethrough': return 'Strikethrough';
			case 'menu.format.alignment': return 'Alignment';
			case 'menu.format.alignment_options.left': return 'Left';
			case 'menu.format.alignment_options.center': return 'Center';
			case 'menu.format.alignment_options.right': return 'Right';
			case 'menu.format.alignment_options.top': return 'Top';
			case 'menu.format.alignment_options.middle': return 'Middle';
			case 'menu.format.alignment_options.bottom': return 'Bottom';
			case 'menu.format.wrapping': return 'Wrapping';
			case 'menu.format.wrapping_options.overflow': return 'Overflow';
			case 'menu.format.wrapping_options.wrap': return 'Wrap';
			case 'menu.format.wrapping_options.clip': return 'Clip';
			case 'menu.format.rotation': return 'Rotation';
			case 'menu.format.rotation_options.none': return 'None';
			case 'menu.format.rotation_options.tilt_up': return 'Tilt up';
			case 'menu.format.rotation_options.tilt_down': return 'Tilt down';
			case 'menu.format.rotation_options.stack_vertically': return 'Stack vertically';
			case 'menu.format.rotation_options.rotate_up': return 'Rotate up';
			case 'menu.format.rotation_options.rotate_down': return 'Rotate down';
			case 'menu.format.rotation_options.custom_angle': return 'Custom angle';
			case 'menu.format.font_size': return 'Font size';
			case 'menu.format.merge_cells': return 'Merge cells';
			case 'menu.format.merge_cells_options.merge_all': return 'Merge all';
			case 'menu.format.merge_cells_options.merge_vertically': return 'Merge vertically';
			case 'menu.format.merge_cells_options.merge_horizontally': return 'Merge horizontally';
			case 'menu.format.merge_cells_options.unmerge': return 'Unmerge';
			case 'menu.format.convert_to_table': return 'Convert to table';
			case 'menu.format.conditional_formatting': return 'Conditional formatting';
			case 'menu.format.alternating_colors': return 'Alternating colors';
			case 'menu.format.clear_formatting': return 'Clear formatting';
			case 'menu.data.name': return 'Data';
			case 'menu.data.sort_sheet': return 'Sort sheet';
			case 'menu.data.sort_sheet_options.by_column_asc': return ({required Object index}) => 'Sort sheet by column ${index} (A to Z)';
			case 'menu.data.sort_sheet_options.by_column_desc': return ({required Object index}) => 'Sort sheet by column ${index} (Z to A)';
			case 'menu.data.sort_range': return 'Sort range';
			case 'menu.data.sort_range_options.by_column_asc': return ({required Object index}) => 'Sort range by column ${index} (A to Z)';
			case 'menu.data.sort_range_options.by_column_desc': return ({required Object index}) => 'Sort range by column ${index} (Z to A)';
			case 'menu.data.sort_range_options.advanced': return 'Advanced range sorting options';
			case 'menu.data.create_filter': return 'Create a filter';
			case 'menu.data.create_group_by_view': return 'Create group by view';
			case 'menu.data.create_filter_view': return 'Create filter view';
			case 'menu.data.add_slicer': return 'Add a slicer';
			case 'menu.data.protect_sheet': return 'Protect sheet and ranges';
			case 'menu.data.named_ranges': return 'Named ranges';
			case 'menu.data.named_functions': return 'Named functions';
			case 'menu.data.randomize_range': return 'Randomize range';
			case 'menu.data.column_stats': return 'Column stats';
			case 'menu.data.data_validation': return 'Data validation';
			case 'menu.data.data_cleanup': return 'Data cleanup';
			case 'menu.data.data_cleanup_options.cleanup_suggestions': return 'Cleanup suggestions';
			case 'menu.data.data_cleanup_options.remove_duplicates': return 'Remove duplicates';
			case 'menu.data.data_cleanup_options.trim_whitespace': return 'Trim whitespace';
			case 'menu.data.split_to_columns': return 'Split text to columns';
			case 'menu.data.data_extraction': return 'Data extraction';
			case 'menu.tools.name': return 'Tools';
			case 'menu.tools.create_new_form': return 'Create a new form';
			case 'menu.tools.spelling': return 'Spelling';
			case 'menu.tools.spelling_options.spell_check': return 'Spell check';
			case 'menu.tools.spelling_options.personal_dictionary': return 'Personal dictionary';
			case 'menu.tools.suggestion_controls': return 'Suggestion controls';
			case 'menu.tools.suggestion_controls_options.enable_autocomplete': return 'Enable autocomplete';
			case 'menu.tools.suggestion_controls_options.enable_formula_suggestions': return 'Enable formula suggestions';
			case 'menu.tools.suggestion_controls_options.enable_formula_corrections': return 'Enable formula corrections';
			case 'menu.tools.suggestion_controls_options.enable_named_functions_suggestions': return 'Enable named functions suggestions';
			case 'menu.tools.suggestion_controls_options.enable_pivot_table_suggestions': return 'Enable pivot table suggestions';
			case 'menu.tools.suggestion_controls_options.enable_dropdown_chip_suggestions': return 'Enable dropdown chip suggestions';
			case 'menu.tools.suggestion_controls_options.enable_people_suggestions': return 'Enable smart people chip suggestions';
			case 'menu.tools.suggestion_controls_options.enable_table_suggestions': return 'Enable table suggestions';
			case 'menu.tools.suggestion_controls_options.enable_data_analysis_suggestions': return 'Enable data analysis suggestions';
			case 'menu.tools.notifications_settings': return 'Notifications settings';
			case 'menu.tools.notifications_settings_options.edit_notifications': return 'Edit notifications';
			case 'menu.tools.notifications_settings_options.comment_notifications': return 'Comment notifications';
			case 'menu.tools.accessibility': return 'Accessibility';
			case 'menu.help.name': return 'Help';
			case 'menu.help.search': return 'Search the menus';
			case 'menu.help.sheets_help': return 'Sheets help';
			case 'menu.help.training': return 'Training';
			case 'menu.help.updates': return 'Updates';
			case 'menu.help.help_sheets_improve': return 'Help Sheets improve';
			case 'menu.help.privacy_policy': return 'Privacy policy';
			case 'menu.help.terms_of_service': return 'Terms of service';
			case 'menu.help.function_list': return 'Function list';
			case 'menu.help.keyboard_shortcuts': return 'Keyboard shortcuts';
			case 'toolbar.menus.hint': return 'Menus';
			case 'toolbar.menus.tooltip': return 'Search the menus (Alt+/)';
			case 'toolbar.undo.tooltip': return 'Undo (Ctrl+Z)';
			case 'toolbar.redo.tooltip': return 'Redo (Ctrl+Y)';
			case 'toolbar.print.tooltip': return 'Print (Ctrl+P)';
			case 'toolbar.paint_format.tooltip': return 'Paint format';
			case 'toolbar.zoom.tooltip': return 'Zoom';
			case 'toolbar.currency.tooltip': return 'Format as currency';
			case 'toolbar.percent.tooltip': return 'Format as percent';
			case 'toolbar.decrease_decimal.tooltip': return 'Decrease decimal places';
			case 'toolbar.increase_decimal.tooltip': return 'Increase decimal places';
			case 'toolbar.more_formats.tooltip': return 'More formats';
			case 'toolbar.font.tooltip': return 'Font';
			case 'toolbar.font.options': return 'More fonts';
			case 'toolbar.decrease_font_size.tooltip': return 'Decrease font size (Ctrl+Shift+,)';
			case 'toolbar.font_size.tooltip': return 'Font size';
			case 'toolbar.increase_font_size.tooltip': return 'Increase font size (Ctrl+Shift+.)';
			case 'toolbar.bold.tooltip': return 'Bold (Ctrl+B)';
			case 'toolbar.italic.tooltip': return 'Italic (Ctrl+I)';
			case 'toolbar.strikethrough.tooltip': return 'Strikethrough (Alt+Shift+5)';
			case 'toolbar.text_color.tooltip': return 'Text color';
			case 'toolbar.fill_color.tooltip': return 'Fill color';
			case 'toolbar.fill_color.alternating_colors': return 'Alternating colors';
			case 'toolbar.borders.tooltip': return 'Borders';
			case 'toolbar.borders.options.all': return 'All borders';
			case 'toolbar.borders.options.inner': return 'Inner borders';
			case 'toolbar.borders.options.horizontal': return 'Horizontal borders';
			case 'toolbar.borders.options.vertical': return 'Vertical borders';
			case 'toolbar.borders.options.outer': return 'Outer borders';
			case 'toolbar.borders.options.left': return 'Left border';
			case 'toolbar.borders.options.top': return 'Top border';
			case 'toolbar.borders.options.right': return 'Right border';
			case 'toolbar.borders.options.bottom': return 'Bottom border';
			case 'toolbar.borders.options.clear': return 'Clear borders';
			case 'toolbar.borders.options.border_color': return 'Border color';
			case 'toolbar.borders.options.border_style': return 'Border style';
			case 'toolbar.merge.tooltip': return 'Merge cells';
			case 'toolbar.merge.options.merge_all': return 'Merge all';
			case 'toolbar.merge.options.merge_vertically': return 'Merge vertically';
			case 'toolbar.merge.options.merge_horizontally': return 'Merge horizontally';
			case 'toolbar.merge.options.unmerge': return 'Unmerge';
			case 'toolbar.merge_types.tooltip': return 'Select merge type';
			case 'toolbar.align.tooltip': return 'Horizontal align';
			case 'toolbar.align.options.left': return 'Left';
			case 'toolbar.align.options.center': return 'Center';
			case 'toolbar.align.options.right': return 'Right';
			case 'toolbar.valign.tooltip': return 'Vertical align';
			case 'toolbar.valign.options.top': return 'Top';
			case 'toolbar.valign.options.middle': return 'Middle';
			case 'toolbar.valign.options.bottom': return 'Bottom';
			case 'toolbar.wrap.tooltip': return 'Text wrapping';
			case 'toolbar.wrap.options.overflow': return 'Overflow';
			case 'toolbar.wrap.options.wrap': return 'Wrap';
			case 'toolbar.wrap.options.clip': return 'Clip';
			case 'toolbar.rotate.tooltip': return 'Text rotation';
			case 'toolbar.rotate.options.none': return 'None';
			case 'toolbar.rotate.options.tilt_up': return 'Tilt up';
			case 'toolbar.rotate.options.tilt_down': return 'Tilt down';
			case 'toolbar.rotate.options.stack_vertically': return 'Stack vertically';
			case 'toolbar.rotate.options.rotate_up': return 'Rotate up';
			case 'toolbar.rotate.options.rotate_down': return 'Rotate down';
			case 'toolbar.rotate.options.custom_angle': return 'Custom angle';
			case 'toolbar.link.tooltip': return 'Insert link (Ctrl+K)';
			case 'toolbar.comment.tooltip': return 'Insert comment (Ctrl+Alt+M)';
			case 'toolbar.chart.tooltip': return 'Insert chart';
			case 'toolbar.filter.tooltip': return 'Create a filter';
			case 'toolbar.filter_views.tooltip': return 'Filter views';
			case 'toolbar.filter_views.options.create_group_by_view': return 'Create group by view';
			case 'toolbar.filter_views.options.create_filter_view': return 'Create filter view';
			case 'toolbar.functions.tooltip': return 'Functions';
			case 'cell_menu.cut': return 'Cut';
			case 'cell_menu.copy': return 'Copy';
			case 'cell_menu.paste': return 'Paste';
			case 'cell_menu.paste_special': return 'Paste special';
			case 'cell_menu.paste_special_options.values': return 'Paste values only';
			case 'cell_menu.paste_special_options.formatting': return 'Paste format only';
			case 'cell_menu.paste_special_options.formulas': return 'Paste formula only';
			case 'cell_menu.paste_special_options.conditional_formatting': return 'Conditional formatting only';
			case 'cell_menu.paste_special_options.data_validation': return 'Data validation only';
			case 'cell_menu.paste_special_options.transposed': return 'Transposed';
			case 'cell_menu.paste_special_options.column_width': return 'Column width only';
			case 'cell_menu.paste_special_options.all_without_borders': return 'All except borders';
			case 'cell_menu.insert_row_above': return 'Insert 1 row above';
			case 'cell_menu.insert_column_left': return 'Insert 1 column left';
			case 'cell_menu.insert_cells': return 'Insert cells';
			case 'cell_menu.insert_cells_options.cells_and_shift_right': return 'Insert cells and shift right';
			case 'cell_menu.insert_cells_options.cells_and_shift_down': return 'Insert cells and shift down';
			case 'cell_menu.delete_row': return 'Delete row';
			case 'cell_menu.delete_column': return 'Delete column';
			case 'cell_menu.delete_cells': return 'Delete cells';
			case 'cell_menu.delete_cells_options.cells_and_shift_left': return 'Insert cells and shift left';
			case 'cell_menu.delete_cells_options.cells_and_shift_up': return 'Insert cells and shift up';
			case 'cell_menu.convert_to_table': return 'Convert to table';
			case 'cell_menu.create_filter': return 'Create a filter';
			case 'cell_menu.filter_by_cell_value': return 'Filter by cell value';
			case 'cell_menu.show_edit_history': return 'Show edit history';
			case 'cell_menu.insert_link': return 'Insert link';
			case 'cell_menu.comment': return 'Comment';
			case 'cell_menu.insert_note': return 'Insert note';
			case 'cell_menu.tables': return 'Tables';
			case 'cell_menu.dropdown': return 'Dropdown';
			case 'cell_menu.smart_chips': return 'Smart chips';
			case 'cell_menu.smart_chips_options.people': return 'People';
			case 'cell_menu.smart_chips_options.file': return 'File';
			case 'cell_menu.smart_chips_options.calendar': return 'Calendar events';
			case 'cell_menu.smart_chips_options.place': return 'Place';
			case 'cell_menu.smart_chips_options.finance': return 'Finance';
			case 'cell_menu.smart_chips_options.rating': return 'Rating';
			case 'cell_menu.more': return 'View more cell actions';
			case 'cell_menu.more_options.conditional_formatting': return 'Conditional formatting';
			case 'cell_menu.more_options.data_validation': return 'Data validation';
			case 'cell_menu.more_options.get_link_to_cell': return 'Get link to this cell';
			case 'cell_menu.more_options.define_named_range': return 'Define named range';
			case 'cell_menu.more_options.protect_range': return 'Protect range';
			case 'column_menu.cut': return 'Cut';
			case 'column_menu.copy': return 'Copy';
			case 'column_menu.paste': return 'Paste';
			case 'column_menu.paste_special': return 'Paste special';
			case 'column_menu.paste_special_options.values': return 'Paste values only';
			case 'column_menu.paste_special_options.formatting': return 'Paste format only';
			case 'column_menu.paste_special_options.formulas': return 'Paste formula only';
			case 'column_menu.paste_special_options.conditional_formatting': return 'Conditional formatting only';
			case 'column_menu.paste_special_options.data_validation': return 'Data validation only';
			case 'column_menu.paste_special_options.transposed': return 'Transposed';
			case 'column_menu.paste_special_options.column_width': return 'Column width only';
			case 'column_menu.paste_special_options.all_without_borders': return 'All except borders';
			case 'column_menu.insert_column_left': return 'Insert 1 column left';
			case 'column_menu.insert_column_right': return 'Insert 1 column right';
			case 'column_menu.delete_column': return 'Delete column';
			case 'column_menu.clear_column': return 'Clear column';
			case 'column_menu.hide_column': return 'Hide column';
			case 'column_menu.resize_column': return 'Resize column';
			case 'column_menu.create_filter': return 'Create a filter';
			case 'column_menu.sort_asc': return 'Sort sheet A to Z';
			case 'column_menu.sort_desc': return 'Sort sheet Z to A';
			case 'column_menu.conditional_formatting': return 'Conditional formatting';
			case 'column_menu.data_validation': return 'Data validation';
			case 'column_menu.column_stats': return 'Column stats';
			case 'column_menu.dropdown': return 'Dropdown';
			case 'column_menu.smart_chips': return 'Smart chips';
			case 'column_menu.smart_chips_options.people': return 'People';
			case 'column_menu.smart_chips_options.file': return 'File';
			case 'column_menu.smart_chips_options.calendar': return 'Calendar events';
			case 'column_menu.smart_chips_options.place': return 'Place';
			case 'column_menu.smart_chips_options.finance': return 'Finance';
			case 'column_menu.smart_chips_options.rating': return 'Rating';
			case 'column_menu.more': return 'View more column actions';
			case 'column_menu.more_options.freeze': return ({required Object index}) => 'Freeze up to column ${index}';
			case 'column_menu.more_options.group': return 'Group column';
			case 'column_menu.more_options.get_link_to_range': return 'Get link to this range';
			case 'column_menu.more_options.randomize_range': return 'Randomize range';
			case 'column_menu.more_options.define_named_range': return 'Define named range';
			case 'column_menu.more_options.protect_range': return 'Protect range';
			case 'row_menu.cut': return 'Cut';
			case 'row_menu.copy': return 'Copy';
			case 'row_menu.paste': return 'Paste';
			case 'row_menu.paste_special': return 'Paste special';
			case 'row_menu.paste_special_options.values': return 'Paste values only';
			case 'row_menu.paste_special_options.formatting': return 'Paste format only';
			case 'row_menu.paste_special_options.formulas': return 'Paste formula only';
			case 'row_menu.paste_special_options.conditional_formatting': return 'Conditional formatting only';
			case 'row_menu.paste_special_options.data_validation': return 'Data validation only';
			case 'row_menu.paste_special_options.transposed': return 'Transposed';
			case 'row_menu.paste_special_options.column_width': return 'Column width only';
			case 'row_menu.paste_special_options.all_without_borders': return 'All except borders';
			case 'row_menu.insert_row_above': return 'Insert 1 row above';
			case 'row_menu.insert_row_below': return 'Insert 1 row below';
			case 'row_menu.delete_row': return 'Delete row';
			case 'row_menu.clear_row': return 'Clear row';
			case 'row_menu.hide_row': return 'Hide row';
			case 'row_menu.resize_row': return 'Resize row';
			case 'row_menu.create_filter': return 'Create a filter';
			case 'row_menu.conditional_formatting': return 'Conditional formatting';
			case 'row_menu.data_validation': return 'Data validation';
			case 'row_menu.more': return 'View more row actions';
			case 'row_menu.more_options.freeze': return ({required Object index}) => 'Freeze up to row ${index}';
			case 'row_menu.more_options.group': return 'Group row';
			case 'row_menu.more_options.get_link_to_range': return 'Get link to this range';
			case 'row_menu.more_options.define_named_range': return 'Define named range';
			case 'row_menu.more_options.protect_range': return 'Protect range';
			case 'header.star.tooltip': return 'Star';
			case 'header.move.tooltip': return 'Move';
			case 'header.status.tooltip': return 'See document status';
			case 'header.history.tooltip': return 'Show document history';
			case 'header.comments.tooltip': return 'Show all comments';
			case 'header.call.tooltip': return 'Join a call here or present this tab to the cell';
			case 'header.share.tooltip': return 'Quick sharing actions';
			case 'bottom_bar.tab_name': return ({required Object index}) => 'Sheet${index}';
			case 'bottom_bar.add_sheet': return 'Add sheet';
			case 'bottom_bar.all_sheets': return 'All sheets';
			case 'bottom_bar.show_side_panel': return 'Show side panel';
			default: return null;
		}
	}
}

