import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_icon_button.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_button_item_mixin.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';
import 'package:sheets/widgets/popup_button.dart';

class IconOptionValue<T> with EquatableMixin {
  const IconOptionValue({
    required this.value,
    required this.icon,
  });

  final T value;
  final AssetIconData icon;

  @override
  List<Object?> get props => <Object?>[value, icon];
}

class MaterialToolbarOptionsButton<T> extends StatefulWidget with MaterialToolbarItemMixin, MaterialToolbarButtonMixin {
  const MaterialToolbarOptionsButton({
    required this.icon,
    required this.onSelected,
    required this.options,
    required this.selectedValue,
    this.width = 39,
    this.height = 30,
    this.margin = const EdgeInsets.symmetric(horizontal: 1),
    this.active = false,
    super.key,
  });

  @override
  final bool active;
  @override
  final double width;
  @override
  final double height;
  @override
  final EdgeInsets margin;
  final T selectedValue;
  final AssetIconData icon;
  final ValueChanged<T> onSelected;
  final List<IconOptionValue<T>> options;

  @override
  State<StatefulWidget> createState() => _MaterialToolbarOptionsButtonState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AssetIconData>('icon', icon));
    properties.add(ObjectFlagProperty<ValueChanged<T>>.has('onSelected', onSelected));
    properties.add(IterableProperty<IconOptionValue<T>>('options', options));
    properties.add(DiagnosticsProperty<T>('selectedValue', selectedValue));
  }
}

class _MaterialToolbarOptionsButtonState<T> extends State<MaterialToolbarOptionsButton<T>> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return PopupButton(
      button: MaterialToolbarIconButton.withDropdown(
        icon: widget.icon,
        pressed: _pressed,
        onTap: () {},
      ),
      onToggle: (bool isOpen) {
        setState(() {
          _pressed = isOpen;
        });
      },
      popupBuilder: (BuildContext context) {
        return _OptionsPopup<T>(
          selectedValue: widget.selectedValue,
          options: widget.options,
          onSelected: widget.onSelected,
        );
      },
    );
  }
}

class _OptionsPopup<T> extends StatefulWidget {
  const _OptionsPopup({
    required this.selectedValue,
    required this.options,
    required this.onSelected,
    super.key,
  });

  final T selectedValue;
  final List<IconOptionValue<T>> options;
  final ValueChanged<T> onSelected;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('selectedValue', selectedValue));
    properties.add(IterableProperty<IconOptionValue<T>>('options', options));
    properties.add(ObjectFlagProperty<ValueChanged<T>>.has('onSelected', onSelected));
  }

  @override
  State<StatefulWidget> createState() => _OptionsPopupState<T>();
}

class _OptionsPopupState<T> extends State<_OptionsPopup<T>> {
  late T _selectedValue = widget.selectedValue;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(3),
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xffF1F4F9),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.options.map((IconOptionValue<T> option) {
            return _OptionsPopupButton<T>(
              icon: option.icon,
              onTap: () {
                setState(() {
                  _selectedValue = option.value;
                });
                widget.onSelected(option.value);
              },
              active: option.value == _selectedValue,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _OptionsPopupButton<T> extends StatelessWidget with MaterialToolbarButtonMixin {
  const _OptionsPopupButton({
    required this.icon,
    required this.onTap,
    this.active = false,
    this.width = 28,
    this.height = 28,
    super.key,
  });

  @override
  final bool active;
  final double width;
  final double height;
  final AssetIconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onTap,
      childBuilder: (Set<WidgetState> states) {
        Color? backgroundColor = getBackgroundColor(states);
        Color? foregroundColor = getForegroundColor(states);

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: AssetIcon(icon, size: 19, color: foregroundColor),
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<AssetIconData>('icon', icon));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}
