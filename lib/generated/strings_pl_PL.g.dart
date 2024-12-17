///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsPlPl implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsPlPl({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.plPl,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <pl-PL>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsPlPl _root = this; // ignore: unused_field

	// Translations
	@override String get title => 'Untitled spreadsheet';
	@override String get share => 'Udostępnij';
	@override late final _TranslationsMenuPlPl menu = _TranslationsMenuPlPl._(_root);
	@override late final _TranslationsToolbarPlPl toolbar = _TranslationsToolbarPlPl._(_root);
	@override late final _TranslationsCellMenuPlPl cell_menu = _TranslationsCellMenuPlPl._(_root);
	@override late final _TranslationsColumnMenuPlPl column_menu = _TranslationsColumnMenuPlPl._(_root);
	@override late final _TranslationsRowMenuPlPl row_menu = _TranslationsRowMenuPlPl._(_root);
	@override late final _TranslationsHeaderPlPl header = _TranslationsHeaderPlPl._(_root);
	@override late final _TranslationsBottomBarPlPl bottom_bar = _TranslationsBottomBarPlPl._(_root);
}

// Path: menu
class _TranslationsMenuPlPl implements TranslationsMenuEn {
	_TranslationsMenuPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsMenuFontPlPl font = _TranslationsMenuFontPlPl._(_root);
	@override late final _TranslationsMenuFilePlPl file = _TranslationsMenuFilePlPl._(_root);
	@override late final _TranslationsMenuEditPlPl edit = _TranslationsMenuEditPlPl._(_root);
	@override late final _TranslationsMenuViewPlPl view = _TranslationsMenuViewPlPl._(_root);
	@override late final _TranslationsMenuInsertPlPl insert = _TranslationsMenuInsertPlPl._(_root);
	@override late final _TranslationsMenuFormatPlPl format = _TranslationsMenuFormatPlPl._(_root);
	@override late final _TranslationsMenuDataPlPl data = _TranslationsMenuDataPlPl._(_root);
	@override late final _TranslationsMenuToolsPlPl tools = _TranslationsMenuToolsPlPl._(_root);
	@override late final _TranslationsMenuHelpPlPl help = _TranslationsMenuHelpPlPl._(_root);
}

// Path: toolbar
class _TranslationsToolbarPlPl implements TranslationsToolbarEn {
	_TranslationsToolbarPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsToolbarMenusPlPl menus = _TranslationsToolbarMenusPlPl._(_root);
	@override late final _TranslationsToolbarUndoPlPl undo = _TranslationsToolbarUndoPlPl._(_root);
	@override late final _TranslationsToolbarRedoPlPl redo = _TranslationsToolbarRedoPlPl._(_root);
	@override late final _TranslationsToolbarPrintPlPl print = _TranslationsToolbarPrintPlPl._(_root);
	@override late final _TranslationsToolbarPaintFormatPlPl paint_format = _TranslationsToolbarPaintFormatPlPl._(_root);
	@override late final _TranslationsToolbarZoomPlPl zoom = _TranslationsToolbarZoomPlPl._(_root);
	@override late final _TranslationsToolbarCurrencyPlPl currency = _TranslationsToolbarCurrencyPlPl._(_root);
	@override late final _TranslationsToolbarPercentPlPl percent = _TranslationsToolbarPercentPlPl._(_root);
	@override late final _TranslationsToolbarDecreaseDecimalPlPl decrease_decimal = _TranslationsToolbarDecreaseDecimalPlPl._(_root);
	@override late final _TranslationsToolbarIncreaseDecimalPlPl increase_decimal = _TranslationsToolbarIncreaseDecimalPlPl._(_root);
	@override late final _TranslationsToolbarMoreFormatsPlPl more_formats = _TranslationsToolbarMoreFormatsPlPl._(_root);
	@override late final _TranslationsToolbarFontPlPl font = _TranslationsToolbarFontPlPl._(_root);
	@override late final _TranslationsToolbarDecreaseFontSizePlPl decrease_font_size = _TranslationsToolbarDecreaseFontSizePlPl._(_root);
	@override late final _TranslationsToolbarFontSizePlPl font_size = _TranslationsToolbarFontSizePlPl._(_root);
	@override late final _TranslationsToolbarIncreaseFontSizePlPl increase_font_size = _TranslationsToolbarIncreaseFontSizePlPl._(_root);
	@override late final _TranslationsToolbarBoldPlPl bold = _TranslationsToolbarBoldPlPl._(_root);
	@override late final _TranslationsToolbarItalicPlPl italic = _TranslationsToolbarItalicPlPl._(_root);
	@override late final _TranslationsToolbarStrikethroughPlPl strikethrough = _TranslationsToolbarStrikethroughPlPl._(_root);
	@override late final _TranslationsToolbarTextColorPlPl text_color = _TranslationsToolbarTextColorPlPl._(_root);
	@override late final _TranslationsToolbarFillColorPlPl fill_color = _TranslationsToolbarFillColorPlPl._(_root);
	@override late final _TranslationsToolbarBordersPlPl borders = _TranslationsToolbarBordersPlPl._(_root);
	@override late final _TranslationsToolbarMergePlPl merge = _TranslationsToolbarMergePlPl._(_root);
	@override late final _TranslationsToolbarMergeTypesPlPl merge_types = _TranslationsToolbarMergeTypesPlPl._(_root);
	@override late final _TranslationsToolbarAlignPlPl align = _TranslationsToolbarAlignPlPl._(_root);
	@override late final _TranslationsToolbarValignPlPl valign = _TranslationsToolbarValignPlPl._(_root);
	@override late final _TranslationsToolbarWrapPlPl wrap = _TranslationsToolbarWrapPlPl._(_root);
	@override late final _TranslationsToolbarRotatePlPl rotate = _TranslationsToolbarRotatePlPl._(_root);
	@override late final _TranslationsToolbarLinkPlPl link = _TranslationsToolbarLinkPlPl._(_root);
	@override late final _TranslationsToolbarCommentPlPl comment = _TranslationsToolbarCommentPlPl._(_root);
	@override late final _TranslationsToolbarChartPlPl chart = _TranslationsToolbarChartPlPl._(_root);
	@override late final _TranslationsToolbarFilterPlPl filter = _TranslationsToolbarFilterPlPl._(_root);
	@override late final _TranslationsToolbarFilterViewsPlPl filter_views = _TranslationsToolbarFilterViewsPlPl._(_root);
	@override late final _TranslationsToolbarFunctionsPlPl functions = _TranslationsToolbarFunctionsPlPl._(_root);
}

// Path: cell_menu
class _TranslationsCellMenuPlPl implements TranslationsCellMenuEn {
	_TranslationsCellMenuPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get cut => 'Wytnij';
	@override String get copy => 'Kopiuj';
	@override String get paste => 'Wklej';
	@override String get paste_special => 'Wklej specjalne';
	@override late final _TranslationsCellMenuPasteSpecialOptionsPlPl paste_special_options = _TranslationsCellMenuPasteSpecialOptionsPlPl._(_root);
	@override String get insert_row_above => 'Wstaw wiersz powyzej';
	@override String get insert_column_left => 'Wstaw kolumnę po lewej';
	@override String get insert_cells => 'Wstaw komórki';
	@override late final _TranslationsCellMenuInsertCellsOptionsPlPl insert_cells_options = _TranslationsCellMenuInsertCellsOptionsPlPl._(_root);
	@override String get delete_row => 'Usuń wiersz';
	@override String get delete_column => 'Usuń kolumnę';
	@override String get delete_cells => 'Usuń komórki';
	@override late final _TranslationsCellMenuDeleteCellsOptionsPlPl delete_cells_options = _TranslationsCellMenuDeleteCellsOptionsPlPl._(_root);
	@override String get convert_to_table => 'Przekonwertuj na tabelę';
	@override String get create_filter => 'Utwórz filtr';
	@override String get filter_by_cell_value => 'Filtruj według wartości w komórce';
	@override String get show_edit_history => 'Pokaż historię zmian';
	@override String get insert_link => 'Wstaw link';
	@override String get comment => 'Komentarz';
	@override String get insert_note => 'Wstaw notatkę';
	@override String get tables => 'Tabele';
	@override String get dropdown => 'Menu';
	@override String get smart_chips => 'Elementy inteligentne';
	@override late final _TranslationsCellMenuSmartChipsOptionsPlPl smart_chips_options = _TranslationsCellMenuSmartChipsOptionsPlPl._(_root);
	@override String get more => 'Zobacz więcej czynności dotyczących komórki';
	@override late final _TranslationsCellMenuMoreOptionsPlPl more_options = _TranslationsCellMenuMoreOptionsPlPl._(_root);
}

// Path: column_menu
class _TranslationsColumnMenuPlPl implements TranslationsColumnMenuEn {
	_TranslationsColumnMenuPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get cut => 'Wytnij';
	@override String get copy => 'Kopiuj';
	@override String get paste => 'Wklej';
	@override String get paste_special => 'Wklej specjalne';
	@override late final _TranslationsColumnMenuPasteSpecialOptionsPlPl paste_special_options = _TranslationsColumnMenuPasteSpecialOptionsPlPl._(_root);
	@override String get insert_column_left => 'Wstaw kolumnę po lewej';
	@override String get insert_column_right => 'Wstaw kolumnę po prawej';
	@override String get delete_column => 'Usuń kolumnę';
	@override String get clear_column => 'Wyczyść kolumnę';
	@override String get hide_column => 'Ukryj kolumnę';
	@override String get resize_column => 'Zmień rozmiar kolumny';
	@override String get create_filter => 'Utwórz filtr';
	@override String get sort_asc => 'Sortuj arkusz Od A do Z';
	@override String get sort_desc => 'Sortuj arkusz Od Z do A';
	@override String get conditional_formatting => 'Formatowanie warunkowe';
	@override String get data_validation => 'Sprawdzanie poprawności danych';
	@override String get column_stats => 'Statystyki dotyczące kolumn';
	@override String get dropdown => 'Menu';
	@override String get smart_chips => 'Elementy inteligentne';
	@override late final _TranslationsColumnMenuSmartChipsOptionsPlPl smart_chips_options = _TranslationsColumnMenuSmartChipsOptionsPlPl._(_root);
	@override String get more => 'Zobacz więcej czynności dotyczących kolumny';
	@override late final _TranslationsColumnMenuMoreOptionsPlPl more_options = _TranslationsColumnMenuMoreOptionsPlPl._(_root);
}

// Path: row_menu
class _TranslationsRowMenuPlPl implements TranslationsRowMenuEn {
	_TranslationsRowMenuPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get cut => 'Wytnij';
	@override String get copy => 'Kopiuj';
	@override String get paste => 'Wklej';
	@override String get paste_special => 'Wklej specjalne';
	@override late final _TranslationsRowMenuPasteSpecialOptionsPlPl paste_special_options = _TranslationsRowMenuPasteSpecialOptionsPlPl._(_root);
	@override String get insert_row_above => 'Wstaw wiersz powyżej';
	@override String get insert_row_below => 'Wstaw wiersz poniżej';
	@override String get delete_row => 'Usuń wiersz';
	@override String get clear_row => 'Wyczyść wiersz';
	@override String get hide_row => 'Ukryj wiersz';
	@override String get resize_row => 'Zmień rozmiar wiersza';
	@override String get create_filter => 'Utwórz filtr';
	@override String get conditional_formatting => 'Formatowanie warunkowe';
	@override String get data_validation => 'Sprawdzanie poprawności danych';
	@override String get more => 'Zobacz więcej czynności dotyczących wiersza';
	@override late final _TranslationsRowMenuMoreOptionsPlPl more_options = _TranslationsRowMenuMoreOptionsPlPl._(_root);
}

// Path: header
class _TranslationsHeaderPlPl implements TranslationsHeaderEn {
	_TranslationsHeaderPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsHeaderStarPlPl star = _TranslationsHeaderStarPlPl._(_root);
	@override late final _TranslationsHeaderMovePlPl move = _TranslationsHeaderMovePlPl._(_root);
	@override late final _TranslationsHeaderStatusPlPl status = _TranslationsHeaderStatusPlPl._(_root);
	@override late final _TranslationsHeaderHistoryPlPl history = _TranslationsHeaderHistoryPlPl._(_root);
	@override late final _TranslationsHeaderCommentsPlPl comments = _TranslationsHeaderCommentsPlPl._(_root);
	@override late final _TranslationsHeaderCallPlPl call = _TranslationsHeaderCallPlPl._(_root);
	@override late final _TranslationsHeaderSharePlPl share = _TranslationsHeaderSharePlPl._(_root);
}

// Path: bottom_bar
class _TranslationsBottomBarPlPl implements TranslationsBottomBarEn {
	_TranslationsBottomBarPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String tab_name({required Object index}) => 'Arkusz${index}';
	@override String get add_sheet => 'Dodaj arkusz';
	@override String get all_sheets => 'Wszystkie arkusze';
	@override String get show_side_panel => 'Pokaż panel boczny';
}

// Path: menu.font
class _TranslationsMenuFontPlPl implements TranslationsMenuFontEn {
	_TranslationsMenuFontPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String kDefault({required Object name}) => 'Domyślna (${name})';
	@override String get more_fonts => 'Więcej czcionek';
	@override String get theme => 'Motyw';
	@override String get recent => 'Ostatnie';
}

// Path: menu.file
class _TranslationsMenuFilePlPl implements TranslationsMenuFileEn {
	_TranslationsMenuFilePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get name => 'Plik';
	@override String get kNew => 'Nowy';
	@override late final _TranslationsMenuFileNewOptionsPlPl new_options = _TranslationsMenuFileNewOptionsPlPl._(_root);
	@override String get open => 'Otwórz';
	@override String get import => 'Importuj';
	@override String get make_copy => 'Utwórz kopię';
	@override String get share => 'Udostępnij';
	@override late final _TranslationsMenuFileShareOptionsPlPl share_options = _TranslationsMenuFileShareOptionsPlPl._(_root);
	@override String get email => 'Wyślij e-mailem';
	@override late final _TranslationsMenuFileEmailOptionsPlPl email_options = _TranslationsMenuFileEmailOptionsPlPl._(_root);
	@override String get download => 'Pobierz';
	@override late final _TranslationsMenuFileDownloadOptionsPlPl download_options = _TranslationsMenuFileDownloadOptionsPlPl._(_root);
	@override String get rename => 'Zmień nazwę';
	@override String get move => 'Przenieś';
	@override String get add_to_drive => 'Dodaj skrót do dysku';
	@override String get move_to_trash => 'Przenieś do kosza';
	@override String get version_history => 'Historia zmian';
	@override late final _TranslationsMenuFileVersionHistoryOptionsPlPl version_history_options = _TranslationsMenuFileVersionHistoryOptionsPlPl._(_root);
	@override String get make_available_offline => 'Udostępnij offline';
	@override String get details => 'Szczegóły';
	@override String get security_limitations => 'Ograniczenia zabezpieczeń';
	@override String get settings => 'Ustawienia';
	@override String get language => 'Język';
	@override String get print => 'Drukuj';
}

// Path: menu.edit
class _TranslationsMenuEditPlPl implements TranslationsMenuEditEn {
	_TranslationsMenuEditPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get name => 'Edytuj';
	@override String get undo => 'Cofnij';
	@override String get redo => 'Ponów';
	@override String get cut => 'Wytnij';
	@override String get copy => 'Kopiuj';
	@override String get paste => 'Wklej';
	@override String get paste_special => 'Wklej specjalne';
	@override late final _TranslationsMenuEditPasteSpecialOptionsPlPl paste_special_options = _TranslationsMenuEditPasteSpecialOptionsPlPl._(_root);
	@override String get move => 'Przenieś';
	@override String get delete => 'Usuń';
	@override late final _TranslationsMenuEditDeleteOptionsPlPl delete_options = _TranslationsMenuEditDeleteOptionsPlPl._(_root);
	@override String get find_and_replace => 'Znajdź i zamień';
}

// Path: menu.view
class _TranslationsMenuViewPlPl implements TranslationsMenuViewEn {
	_TranslationsMenuViewPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get name => 'Widok';
	@override String get show => 'Pokaż';
	@override late final _TranslationsMenuViewShowOptionsPlPl show_options = _TranslationsMenuViewShowOptionsPlPl._(_root);
	@override String get freeze => 'Zablokuj';
	@override late final _TranslationsMenuViewFreezeOptionsPlPl freeze_options = _TranslationsMenuViewFreezeOptionsPlPl._(_root);
	@override String get group => 'Grupuj';
	@override late final _TranslationsMenuViewGroupOptionsPlPl group_options = _TranslationsMenuViewGroupOptionsPlPl._(_root);
	@override String get comments => 'Komentarze';
	@override late final _TranslationsMenuViewCommentsOptionsPlPl comments_options = _TranslationsMenuViewCommentsOptionsPlPl._(_root);
	@override String get hidden_sheets => 'Ukryte arkusze';
	@override String get zoom => 'Zoom';
	@override String get full_screen => 'Pełny ekran';
}

// Path: menu.insert
class _TranslationsMenuInsertPlPl implements TranslationsMenuInsertEn {
	_TranslationsMenuInsertPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get name => 'Wstaw';
	@override String get cells => 'Komórki';
	@override late final _TranslationsMenuInsertCellsOptionsPlPl cells_options = _TranslationsMenuInsertCellsOptionsPlPl._(_root);
	@override String get rows => 'Wiersze';
	@override late final _TranslationsMenuInsertRowsOptionsPlPl rows_options = _TranslationsMenuInsertRowsOptionsPlPl._(_root);
	@override String get columns => 'Kolumny';
	@override late final _TranslationsMenuInsertColumnsOptionsPlPl columns_options = _TranslationsMenuInsertColumnsOptionsPlPl._(_root);
	@override String get sheet => 'Arkusz';
	@override String get tables => 'Tabele';
	@override String get chart => 'Wykres';
	@override String get pivot_table => 'Tabela przestawna';
	@override String get image => 'Obraz';
	@override late final _TranslationsMenuInsertImageOptionsPlPl image_options = _TranslationsMenuInsertImageOptionsPlPl._(_root);
	@override String get drawing => 'Rysunek';
	@override String get function => 'Funkcja';
	@override String get link => 'Link';
	@override String get checkbox => 'Pole wyboru';
	@override String get dropdown => 'Menu';
	@override String get emoji => 'Emotikony';
	@override String get smart_chips => 'Elementy inteligentne';
	@override late final _TranslationsMenuInsertSmartChipsOptionsPlPl smart_chips_options = _TranslationsMenuInsertSmartChipsOptionsPlPl._(_root);
	@override String get comment => 'Komentarz';
	@override String get note => 'Notatka';
}

// Path: menu.format
class _TranslationsMenuFormatPlPl implements TranslationsMenuFormatEn {
	_TranslationsMenuFormatPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get name => 'Formatuj';
	@override String get theme => 'Motyw';
	@override String get number => 'Liczba';
	@override late final _TranslationsMenuFormatNumberOptionsPlPl number_options = _TranslationsMenuFormatNumberOptionsPlPl._(_root);
	@override String get text => 'Tekst';
	@override late final _TranslationsMenuFormatTextOptionsPlPl text_options = _TranslationsMenuFormatTextOptionsPlPl._(_root);
	@override String get alignment => 'Wyrównanie';
	@override late final _TranslationsMenuFormatAlignmentOptionsPlPl alignment_options = _TranslationsMenuFormatAlignmentOptionsPlPl._(_root);
	@override String get wrapping => 'Zawijanie';
	@override late final _TranslationsMenuFormatWrappingOptionsPlPl wrapping_options = _TranslationsMenuFormatWrappingOptionsPlPl._(_root);
	@override String get rotation => 'Obrót';
	@override late final _TranslationsMenuFormatRotationOptionsPlPl rotation_options = _TranslationsMenuFormatRotationOptionsPlPl._(_root);
	@override String get font_size => 'Rozmiar czcionki';
	@override String get merge_cells => 'Scal komórki';
	@override late final _TranslationsMenuFormatMergeCellsOptionsPlPl merge_cells_options = _TranslationsMenuFormatMergeCellsOptionsPlPl._(_root);
	@override String get convert_to_table => 'Przekonwertuj na tabelę';
	@override String get conditional_formatting => 'Formatowanie warunkowe';
	@override String get alternating_colors => 'Naprzemienne kolory';
	@override String get clear_formatting => 'Wyczyść formatowanie';
}

// Path: menu.data
class _TranslationsMenuDataPlPl implements TranslationsMenuDataEn {
	_TranslationsMenuDataPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get name => 'Dane';
	@override String get sort_sheet => 'Sortuj arkusz';
	@override late final _TranslationsMenuDataSortSheetOptionsPlPl sort_sheet_options = _TranslationsMenuDataSortSheetOptionsPlPl._(_root);
	@override String get sort_range => 'Sortuj zakres';
	@override late final _TranslationsMenuDataSortRangeOptionsPlPl sort_range_options = _TranslationsMenuDataSortRangeOptionsPlPl._(_root);
	@override String get create_filter => 'Utwórz filtr';
	@override String get create_group_by_view => 'Utwórz widok "grupuj według"';
	@override String get create_filter_view => 'Utwórz widok filtra';
	@override String get add_slicer => 'Dodaj fragmentator';
	@override String get protect_sheet => 'Chroń arkusze i zakresy';
	@override String get named_ranges => 'Zakresy nazwane';
	@override String get named_functions => 'Funkcje nazwane';
	@override String get randomize_range => 'Losuj zakres';
	@override String get column_stats => 'Statystyki dotyczące kolumn';
	@override String get data_validation => 'Sprawdzanie poprawności danych';
	@override String get data_cleanup => 'Czyszczenie danych';
	@override late final _TranslationsMenuDataDataCleanupOptionsPlPl data_cleanup_options = _TranslationsMenuDataDataCleanupOptionsPlPl._(_root);
	@override String get split_to_columns => 'Podziel tekst na kolumny';
	@override String get data_extraction => 'Wyodrębnianie danych';
}

// Path: menu.tools
class _TranslationsMenuToolsPlPl implements TranslationsMenuToolsEn {
	_TranslationsMenuToolsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get name => 'Narzędzia';
	@override String get create_new_form => 'Utwórz nowy formularz';
	@override String get spelling => 'Pisownia';
	@override late final _TranslationsMenuToolsSpellingOptionsPlPl spelling_options = _TranslationsMenuToolsSpellingOptionsPlPl._(_root);
	@override String get suggestion_controls => 'Opcje sugestii';
	@override late final _TranslationsMenuToolsSuggestionControlsOptionsPlPl suggestion_controls_options = _TranslationsMenuToolsSuggestionControlsOptionsPlPl._(_root);
	@override String get notifications_settings => 'Ustawienia powiadomień';
	@override late final _TranslationsMenuToolsNotificationsSettingsOptionsPlPl notifications_settings_options = _TranslationsMenuToolsNotificationsSettingsOptionsPlPl._(_root);
	@override String get accessibility => 'Ułatwienia dostępu';
}

// Path: menu.help
class _TranslationsMenuHelpPlPl implements TranslationsMenuHelpEn {
	_TranslationsMenuHelpPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get name => 'Pomoc';
	@override String get search => 'Przeszukaj menu';
	@override String get sheets_help => 'Pomoc do Arkuszy';
	@override String get training => 'Szkolenia';
	@override String get updates => 'Aktualizacje';
	@override String get help_sheets_improve => 'Pomóż w ulepszaniu Arkuszy';
	@override String get privacy_policy => 'Polityka prywatności';
	@override String get terms_of_service => 'Warunki korzystania z usługi';
	@override String get function_list => 'Lista funkcji';
	@override String get keyboard_shortcuts => 'Skróty klawiszowe';
}

// Path: toolbar.menus
class _TranslationsToolbarMenusPlPl implements TranslationsToolbarMenusEn {
	_TranslationsToolbarMenusPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Menu';
	@override String get tooltip => 'Szukaj w menu (Alt+/)';
}

// Path: toolbar.undo
class _TranslationsToolbarUndoPlPl implements TranslationsToolbarUndoEn {
	_TranslationsToolbarUndoPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Cofnij (Ctrl+Z)';
}

// Path: toolbar.redo
class _TranslationsToolbarRedoPlPl implements TranslationsToolbarRedoEn {
	_TranslationsToolbarRedoPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Ponów (Ctrl+Y)';
}

// Path: toolbar.print
class _TranslationsToolbarPrintPlPl implements TranslationsToolbarPrintEn {
	_TranslationsToolbarPrintPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Drukuj (Ctrl+P)';
}

// Path: toolbar.paint_format
class _TranslationsToolbarPaintFormatPlPl implements TranslationsToolbarPaintFormatEn {
	_TranslationsToolbarPaintFormatPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Kopiuj formatowanie';
}

// Path: toolbar.zoom
class _TranslationsToolbarZoomPlPl implements TranslationsToolbarZoomEn {
	_TranslationsToolbarZoomPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Powiększ';
}

// Path: toolbar.currency
class _TranslationsToolbarCurrencyPlPl implements TranslationsToolbarCurrencyEn {
	_TranslationsToolbarCurrencyPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Sformatuj jako walutę';
}

// Path: toolbar.percent
class _TranslationsToolbarPercentPlPl implements TranslationsToolbarPercentEn {
	_TranslationsToolbarPercentPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Sformatuj jako wartość procentową';
}

// Path: toolbar.decrease_decimal
class _TranslationsToolbarDecreaseDecimalPlPl implements TranslationsToolbarDecreaseDecimalEn {
	_TranslationsToolbarDecreaseDecimalPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Zmniejsz liczbę miejsc po przecinku';
}

// Path: toolbar.increase_decimal
class _TranslationsToolbarIncreaseDecimalPlPl implements TranslationsToolbarIncreaseDecimalEn {
	_TranslationsToolbarIncreaseDecimalPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Zwiększ liczbę miejsc po przecinku';
}

// Path: toolbar.more_formats
class _TranslationsToolbarMoreFormatsPlPl implements TranslationsToolbarMoreFormatsEn {
	_TranslationsToolbarMoreFormatsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Więcej formatów';
}

// Path: toolbar.font
class _TranslationsToolbarFontPlPl implements TranslationsToolbarFontEn {
	_TranslationsToolbarFontPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Czcionka';
	@override String get options => 'Więcej czcionek';
}

// Path: toolbar.decrease_font_size
class _TranslationsToolbarDecreaseFontSizePlPl implements TranslationsToolbarDecreaseFontSizeEn {
	_TranslationsToolbarDecreaseFontSizePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Zmniejsz rozmiar czcionki (Ctrl+Shift+,)';
}

// Path: toolbar.font_size
class _TranslationsToolbarFontSizePlPl implements TranslationsToolbarFontSizeEn {
	_TranslationsToolbarFontSizePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Rozmiar czcionki';
}

// Path: toolbar.increase_font_size
class _TranslationsToolbarIncreaseFontSizePlPl implements TranslationsToolbarIncreaseFontSizeEn {
	_TranslationsToolbarIncreaseFontSizePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Zwiększ rozmiar czcionki (Ctrl+Shift+.)';
}

// Path: toolbar.bold
class _TranslationsToolbarBoldPlPl implements TranslationsToolbarBoldEn {
	_TranslationsToolbarBoldPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Pogrubienie (Ctrl+B)';
}

// Path: toolbar.italic
class _TranslationsToolbarItalicPlPl implements TranslationsToolbarItalicEn {
	_TranslationsToolbarItalicPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Kursywa (Ctrl+I)';
}

// Path: toolbar.strikethrough
class _TranslationsToolbarStrikethroughPlPl implements TranslationsToolbarStrikethroughEn {
	_TranslationsToolbarStrikethroughPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Przekreślenie (Alt+Shift+5)';
}

// Path: toolbar.text_color
class _TranslationsToolbarTextColorPlPl implements TranslationsToolbarTextColorEn {
	_TranslationsToolbarTextColorPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Kolor tekstu';
}

// Path: toolbar.fill_color
class _TranslationsToolbarFillColorPlPl implements TranslationsToolbarFillColorEn {
	_TranslationsToolbarFillColorPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Kolor wypełnienia';
	@override String get alternating_colors => 'Naprzemienne kolory';
}

// Path: toolbar.borders
class _TranslationsToolbarBordersPlPl implements TranslationsToolbarBordersEn {
	_TranslationsToolbarBordersPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Obramowania';
	@override late final _TranslationsToolbarBordersOptionsPlPl options = _TranslationsToolbarBordersOptionsPlPl._(_root);
}

// Path: toolbar.merge
class _TranslationsToolbarMergePlPl implements TranslationsToolbarMergeEn {
	_TranslationsToolbarMergePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Scal komórki';
	@override late final _TranslationsToolbarMergeOptionsPlPl options = _TranslationsToolbarMergeOptionsPlPl._(_root);
}

// Path: toolbar.merge_types
class _TranslationsToolbarMergeTypesPlPl implements TranslationsToolbarMergeTypesEn {
	_TranslationsToolbarMergeTypesPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Wybierz typ scalania';
}

// Path: toolbar.align
class _TranslationsToolbarAlignPlPl implements TranslationsToolbarAlignEn {
	_TranslationsToolbarAlignPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Wyrównanie w poziomie';
	@override late final _TranslationsToolbarAlignOptionsPlPl options = _TranslationsToolbarAlignOptionsPlPl._(_root);
}

// Path: toolbar.valign
class _TranslationsToolbarValignPlPl implements TranslationsToolbarValignEn {
	_TranslationsToolbarValignPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Wyrównanie w pionie';
	@override late final _TranslationsToolbarValignOptionsPlPl options = _TranslationsToolbarValignOptionsPlPl._(_root);
}

// Path: toolbar.wrap
class _TranslationsToolbarWrapPlPl implements TranslationsToolbarWrapEn {
	_TranslationsToolbarWrapPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Zawijanie tekstu';
	@override late final _TranslationsToolbarWrapOptionsPlPl options = _TranslationsToolbarWrapOptionsPlPl._(_root);
}

// Path: toolbar.rotate
class _TranslationsToolbarRotatePlPl implements TranslationsToolbarRotateEn {
	_TranslationsToolbarRotatePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Obrót tekstu';
	@override late final _TranslationsToolbarRotateOptionsPlPl options = _TranslationsToolbarRotateOptionsPlPl._(_root);
}

// Path: toolbar.link
class _TranslationsToolbarLinkPlPl implements TranslationsToolbarLinkEn {
	_TranslationsToolbarLinkPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Wstaw link (Ctrl+K)';
}

// Path: toolbar.comment
class _TranslationsToolbarCommentPlPl implements TranslationsToolbarCommentEn {
	_TranslationsToolbarCommentPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Wstaw komentarz (Ctrl+Alt+M)';
}

// Path: toolbar.chart
class _TranslationsToolbarChartPlPl implements TranslationsToolbarChartEn {
	_TranslationsToolbarChartPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Wstaw wykres';
}

// Path: toolbar.filter
class _TranslationsToolbarFilterPlPl implements TranslationsToolbarFilterEn {
	_TranslationsToolbarFilterPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Utwórz filtr';
}

// Path: toolbar.filter_views
class _TranslationsToolbarFilterViewsPlPl implements TranslationsToolbarFilterViewsEn {
	_TranslationsToolbarFilterViewsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Widoki filtrów';
	@override late final _TranslationsToolbarFilterViewsOptionsPlPl options = _TranslationsToolbarFilterViewsOptionsPlPl._(_root);
}

// Path: toolbar.functions
class _TranslationsToolbarFunctionsPlPl implements TranslationsToolbarFunctionsEn {
	_TranslationsToolbarFunctionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Funkcje';
}

// Path: cell_menu.paste_special_options
class _TranslationsCellMenuPasteSpecialOptionsPlPl implements TranslationsCellMenuPasteSpecialOptionsEn {
	_TranslationsCellMenuPasteSpecialOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get values => 'Tylko wartości';
	@override String get formatting => 'Tylko formatowanie';
	@override String get formulas => 'Tylko formuła';
	@override String get conditional_formatting => 'Tylko formatowanie warunkowe';
	@override String get data_validation => 'Tylko sprawdzanie poprawności danych';
	@override String get transposed => 'Z transpozycją';
	@override String get column_width => 'Tylko szerokość kolumny';
	@override String get all_without_borders => 'Wszystko oprócz obramowania';
}

// Path: cell_menu.insert_cells_options
class _TranslationsCellMenuInsertCellsOptionsPlPl implements TranslationsCellMenuInsertCellsOptionsEn {
	_TranslationsCellMenuInsertCellsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get cells_and_shift_right => 'Wstaw komórki z przesunięciem w prawo';
	@override String get cells_and_shift_down => 'Wstaw komórki z przesunięciem w dół';
}

// Path: cell_menu.delete_cells_options
class _TranslationsCellMenuDeleteCellsOptionsPlPl implements TranslationsCellMenuDeleteCellsOptionsEn {
	_TranslationsCellMenuDeleteCellsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get cells_and_shift_left => 'Usuń komórki z przesunięciem w prawo';
	@override String get cells_and_shift_up => 'Usuń komórki z przesunięciem w dół';
}

// Path: cell_menu.smart_chips_options
class _TranslationsCellMenuSmartChipsOptionsPlPl implements TranslationsCellMenuSmartChipsOptionsEn {
	_TranslationsCellMenuSmartChipsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get people => 'Osoby';
	@override String get file => 'Plik';
	@override String get calendar => 'Wydarzenia w kalendarzu';
	@override String get place => 'Miejsce';
	@override String get finance => 'Finanse';
	@override String get rating => 'Ocena';
}

// Path: cell_menu.more_options
class _TranslationsCellMenuMoreOptionsPlPl implements TranslationsCellMenuMoreOptionsEn {
	_TranslationsCellMenuMoreOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get conditional_formatting => 'Formatowanie warunkowe';
	@override String get data_validation => 'Sprawdzanie poprawności danych';
	@override String get get_link_to_cell => 'Pobierz link do tej komórki';
	@override String get define_named_range => 'Zdefiniuj zakres nazwany';
	@override String get protect_range => 'Chroń zakres';
}

// Path: column_menu.paste_special_options
class _TranslationsColumnMenuPasteSpecialOptionsPlPl implements TranslationsColumnMenuPasteSpecialOptionsEn {
	_TranslationsColumnMenuPasteSpecialOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get values => 'Tylko wartości';
	@override String get formatting => 'Tylko formatowanie';
	@override String get formulas => 'Tylko formuła';
	@override String get conditional_formatting => 'Tylko formatowanie warunkowe';
	@override String get data_validation => 'Tylko sprawdzanie poprawności danych';
	@override String get transposed => 'Z transpozycją';
	@override String get column_width => 'Tylko szerokość kolumny';
	@override String get all_without_borders => 'Wszystko oprócz obramowania';
}

// Path: column_menu.smart_chips_options
class _TranslationsColumnMenuSmartChipsOptionsPlPl implements TranslationsColumnMenuSmartChipsOptionsEn {
	_TranslationsColumnMenuSmartChipsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get people => 'Osoby';
	@override String get file => 'Plik';
	@override String get calendar => 'Wydarzenia w kalendarzu';
	@override String get place => 'Miejsce';
	@override String get finance => 'Finanse';
	@override String get rating => 'Ocena';
}

// Path: column_menu.more_options
class _TranslationsColumnMenuMoreOptionsPlPl implements TranslationsColumnMenuMoreOptionsEn {
	_TranslationsColumnMenuMoreOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String freeze({required Object index}) => 'Zablokuj kolumny do ${index}';
	@override String get group => 'Grupuj kolumnę';
	@override String get get_link_to_range => 'Pobierz link do tego zakres';
	@override String get randomize_range => 'Losuj w zakresie';
	@override String get define_named_range => 'Zdefiniuj zakres nazwany';
	@override String get protect_range => 'Chroń zakres';
}

// Path: row_menu.paste_special_options
class _TranslationsRowMenuPasteSpecialOptionsPlPl implements TranslationsRowMenuPasteSpecialOptionsEn {
	_TranslationsRowMenuPasteSpecialOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get values => 'Tylko wartości';
	@override String get formatting => 'Tylko formatowanie';
	@override String get formulas => 'Tylko formuła';
	@override String get conditional_formatting => 'Tylko formatowanie warunkowe';
	@override String get data_validation => 'Tylko sprawdzanie poprawności danych';
	@override String get transposed => 'Z transpozycją';
	@override String get column_width => 'Tylko szerokość kolumny';
	@override String get all_without_borders => 'Wszystko oprócz obramowania';
}

// Path: row_menu.more_options
class _TranslationsRowMenuMoreOptionsPlPl implements TranslationsRowMenuMoreOptionsEn {
	_TranslationsRowMenuMoreOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String freeze({required Object index}) => 'Zablokuj dp wiersza ${index}';
	@override String get group => 'Grupuj wiersz';
	@override String get get_link_to_range => 'Pobierz link do tego zakresu';
	@override String get define_named_range => 'Zdefiniuj zakres nazwany';
	@override String get protect_range => 'Chroń zakres';
}

// Path: header.star
class _TranslationsHeaderStarPlPl implements TranslationsHeaderStarEn {
	_TranslationsHeaderStarPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Oznacz gwiazdką';
}

// Path: header.move
class _TranslationsHeaderMovePlPl implements TranslationsHeaderMoveEn {
	_TranslationsHeaderMovePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Przenieś';
}

// Path: header.status
class _TranslationsHeaderStatusPlPl implements TranslationsHeaderStatusEn {
	_TranslationsHeaderStatusPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Zobacz stan dokumentu';
}

// Path: header.history
class _TranslationsHeaderHistoryPlPl implements TranslationsHeaderHistoryEn {
	_TranslationsHeaderHistoryPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Pokaż historię zmian';
}

// Path: header.comments
class _TranslationsHeaderCommentsPlPl implements TranslationsHeaderCommentsEn {
	_TranslationsHeaderCommentsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Pokaż wszystkie komentarze';
}

// Path: header.call
class _TranslationsHeaderCallPlPl implements TranslationsHeaderCallEn {
	_TranslationsHeaderCallPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Dołącz do rozmowy tutaj lub zaprezentuj tę kartę podczas rozmowy';
}

// Path: header.share
class _TranslationsHeaderSharePlPl implements TranslationsHeaderShareEn {
	_TranslationsHeaderSharePlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Szybkie działania związane z udostępnianiem';
}

// Path: menu.file.new_options
class _TranslationsMenuFileNewOptionsPlPl implements TranslationsMenuFileNewOptionsEn {
	_TranslationsMenuFileNewOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get spreadsheet => 'Arkusz kalkulacyjny';
	@override String get template => 'Z galerii szablonów';
}

// Path: menu.file.share_options
class _TranslationsMenuFileShareOptionsPlPl implements TranslationsMenuFileShareOptionsEn {
	_TranslationsMenuFileShareOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get email => 'Share with others';
	@override String get web => 'Publish to web';
}

// Path: menu.file.email_options
class _TranslationsMenuFileEmailOptionsPlPl implements TranslationsMenuFileEmailOptionsEn {
	_TranslationsMenuFileEmailOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get file => 'Wyślij ten plik e-mailem';
	@override String get collaborators => 'Wyślij e-maila do współpracowników';
}

// Path: menu.file.download_options
class _TranslationsMenuFileDownloadOptionsPlPl implements TranslationsMenuFileDownloadOptionsEn {
	_TranslationsMenuFileDownloadOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get xlsx => 'Microsoft Excel (.xlsx)';
	@override String get ods => 'OpenDocument (.ods)';
	@override String get pdf => 'PDF (.pdf)';
	@override String get html => 'Strona internetowa (.html)';
	@override String get csv => 'Wartości rozdzielane przecinkami (.csv)';
	@override String get tsv => 'Wartości rozdzielane tabulatorami (.tsv)';
}

// Path: menu.file.version_history_options
class _TranslationsMenuFileVersionHistoryOptionsPlPl implements TranslationsMenuFileVersionHistoryOptionsEn {
	_TranslationsMenuFileVersionHistoryOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get name_current_version => 'Nazwij obecną wersję';
	@override String get see_version_history => 'Wyświetl historię zmian';
}

// Path: menu.edit.paste_special_options
class _TranslationsMenuEditPasteSpecialOptionsPlPl implements TranslationsMenuEditPasteSpecialOptionsEn {
	_TranslationsMenuEditPasteSpecialOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get values => 'Tylko wartości';
	@override String get formatting => 'Tylko formatowanie';
	@override String get formulas => 'Tylko formuła';
	@override String get conditional_formatting => 'Tylko formatowanie warunkowe';
	@override String get data_validation => 'Tylko sprawdzanie poprawności danych';
	@override String get transposed => 'Z transpozycją';
	@override String get column_width => 'Tylko szerokość kolumny';
	@override String get all_without_borders => 'Wszystko oprócz obramowania';
}

// Path: menu.edit.delete_options
class _TranslationsMenuEditDeleteOptionsPlPl implements TranslationsMenuEditDeleteOptionsEn {
	_TranslationsMenuEditDeleteOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get values => 'Wartości';
	@override String row({required Object index}) => 'Wiersz ${index}';
	@override String column({required Object index}) => 'Kolumna ${index}';
	@override String get cells_shift_up => 'Komórki z przesunięciem w górę';
	@override String get cells_shift_left => 'Komórki z przesunięciem w lewo';
	@override String get notes => 'Uwagi';
}

// Path: menu.view.show_options
class _TranslationsMenuViewShowOptionsPlPl implements TranslationsMenuViewShowOptionsEn {
	_TranslationsMenuViewShowOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get formula_bar => 'Pasek formuły';
	@override String get gridlines => 'Linie siatki';
	@override String get formulas => 'Formuły';
	@override String get protected_ranges => 'Zakresy chronione';
}

// Path: menu.view.freeze_options
class _TranslationsMenuViewFreezeOptionsPlPl implements TranslationsMenuViewFreezeOptionsEn {
	_TranslationsMenuViewFreezeOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get no_rows => 'Nie blokuj wierszy';
	@override String get k1Row => 'Wiersze: 1';
	@override String get k2Rows => 'Wiersze: 2';
	@override String up_to_current_row({required Object index}) => 'Do wiersza ${index}';
	@override String get no_columns => 'Nie blokuj kolumn';
	@override String get k1Column => 'Kolumny: 1';
	@override String get k2Columns => 'Kolumny: 2';
	@override String up_to_current_column({required Object index}) => 'Do kolumny ${index}';
}

// Path: menu.view.group_options
class _TranslationsMenuViewGroupOptionsPlPl implements TranslationsMenuViewGroupOptionsEn {
	_TranslationsMenuViewGroupOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get group => 'Grupuj';
	@override String get ungroup => 'Rozgrupuj';
}

// Path: menu.view.comments_options
class _TranslationsMenuViewCommentsOptionsPlPl implements TranslationsMenuViewCommentsOptionsEn {
	_TranslationsMenuViewCommentsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get hide_comments => 'Ukryj komentarze';
	@override String get minimize_comments => 'Minimalizuj komentarze';
	@override String get show_all => 'Pokaż wszystkie komentarze';
}

// Path: menu.insert.cells_options
class _TranslationsMenuInsertCellsOptionsPlPl implements TranslationsMenuInsertCellsOptionsEn {
	_TranslationsMenuInsertCellsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get cells_and_shift_right => 'Wstaw komórki z przesunięciem w lewo';
	@override String get cells_and_shift_down => 'Wstaw komórki z przesunięciem w dół';
}

// Path: menu.insert.rows_options
class _TranslationsMenuInsertRowsOptionsPlPl implements TranslationsMenuInsertRowsOptionsEn {
	_TranslationsMenuInsertRowsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get above => 'Wstaw wiersz powyżej';
	@override String get below => 'Wstaw wiersz poniżej';
}

// Path: menu.insert.columns_options
class _TranslationsMenuInsertColumnsOptionsPlPl implements TranslationsMenuInsertColumnsOptionsEn {
	_TranslationsMenuInsertColumnsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get left => 'Wstaw kolumnę po lewej';
	@override String get right => 'Wstaw kolumnę po prawej';
}

// Path: menu.insert.image_options
class _TranslationsMenuInsertImageOptionsPlPl implements TranslationsMenuInsertImageOptionsEn {
	_TranslationsMenuInsertImageOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get in_cell => 'Wstaw obraz w komórce';
	@override String get over_cells => 'Wstaw obraz nad komórkami';
}

// Path: menu.insert.smart_chips_options
class _TranslationsMenuInsertSmartChipsOptionsPlPl implements TranslationsMenuInsertSmartChipsOptionsEn {
	_TranslationsMenuInsertSmartChipsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get people => 'Osoby';
	@override String get file => 'Plik';
	@override String get calendar => 'Wydarzenia w kalendarzu';
	@override String get place => 'Miejsce';
	@override String get finance => 'Finanse';
	@override String get rating => 'Ocena';
}

// Path: menu.format.number_options
class _TranslationsMenuFormatNumberOptionsPlPl implements TranslationsMenuFormatNumberOptionsEn {
	_TranslationsMenuFormatNumberOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get automatic => 'Automatycznie';
	@override String get plain_text => 'Zwykły tekst';
	@override String get number => 'Liczba';
	@override String get percent => 'Procentowy';
	@override String get scientific => 'Naukowy';
	@override String get accounting => 'Księgowy';
	@override String get financial => 'Finansowy';
	@override String get currency => 'Waluta';
	@override String get currency_rounded => 'Waluta (w zaokrągleniu)';
	@override String get date => 'Data';
	@override String get time => 'Godzina';
	@override String get date_time => 'Data i godzina';
	@override String get duration => 'Czas trwania';
	@override String get custom_currency => 'Waluta niestandardowa';
	@override String get custom_date => 'Niestandardowa data i godzina';
	@override String get custom_number => 'Niestandardowy format liczbowy';
}

// Path: menu.format.text_options
class _TranslationsMenuFormatTextOptionsPlPl implements TranslationsMenuFormatTextOptionsEn {
	_TranslationsMenuFormatTextOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get bold => 'Pogrubienie';
	@override String get italic => 'Kursywa';
	@override String get underline => 'Podkreślenie';
	@override String get strikethrough => 'Przekreślenie';
}

// Path: menu.format.alignment_options
class _TranslationsMenuFormatAlignmentOptionsPlPl implements TranslationsMenuFormatAlignmentOptionsEn {
	_TranslationsMenuFormatAlignmentOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get left => 'Do lewej';
	@override String get center => 'Wyśrodkuj';
	@override String get right => 'Do prawej';
	@override String get top => 'Do góry';
	@override String get middle => 'Do środka';
	@override String get bottom => 'Do dołu';
}

// Path: menu.format.wrapping_options
class _TranslationsMenuFormatWrappingOptionsPlPl implements TranslationsMenuFormatWrappingOptionsEn {
	_TranslationsMenuFormatWrappingOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get overflow => 'Przenieś';
	@override String get wrap => 'Zawijaj';
	@override String get clip => 'Przytnij';
}

// Path: menu.format.rotation_options
class _TranslationsMenuFormatRotationOptionsPlPl implements TranslationsMenuFormatRotationOptionsEn {
	_TranslationsMenuFormatRotationOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get none => 'Brak';
	@override String get tilt_up => 'Przechyl do góry';
	@override String get tilt_down => 'Przechyl w dół';
	@override String get stack_vertically => 'Ustaw pionowo';
	@override String get rotate_up => 'Obróć w górę';
	@override String get rotate_down => 'Obróć w dół';
	@override String get custom_angle => 'Niestandardowy kąt';
}

// Path: menu.format.merge_cells_options
class _TranslationsMenuFormatMergeCellsOptionsPlPl implements TranslationsMenuFormatMergeCellsOptionsEn {
	_TranslationsMenuFormatMergeCellsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get merge_all => 'Scal wszystkie';
	@override String get merge_vertically => 'Scal w pionie';
	@override String get merge_horizontally => 'Scal w poziomie';
	@override String get unmerge => 'Rozdziel';
}

// Path: menu.data.sort_sheet_options
class _TranslationsMenuDataSortSheetOptionsPlPl implements TranslationsMenuDataSortSheetOptionsEn {
	_TranslationsMenuDataSortSheetOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String by_column_asc({required Object index}) => 'Sortuj arkusz według kolumny ${index} (Od A do Z)';
	@override String by_column_desc({required Object index}) => 'Sortuj arkusz według kolumny ${index} (Od Z do A)';
}

// Path: menu.data.sort_range_options
class _TranslationsMenuDataSortRangeOptionsPlPl implements TranslationsMenuDataSortRangeOptionsEn {
	_TranslationsMenuDataSortRangeOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String by_column_asc({required Object index}) => 'Sortuj zakres według kolumny ${index} (Od A do Z)';
	@override String by_column_desc({required Object index}) => 'Sortuj zakres według kolumny ${index} (Od Z do A)';
	@override String get advanced => 'Zaawansowane opcje sortowania zakresów';
}

// Path: menu.data.data_cleanup_options
class _TranslationsMenuDataDataCleanupOptionsPlPl implements TranslationsMenuDataDataCleanupOptionsEn {
	_TranslationsMenuDataDataCleanupOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get cleanup_suggestions => 'Sugestie dotyczące czyszczenia danych';
	@override String get remove_duplicates => 'Usuń duplikaty';
	@override String get trim_whitespace => 'Usuń spacje';
}

// Path: menu.tools.spelling_options
class _TranslationsMenuToolsSpellingOptionsPlPl implements TranslationsMenuToolsSpellingOptionsEn {
	_TranslationsMenuToolsSpellingOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get spell_check => 'Sprawdzanie pisowni';
	@override String get personal_dictionary => 'Słownik osobisty';
}

// Path: menu.tools.suggestion_controls_options
class _TranslationsMenuToolsSuggestionControlsOptionsPlPl implements TranslationsMenuToolsSuggestionControlsOptionsEn {
	_TranslationsMenuToolsSuggestionControlsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get enable_autocomplete => 'Włącz autouzupełnianie';
	@override String get enable_formula_suggestions => 'Włącz sugestie dotyczące formuł';
	@override String get enable_formula_corrections => 'Włącz poprawki formuły';
	@override String get enable_named_functions_suggestions => 'Włącz sugestie funkcji nazwanych';
	@override String get enable_pivot_table_suggestions => 'Włącz sugestie dotyczace tabel przestawnych';
	@override String get enable_dropdown_chip_suggestions => 'Włącz sugestie związane z elementami menu';
	@override String get enable_people_suggestions => 'Włącz sugestie związane z inteligentnymi elementami dotyczacymi osób';
	@override String get enable_table_suggestions => 'Włącz sugeste dotyczące tabel';
	@override String get enable_data_analysis_suggestions => 'Włącz sugestie dotyczące analizy danych';
}

// Path: menu.tools.notifications_settings_options
class _TranslationsMenuToolsNotificationsSettingsOptionsPlPl implements TranslationsMenuToolsNotificationsSettingsOptionsEn {
	_TranslationsMenuToolsNotificationsSettingsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get edit_notifications => 'Powiadomienia o edycji';
	@override String get comment_notifications => 'Powiadomienia o komentarzach';
}

// Path: toolbar.borders.options
class _TranslationsToolbarBordersOptionsPlPl implements TranslationsToolbarBordersOptionsEn {
	_TranslationsToolbarBordersOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get all => 'Wszystkie krawędzie';
	@override String get inner => 'Krawędzie wewnętrzne';
	@override String get horizontal => 'Krawędzie poziome';
	@override String get vertical => 'Krawędzie pionowe';
	@override String get outer => 'Krawędzie zewnętrzne';
	@override String get left => 'Lewa krawędź';
	@override String get top => 'Górna krawędź';
	@override String get right => 'Prawa krawędź';
	@override String get bottom => 'Dolna krawędź';
	@override String get clear => 'Wyczyść obramowanie';
	@override String get border_color => 'Kolor obramowania';
	@override String get border_style => 'Styl obramowania';
}

// Path: toolbar.merge.options
class _TranslationsToolbarMergeOptionsPlPl implements TranslationsToolbarMergeOptionsEn {
	_TranslationsToolbarMergeOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get merge_all => 'Scal wszystkie';
	@override String get merge_vertically => 'Scal w pionie';
	@override String get merge_horizontally => 'Scal w poziomie';
	@override String get unmerge => 'Rozdziel';
}

// Path: toolbar.align.options
class _TranslationsToolbarAlignOptionsPlPl implements TranslationsToolbarAlignOptionsEn {
	_TranslationsToolbarAlignOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get left => 'Do lewej';
	@override String get center => 'Wyśrodkuj';
	@override String get right => 'Do prawej';
}

// Path: toolbar.valign.options
class _TranslationsToolbarValignOptionsPlPl implements TranslationsToolbarValignOptionsEn {
	_TranslationsToolbarValignOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get top => 'Do góry';
	@override String get middle => 'Do środka';
	@override String get bottom => 'Do dołu';
}

// Path: toolbar.wrap.options
class _TranslationsToolbarWrapOptionsPlPl implements TranslationsToolbarWrapOptionsEn {
	_TranslationsToolbarWrapOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get overflow => 'Przenieś';
	@override String get wrap => 'Zawijaj';
	@override String get clip => 'Przytnij';
}

// Path: toolbar.rotate.options
class _TranslationsToolbarRotateOptionsPlPl implements TranslationsToolbarRotateOptionsEn {
	_TranslationsToolbarRotateOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get none => 'Brak';
	@override String get tilt_up => 'Przechyl do góry';
	@override String get tilt_down => 'Przechyl w dół';
	@override String get stack_vertically => 'Ustaw pionowo';
	@override String get rotate_up => 'Obróć w górę';
	@override String get rotate_down => 'Obróć w dół';
	@override String get custom_angle => 'Niestandardowy kąt';
}

// Path: toolbar.filter_views.options
class _TranslationsToolbarFilterViewsOptionsPlPl implements TranslationsToolbarFilterViewsOptionsEn {
	_TranslationsToolbarFilterViewsOptionsPlPl._(this._root);

	final TranslationsPlPl _root; // ignore: unused_field

	// Translations
	@override String get create_group_by_view => 'Utwórz widok "grupuj według"';
	@override String get create_filter_view => 'Utwórz widok filtra';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsPlPl {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'title': return 'Untitled spreadsheet';
			case 'share': return 'Udostępnij';
			case 'menu.font.kDefault': return ({required Object name}) => 'Domyślna (${name})';
			case 'menu.font.more_fonts': return 'Więcej czcionek';
			case 'menu.font.theme': return 'Motyw';
			case 'menu.font.recent': return 'Ostatnie';
			case 'menu.file.name': return 'Plik';
			case 'menu.file.kNew': return 'Nowy';
			case 'menu.file.new_options.spreadsheet': return 'Arkusz kalkulacyjny';
			case 'menu.file.new_options.template': return 'Z galerii szablonów';
			case 'menu.file.open': return 'Otwórz';
			case 'menu.file.import': return 'Importuj';
			case 'menu.file.make_copy': return 'Utwórz kopię';
			case 'menu.file.share': return 'Udostępnij';
			case 'menu.file.share_options.email': return 'Share with others';
			case 'menu.file.share_options.web': return 'Publish to web';
			case 'menu.file.email': return 'Wyślij e-mailem';
			case 'menu.file.email_options.file': return 'Wyślij ten plik e-mailem';
			case 'menu.file.email_options.collaborators': return 'Wyślij e-maila do współpracowników';
			case 'menu.file.download': return 'Pobierz';
			case 'menu.file.download_options.xlsx': return 'Microsoft Excel (.xlsx)';
			case 'menu.file.download_options.ods': return 'OpenDocument (.ods)';
			case 'menu.file.download_options.pdf': return 'PDF (.pdf)';
			case 'menu.file.download_options.html': return 'Strona internetowa (.html)';
			case 'menu.file.download_options.csv': return 'Wartości rozdzielane przecinkami (.csv)';
			case 'menu.file.download_options.tsv': return 'Wartości rozdzielane tabulatorami (.tsv)';
			case 'menu.file.rename': return 'Zmień nazwę';
			case 'menu.file.move': return 'Przenieś';
			case 'menu.file.add_to_drive': return 'Dodaj skrót do dysku';
			case 'menu.file.move_to_trash': return 'Przenieś do kosza';
			case 'menu.file.version_history': return 'Historia zmian';
			case 'menu.file.version_history_options.name_current_version': return 'Nazwij obecną wersję';
			case 'menu.file.version_history_options.see_version_history': return 'Wyświetl historię zmian';
			case 'menu.file.make_available_offline': return 'Udostępnij offline';
			case 'menu.file.details': return 'Szczegóły';
			case 'menu.file.security_limitations': return 'Ograniczenia zabezpieczeń';
			case 'menu.file.settings': return 'Ustawienia';
			case 'menu.file.language': return 'Język';
			case 'menu.file.print': return 'Drukuj';
			case 'menu.edit.name': return 'Edytuj';
			case 'menu.edit.undo': return 'Cofnij';
			case 'menu.edit.redo': return 'Ponów';
			case 'menu.edit.cut': return 'Wytnij';
			case 'menu.edit.copy': return 'Kopiuj';
			case 'menu.edit.paste': return 'Wklej';
			case 'menu.edit.paste_special': return 'Wklej specjalne';
			case 'menu.edit.paste_special_options.values': return 'Tylko wartości';
			case 'menu.edit.paste_special_options.formatting': return 'Tylko formatowanie';
			case 'menu.edit.paste_special_options.formulas': return 'Tylko formuła';
			case 'menu.edit.paste_special_options.conditional_formatting': return 'Tylko formatowanie warunkowe';
			case 'menu.edit.paste_special_options.data_validation': return 'Tylko sprawdzanie poprawności danych';
			case 'menu.edit.paste_special_options.transposed': return 'Z transpozycją';
			case 'menu.edit.paste_special_options.column_width': return 'Tylko szerokość kolumny';
			case 'menu.edit.paste_special_options.all_without_borders': return 'Wszystko oprócz obramowania';
			case 'menu.edit.move': return 'Przenieś';
			case 'menu.edit.delete': return 'Usuń';
			case 'menu.edit.delete_options.values': return 'Wartości';
			case 'menu.edit.delete_options.row': return ({required Object index}) => 'Wiersz ${index}';
			case 'menu.edit.delete_options.column': return ({required Object index}) => 'Kolumna ${index}';
			case 'menu.edit.delete_options.cells_shift_up': return 'Komórki z przesunięciem w górę';
			case 'menu.edit.delete_options.cells_shift_left': return 'Komórki z przesunięciem w lewo';
			case 'menu.edit.delete_options.notes': return 'Uwagi';
			case 'menu.edit.find_and_replace': return 'Znajdź i zamień';
			case 'menu.view.name': return 'Widok';
			case 'menu.view.show': return 'Pokaż';
			case 'menu.view.show_options.formula_bar': return 'Pasek formuły';
			case 'menu.view.show_options.gridlines': return 'Linie siatki';
			case 'menu.view.show_options.formulas': return 'Formuły';
			case 'menu.view.show_options.protected_ranges': return 'Zakresy chronione';
			case 'menu.view.freeze': return 'Zablokuj';
			case 'menu.view.freeze_options.no_rows': return 'Nie blokuj wierszy';
			case 'menu.view.freeze_options.k1Row': return 'Wiersze: 1';
			case 'menu.view.freeze_options.k2Rows': return 'Wiersze: 2';
			case 'menu.view.freeze_options.up_to_current_row': return ({required Object index}) => 'Do wiersza ${index}';
			case 'menu.view.freeze_options.no_columns': return 'Nie blokuj kolumn';
			case 'menu.view.freeze_options.k1Column': return 'Kolumny: 1';
			case 'menu.view.freeze_options.k2Columns': return 'Kolumny: 2';
			case 'menu.view.freeze_options.up_to_current_column': return ({required Object index}) => 'Do kolumny ${index}';
			case 'menu.view.group': return 'Grupuj';
			case 'menu.view.group_options.group': return 'Grupuj';
			case 'menu.view.group_options.ungroup': return 'Rozgrupuj';
			case 'menu.view.comments': return 'Komentarze';
			case 'menu.view.comments_options.hide_comments': return 'Ukryj komentarze';
			case 'menu.view.comments_options.minimize_comments': return 'Minimalizuj komentarze';
			case 'menu.view.comments_options.show_all': return 'Pokaż wszystkie komentarze';
			case 'menu.view.hidden_sheets': return 'Ukryte arkusze';
			case 'menu.view.zoom': return 'Zoom';
			case 'menu.view.full_screen': return 'Pełny ekran';
			case 'menu.insert.name': return 'Wstaw';
			case 'menu.insert.cells': return 'Komórki';
			case 'menu.insert.cells_options.cells_and_shift_right': return 'Wstaw komórki z przesunięciem w lewo';
			case 'menu.insert.cells_options.cells_and_shift_down': return 'Wstaw komórki z przesunięciem w dół';
			case 'menu.insert.rows': return 'Wiersze';
			case 'menu.insert.rows_options.above': return 'Wstaw wiersz powyżej';
			case 'menu.insert.rows_options.below': return 'Wstaw wiersz poniżej';
			case 'menu.insert.columns': return 'Kolumny';
			case 'menu.insert.columns_options.left': return 'Wstaw kolumnę po lewej';
			case 'menu.insert.columns_options.right': return 'Wstaw kolumnę po prawej';
			case 'menu.insert.sheet': return 'Arkusz';
			case 'menu.insert.tables': return 'Tabele';
			case 'menu.insert.chart': return 'Wykres';
			case 'menu.insert.pivot_table': return 'Tabela przestawna';
			case 'menu.insert.image': return 'Obraz';
			case 'menu.insert.image_options.in_cell': return 'Wstaw obraz w komórce';
			case 'menu.insert.image_options.over_cells': return 'Wstaw obraz nad komórkami';
			case 'menu.insert.drawing': return 'Rysunek';
			case 'menu.insert.function': return 'Funkcja';
			case 'menu.insert.link': return 'Link';
			case 'menu.insert.checkbox': return 'Pole wyboru';
			case 'menu.insert.dropdown': return 'Menu';
			case 'menu.insert.emoji': return 'Emotikony';
			case 'menu.insert.smart_chips': return 'Elementy inteligentne';
			case 'menu.insert.smart_chips_options.people': return 'Osoby';
			case 'menu.insert.smart_chips_options.file': return 'Plik';
			case 'menu.insert.smart_chips_options.calendar': return 'Wydarzenia w kalendarzu';
			case 'menu.insert.smart_chips_options.place': return 'Miejsce';
			case 'menu.insert.smart_chips_options.finance': return 'Finanse';
			case 'menu.insert.smart_chips_options.rating': return 'Ocena';
			case 'menu.insert.comment': return 'Komentarz';
			case 'menu.insert.note': return 'Notatka';
			case 'menu.format.name': return 'Formatuj';
			case 'menu.format.theme': return 'Motyw';
			case 'menu.format.number': return 'Liczba';
			case 'menu.format.number_options.automatic': return 'Automatycznie';
			case 'menu.format.number_options.plain_text': return 'Zwykły tekst';
			case 'menu.format.number_options.number': return 'Liczba';
			case 'menu.format.number_options.percent': return 'Procentowy';
			case 'menu.format.number_options.scientific': return 'Naukowy';
			case 'menu.format.number_options.accounting': return 'Księgowy';
			case 'menu.format.number_options.financial': return 'Finansowy';
			case 'menu.format.number_options.currency': return 'Waluta';
			case 'menu.format.number_options.currency_rounded': return 'Waluta (w zaokrągleniu)';
			case 'menu.format.number_options.date': return 'Data';
			case 'menu.format.number_options.time': return 'Godzina';
			case 'menu.format.number_options.date_time': return 'Data i godzina';
			case 'menu.format.number_options.duration': return 'Czas trwania';
			case 'menu.format.number_options.custom_currency': return 'Waluta niestandardowa';
			case 'menu.format.number_options.custom_date': return 'Niestandardowa data i godzina';
			case 'menu.format.number_options.custom_number': return 'Niestandardowy format liczbowy';
			case 'menu.format.text': return 'Tekst';
			case 'menu.format.text_options.bold': return 'Pogrubienie';
			case 'menu.format.text_options.italic': return 'Kursywa';
			case 'menu.format.text_options.underline': return 'Podkreślenie';
			case 'menu.format.text_options.strikethrough': return 'Przekreślenie';
			case 'menu.format.alignment': return 'Wyrównanie';
			case 'menu.format.alignment_options.left': return 'Do lewej';
			case 'menu.format.alignment_options.center': return 'Wyśrodkuj';
			case 'menu.format.alignment_options.right': return 'Do prawej';
			case 'menu.format.alignment_options.top': return 'Do góry';
			case 'menu.format.alignment_options.middle': return 'Do środka';
			case 'menu.format.alignment_options.bottom': return 'Do dołu';
			case 'menu.format.wrapping': return 'Zawijanie';
			case 'menu.format.wrapping_options.overflow': return 'Przenieś';
			case 'menu.format.wrapping_options.wrap': return 'Zawijaj';
			case 'menu.format.wrapping_options.clip': return 'Przytnij';
			case 'menu.format.rotation': return 'Obrót';
			case 'menu.format.rotation_options.none': return 'Brak';
			case 'menu.format.rotation_options.tilt_up': return 'Przechyl do góry';
			case 'menu.format.rotation_options.tilt_down': return 'Przechyl w dół';
			case 'menu.format.rotation_options.stack_vertically': return 'Ustaw pionowo';
			case 'menu.format.rotation_options.rotate_up': return 'Obróć w górę';
			case 'menu.format.rotation_options.rotate_down': return 'Obróć w dół';
			case 'menu.format.rotation_options.custom_angle': return 'Niestandardowy kąt';
			case 'menu.format.font_size': return 'Rozmiar czcionki';
			case 'menu.format.merge_cells': return 'Scal komórki';
			case 'menu.format.merge_cells_options.merge_all': return 'Scal wszystkie';
			case 'menu.format.merge_cells_options.merge_vertically': return 'Scal w pionie';
			case 'menu.format.merge_cells_options.merge_horizontally': return 'Scal w poziomie';
			case 'menu.format.merge_cells_options.unmerge': return 'Rozdziel';
			case 'menu.format.convert_to_table': return 'Przekonwertuj na tabelę';
			case 'menu.format.conditional_formatting': return 'Formatowanie warunkowe';
			case 'menu.format.alternating_colors': return 'Naprzemienne kolory';
			case 'menu.format.clear_formatting': return 'Wyczyść formatowanie';
			case 'menu.data.name': return 'Dane';
			case 'menu.data.sort_sheet': return 'Sortuj arkusz';
			case 'menu.data.sort_sheet_options.by_column_asc': return ({required Object index}) => 'Sortuj arkusz według kolumny ${index} (Od A do Z)';
			case 'menu.data.sort_sheet_options.by_column_desc': return ({required Object index}) => 'Sortuj arkusz według kolumny ${index} (Od Z do A)';
			case 'menu.data.sort_range': return 'Sortuj zakres';
			case 'menu.data.sort_range_options.by_column_asc': return ({required Object index}) => 'Sortuj zakres według kolumny ${index} (Od A do Z)';
			case 'menu.data.sort_range_options.by_column_desc': return ({required Object index}) => 'Sortuj zakres według kolumny ${index} (Od Z do A)';
			case 'menu.data.sort_range_options.advanced': return 'Zaawansowane opcje sortowania zakresów';
			case 'menu.data.create_filter': return 'Utwórz filtr';
			case 'menu.data.create_group_by_view': return 'Utwórz widok "grupuj według"';
			case 'menu.data.create_filter_view': return 'Utwórz widok filtra';
			case 'menu.data.add_slicer': return 'Dodaj fragmentator';
			case 'menu.data.protect_sheet': return 'Chroń arkusze i zakresy';
			case 'menu.data.named_ranges': return 'Zakresy nazwane';
			case 'menu.data.named_functions': return 'Funkcje nazwane';
			case 'menu.data.randomize_range': return 'Losuj zakres';
			case 'menu.data.column_stats': return 'Statystyki dotyczące kolumn';
			case 'menu.data.data_validation': return 'Sprawdzanie poprawności danych';
			case 'menu.data.data_cleanup': return 'Czyszczenie danych';
			case 'menu.data.data_cleanup_options.cleanup_suggestions': return 'Sugestie dotyczące czyszczenia danych';
			case 'menu.data.data_cleanup_options.remove_duplicates': return 'Usuń duplikaty';
			case 'menu.data.data_cleanup_options.trim_whitespace': return 'Usuń spacje';
			case 'menu.data.split_to_columns': return 'Podziel tekst na kolumny';
			case 'menu.data.data_extraction': return 'Wyodrębnianie danych';
			case 'menu.tools.name': return 'Narzędzia';
			case 'menu.tools.create_new_form': return 'Utwórz nowy formularz';
			case 'menu.tools.spelling': return 'Pisownia';
			case 'menu.tools.spelling_options.spell_check': return 'Sprawdzanie pisowni';
			case 'menu.tools.spelling_options.personal_dictionary': return 'Słownik osobisty';
			case 'menu.tools.suggestion_controls': return 'Opcje sugestii';
			case 'menu.tools.suggestion_controls_options.enable_autocomplete': return 'Włącz autouzupełnianie';
			case 'menu.tools.suggestion_controls_options.enable_formula_suggestions': return 'Włącz sugestie dotyczące formuł';
			case 'menu.tools.suggestion_controls_options.enable_formula_corrections': return 'Włącz poprawki formuły';
			case 'menu.tools.suggestion_controls_options.enable_named_functions_suggestions': return 'Włącz sugestie funkcji nazwanych';
			case 'menu.tools.suggestion_controls_options.enable_pivot_table_suggestions': return 'Włącz sugestie dotyczace tabel przestawnych';
			case 'menu.tools.suggestion_controls_options.enable_dropdown_chip_suggestions': return 'Włącz sugestie związane z elementami menu';
			case 'menu.tools.suggestion_controls_options.enable_people_suggestions': return 'Włącz sugestie związane z inteligentnymi elementami dotyczacymi osób';
			case 'menu.tools.suggestion_controls_options.enable_table_suggestions': return 'Włącz sugeste dotyczące tabel';
			case 'menu.tools.suggestion_controls_options.enable_data_analysis_suggestions': return 'Włącz sugestie dotyczące analizy danych';
			case 'menu.tools.notifications_settings': return 'Ustawienia powiadomień';
			case 'menu.tools.notifications_settings_options.edit_notifications': return 'Powiadomienia o edycji';
			case 'menu.tools.notifications_settings_options.comment_notifications': return 'Powiadomienia o komentarzach';
			case 'menu.tools.accessibility': return 'Ułatwienia dostępu';
			case 'menu.help.name': return 'Pomoc';
			case 'menu.help.search': return 'Przeszukaj menu';
			case 'menu.help.sheets_help': return 'Pomoc do Arkuszy';
			case 'menu.help.training': return 'Szkolenia';
			case 'menu.help.updates': return 'Aktualizacje';
			case 'menu.help.help_sheets_improve': return 'Pomóż w ulepszaniu Arkuszy';
			case 'menu.help.privacy_policy': return 'Polityka prywatności';
			case 'menu.help.terms_of_service': return 'Warunki korzystania z usługi';
			case 'menu.help.function_list': return 'Lista funkcji';
			case 'menu.help.keyboard_shortcuts': return 'Skróty klawiszowe';
			case 'toolbar.menus.hint': return 'Menu';
			case 'toolbar.menus.tooltip': return 'Szukaj w menu (Alt+/)';
			case 'toolbar.undo.tooltip': return 'Cofnij (Ctrl+Z)';
			case 'toolbar.redo.tooltip': return 'Ponów (Ctrl+Y)';
			case 'toolbar.print.tooltip': return 'Drukuj (Ctrl+P)';
			case 'toolbar.paint_format.tooltip': return 'Kopiuj formatowanie';
			case 'toolbar.zoom.tooltip': return 'Powiększ';
			case 'toolbar.currency.tooltip': return 'Sformatuj jako walutę';
			case 'toolbar.percent.tooltip': return 'Sformatuj jako wartość procentową';
			case 'toolbar.decrease_decimal.tooltip': return 'Zmniejsz liczbę miejsc po przecinku';
			case 'toolbar.increase_decimal.tooltip': return 'Zwiększ liczbę miejsc po przecinku';
			case 'toolbar.more_formats.tooltip': return 'Więcej formatów';
			case 'toolbar.font.tooltip': return 'Czcionka';
			case 'toolbar.font.options': return 'Więcej czcionek';
			case 'toolbar.decrease_font_size.tooltip': return 'Zmniejsz rozmiar czcionki (Ctrl+Shift+,)';
			case 'toolbar.font_size.tooltip': return 'Rozmiar czcionki';
			case 'toolbar.increase_font_size.tooltip': return 'Zwiększ rozmiar czcionki (Ctrl+Shift+.)';
			case 'toolbar.bold.tooltip': return 'Pogrubienie (Ctrl+B)';
			case 'toolbar.italic.tooltip': return 'Kursywa (Ctrl+I)';
			case 'toolbar.strikethrough.tooltip': return 'Przekreślenie (Alt+Shift+5)';
			case 'toolbar.text_color.tooltip': return 'Kolor tekstu';
			case 'toolbar.fill_color.tooltip': return 'Kolor wypełnienia';
			case 'toolbar.fill_color.alternating_colors': return 'Naprzemienne kolory';
			case 'toolbar.borders.tooltip': return 'Obramowania';
			case 'toolbar.borders.options.all': return 'Wszystkie krawędzie';
			case 'toolbar.borders.options.inner': return 'Krawędzie wewnętrzne';
			case 'toolbar.borders.options.horizontal': return 'Krawędzie poziome';
			case 'toolbar.borders.options.vertical': return 'Krawędzie pionowe';
			case 'toolbar.borders.options.outer': return 'Krawędzie zewnętrzne';
			case 'toolbar.borders.options.left': return 'Lewa krawędź';
			case 'toolbar.borders.options.top': return 'Górna krawędź';
			case 'toolbar.borders.options.right': return 'Prawa krawędź';
			case 'toolbar.borders.options.bottom': return 'Dolna krawędź';
			case 'toolbar.borders.options.clear': return 'Wyczyść obramowanie';
			case 'toolbar.borders.options.border_color': return 'Kolor obramowania';
			case 'toolbar.borders.options.border_style': return 'Styl obramowania';
			case 'toolbar.merge.tooltip': return 'Scal komórki';
			case 'toolbar.merge.options.merge_all': return 'Scal wszystkie';
			case 'toolbar.merge.options.merge_vertically': return 'Scal w pionie';
			case 'toolbar.merge.options.merge_horizontally': return 'Scal w poziomie';
			case 'toolbar.merge.options.unmerge': return 'Rozdziel';
			case 'toolbar.merge_types.tooltip': return 'Wybierz typ scalania';
			case 'toolbar.align.tooltip': return 'Wyrównanie w poziomie';
			case 'toolbar.align.options.left': return 'Do lewej';
			case 'toolbar.align.options.center': return 'Wyśrodkuj';
			case 'toolbar.align.options.right': return 'Do prawej';
			case 'toolbar.valign.tooltip': return 'Wyrównanie w pionie';
			case 'toolbar.valign.options.top': return 'Do góry';
			case 'toolbar.valign.options.middle': return 'Do środka';
			case 'toolbar.valign.options.bottom': return 'Do dołu';
			case 'toolbar.wrap.tooltip': return 'Zawijanie tekstu';
			case 'toolbar.wrap.options.overflow': return 'Przenieś';
			case 'toolbar.wrap.options.wrap': return 'Zawijaj';
			case 'toolbar.wrap.options.clip': return 'Przytnij';
			case 'toolbar.rotate.tooltip': return 'Obrót tekstu';
			case 'toolbar.rotate.options.none': return 'Brak';
			case 'toolbar.rotate.options.tilt_up': return 'Przechyl do góry';
			case 'toolbar.rotate.options.tilt_down': return 'Przechyl w dół';
			case 'toolbar.rotate.options.stack_vertically': return 'Ustaw pionowo';
			case 'toolbar.rotate.options.rotate_up': return 'Obróć w górę';
			case 'toolbar.rotate.options.rotate_down': return 'Obróć w dół';
			case 'toolbar.rotate.options.custom_angle': return 'Niestandardowy kąt';
			case 'toolbar.link.tooltip': return 'Wstaw link (Ctrl+K)';
			case 'toolbar.comment.tooltip': return 'Wstaw komentarz (Ctrl+Alt+M)';
			case 'toolbar.chart.tooltip': return 'Wstaw wykres';
			case 'toolbar.filter.tooltip': return 'Utwórz filtr';
			case 'toolbar.filter_views.tooltip': return 'Widoki filtrów';
			case 'toolbar.filter_views.options.create_group_by_view': return 'Utwórz widok "grupuj według"';
			case 'toolbar.filter_views.options.create_filter_view': return 'Utwórz widok filtra';
			case 'toolbar.functions.tooltip': return 'Funkcje';
			case 'cell_menu.cut': return 'Wytnij';
			case 'cell_menu.copy': return 'Kopiuj';
			case 'cell_menu.paste': return 'Wklej';
			case 'cell_menu.paste_special': return 'Wklej specjalne';
			case 'cell_menu.paste_special_options.values': return 'Tylko wartości';
			case 'cell_menu.paste_special_options.formatting': return 'Tylko formatowanie';
			case 'cell_menu.paste_special_options.formulas': return 'Tylko formuła';
			case 'cell_menu.paste_special_options.conditional_formatting': return 'Tylko formatowanie warunkowe';
			case 'cell_menu.paste_special_options.data_validation': return 'Tylko sprawdzanie poprawności danych';
			case 'cell_menu.paste_special_options.transposed': return 'Z transpozycją';
			case 'cell_menu.paste_special_options.column_width': return 'Tylko szerokość kolumny';
			case 'cell_menu.paste_special_options.all_without_borders': return 'Wszystko oprócz obramowania';
			case 'cell_menu.insert_row_above': return 'Wstaw wiersz powyzej';
			case 'cell_menu.insert_column_left': return 'Wstaw kolumnę po lewej';
			case 'cell_menu.insert_cells': return 'Wstaw komórki';
			case 'cell_menu.insert_cells_options.cells_and_shift_right': return 'Wstaw komórki z przesunięciem w prawo';
			case 'cell_menu.insert_cells_options.cells_and_shift_down': return 'Wstaw komórki z przesunięciem w dół';
			case 'cell_menu.delete_row': return 'Usuń wiersz';
			case 'cell_menu.delete_column': return 'Usuń kolumnę';
			case 'cell_menu.delete_cells': return 'Usuń komórki';
			case 'cell_menu.delete_cells_options.cells_and_shift_left': return 'Usuń komórki z przesunięciem w prawo';
			case 'cell_menu.delete_cells_options.cells_and_shift_up': return 'Usuń komórki z przesunięciem w dół';
			case 'cell_menu.convert_to_table': return 'Przekonwertuj na tabelę';
			case 'cell_menu.create_filter': return 'Utwórz filtr';
			case 'cell_menu.filter_by_cell_value': return 'Filtruj według wartości w komórce';
			case 'cell_menu.show_edit_history': return 'Pokaż historię zmian';
			case 'cell_menu.insert_link': return 'Wstaw link';
			case 'cell_menu.comment': return 'Komentarz';
			case 'cell_menu.insert_note': return 'Wstaw notatkę';
			case 'cell_menu.tables': return 'Tabele';
			case 'cell_menu.dropdown': return 'Menu';
			case 'cell_menu.smart_chips': return 'Elementy inteligentne';
			case 'cell_menu.smart_chips_options.people': return 'Osoby';
			case 'cell_menu.smart_chips_options.file': return 'Plik';
			case 'cell_menu.smart_chips_options.calendar': return 'Wydarzenia w kalendarzu';
			case 'cell_menu.smart_chips_options.place': return 'Miejsce';
			case 'cell_menu.smart_chips_options.finance': return 'Finanse';
			case 'cell_menu.smart_chips_options.rating': return 'Ocena';
			case 'cell_menu.more': return 'Zobacz więcej czynności dotyczących komórki';
			case 'cell_menu.more_options.conditional_formatting': return 'Formatowanie warunkowe';
			case 'cell_menu.more_options.data_validation': return 'Sprawdzanie poprawności danych';
			case 'cell_menu.more_options.get_link_to_cell': return 'Pobierz link do tej komórki';
			case 'cell_menu.more_options.define_named_range': return 'Zdefiniuj zakres nazwany';
			case 'cell_menu.more_options.protect_range': return 'Chroń zakres';
			case 'column_menu.cut': return 'Wytnij';
			case 'column_menu.copy': return 'Kopiuj';
			case 'column_menu.paste': return 'Wklej';
			case 'column_menu.paste_special': return 'Wklej specjalne';
			case 'column_menu.paste_special_options.values': return 'Tylko wartości';
			case 'column_menu.paste_special_options.formatting': return 'Tylko formatowanie';
			case 'column_menu.paste_special_options.formulas': return 'Tylko formuła';
			case 'column_menu.paste_special_options.conditional_formatting': return 'Tylko formatowanie warunkowe';
			case 'column_menu.paste_special_options.data_validation': return 'Tylko sprawdzanie poprawności danych';
			case 'column_menu.paste_special_options.transposed': return 'Z transpozycją';
			case 'column_menu.paste_special_options.column_width': return 'Tylko szerokość kolumny';
			case 'column_menu.paste_special_options.all_without_borders': return 'Wszystko oprócz obramowania';
			case 'column_menu.insert_column_left': return 'Wstaw kolumnę po lewej';
			case 'column_menu.insert_column_right': return 'Wstaw kolumnę po prawej';
			case 'column_menu.delete_column': return 'Usuń kolumnę';
			case 'column_menu.clear_column': return 'Wyczyść kolumnę';
			case 'column_menu.hide_column': return 'Ukryj kolumnę';
			case 'column_menu.resize_column': return 'Zmień rozmiar kolumny';
			case 'column_menu.create_filter': return 'Utwórz filtr';
			case 'column_menu.sort_asc': return 'Sortuj arkusz Od A do Z';
			case 'column_menu.sort_desc': return 'Sortuj arkusz Od Z do A';
			case 'column_menu.conditional_formatting': return 'Formatowanie warunkowe';
			case 'column_menu.data_validation': return 'Sprawdzanie poprawności danych';
			case 'column_menu.column_stats': return 'Statystyki dotyczące kolumn';
			case 'column_menu.dropdown': return 'Menu';
			case 'column_menu.smart_chips': return 'Elementy inteligentne';
			case 'column_menu.smart_chips_options.people': return 'Osoby';
			case 'column_menu.smart_chips_options.file': return 'Plik';
			case 'column_menu.smart_chips_options.calendar': return 'Wydarzenia w kalendarzu';
			case 'column_menu.smart_chips_options.place': return 'Miejsce';
			case 'column_menu.smart_chips_options.finance': return 'Finanse';
			case 'column_menu.smart_chips_options.rating': return 'Ocena';
			case 'column_menu.more': return 'Zobacz więcej czynności dotyczących kolumny';
			case 'column_menu.more_options.freeze': return ({required Object index}) => 'Zablokuj kolumny do ${index}';
			case 'column_menu.more_options.group': return 'Grupuj kolumnę';
			case 'column_menu.more_options.get_link_to_range': return 'Pobierz link do tego zakres';
			case 'column_menu.more_options.randomize_range': return 'Losuj w zakresie';
			case 'column_menu.more_options.define_named_range': return 'Zdefiniuj zakres nazwany';
			case 'column_menu.more_options.protect_range': return 'Chroń zakres';
			case 'row_menu.cut': return 'Wytnij';
			case 'row_menu.copy': return 'Kopiuj';
			case 'row_menu.paste': return 'Wklej';
			case 'row_menu.paste_special': return 'Wklej specjalne';
			case 'row_menu.paste_special_options.values': return 'Tylko wartości';
			case 'row_menu.paste_special_options.formatting': return 'Tylko formatowanie';
			case 'row_menu.paste_special_options.formulas': return 'Tylko formuła';
			case 'row_menu.paste_special_options.conditional_formatting': return 'Tylko formatowanie warunkowe';
			case 'row_menu.paste_special_options.data_validation': return 'Tylko sprawdzanie poprawności danych';
			case 'row_menu.paste_special_options.transposed': return 'Z transpozycją';
			case 'row_menu.paste_special_options.column_width': return 'Tylko szerokość kolumny';
			case 'row_menu.paste_special_options.all_without_borders': return 'Wszystko oprócz obramowania';
			case 'row_menu.insert_row_above': return 'Wstaw wiersz powyżej';
			case 'row_menu.insert_row_below': return 'Wstaw wiersz poniżej';
			case 'row_menu.delete_row': return 'Usuń wiersz';
			case 'row_menu.clear_row': return 'Wyczyść wiersz';
			case 'row_menu.hide_row': return 'Ukryj wiersz';
			case 'row_menu.resize_row': return 'Zmień rozmiar wiersza';
			case 'row_menu.create_filter': return 'Utwórz filtr';
			case 'row_menu.conditional_formatting': return 'Formatowanie warunkowe';
			case 'row_menu.data_validation': return 'Sprawdzanie poprawności danych';
			case 'row_menu.more': return 'Zobacz więcej czynności dotyczących wiersza';
			case 'row_menu.more_options.freeze': return ({required Object index}) => 'Zablokuj dp wiersza ${index}';
			case 'row_menu.more_options.group': return 'Grupuj wiersz';
			case 'row_menu.more_options.get_link_to_range': return 'Pobierz link do tego zakresu';
			case 'row_menu.more_options.define_named_range': return 'Zdefiniuj zakres nazwany';
			case 'row_menu.more_options.protect_range': return 'Chroń zakres';
			case 'header.star.tooltip': return 'Oznacz gwiazdką';
			case 'header.move.tooltip': return 'Przenieś';
			case 'header.status.tooltip': return 'Zobacz stan dokumentu';
			case 'header.history.tooltip': return 'Pokaż historię zmian';
			case 'header.comments.tooltip': return 'Pokaż wszystkie komentarze';
			case 'header.call.tooltip': return 'Dołącz do rozmowy tutaj lub zaprezentuj tę kartę podczas rozmowy';
			case 'header.share.tooltip': return 'Szybkie działania związane z udostępnianiem';
			case 'bottom_bar.tab_name': return ({required Object index}) => 'Arkusz${index}';
			case 'bottom_bar.add_sheet': return 'Dodaj arkusz';
			case 'bottom_bar.all_sheets': return 'Wszystkie arkusze';
			case 'bottom_bar.show_side_panel': return 'Pokaż panel boczny';
			default: return null;
		}
	}
}

