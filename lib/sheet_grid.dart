import 'package:flutter/material.dart';
import 'package:sheets/controller/program_config.dart';
import 'package:sheets/multi_listenable_builder.dart';
import 'package:sheets/painters/column_headers_painter.dart';
import 'package:sheets/painters/row_headers_painter.dart';
import 'package:sheets/painters/selection_painter.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/painters/sheet_painter.dart';
import 'package:sheets/sheet_constants.dart';

class SheetGrid extends StatelessWidget {
  final SheetController sheetController;
  final MouseListener mouseListener;

  const SheetGrid({
    required this.sheetController,
    required this.mouseListener,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          sheetController.resize(Size(constraints.maxWidth, constraints.maxHeight));

          return Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(top: columnHeadersHeight, left: rowHeadersWidth),
                  child: RepaintBoundary(
                    child: MultiListenableBuilder(
                      listenables: [
                        sheetController.paintConfig,
                      ],
                      builder: (BuildContext context) {
                        return CustomPaint(
                          painter: SheetPainter(sheetController: sheetController),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(left: rowHeadersWidth),
                  child: RepaintBoundary(
                    child: MultiListenableBuilder(
                      listenables: [
                        sheetController.selectionPainterNotifier,
                        sheetController.paintConfig,
                      ],
                      builder: (BuildContext context) {
                        return CustomPaint(
                          isComplex: true,
                          painter: ColumnHeadersPainter(sheetController: sheetController),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(top: columnHeadersHeight),
                  child: RepaintBoundary(
                    child: MultiListenableBuilder(
                      listenables: [
                        sheetController.selectionPainterNotifier,
                        sheetController.paintConfig,
                      ],
                      builder: (BuildContext context) {
                        return CustomPaint(
                          isComplex: true,
                          painter: RowHeadersPainter(sheetController: sheetController),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(left: rowHeadersWidth),
                  child: RepaintBoundary(
                    child: MultiListenableBuilder(
                      listenables: [
                        sheetController.selectionPainterNotifier,
                        sheetController.paintConfig,
                      ],
                      builder: (BuildContext context) {
                        return Stack(
                          children: sheetController.paintConfig.visibleColumns.map((ColumnConfig columnConfig) {
                            return VerticalResizeDivider(columnConfig: columnConfig, mouseListener: mouseListener);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(top: columnHeadersHeight),
                  child: RepaintBoundary(
                    child: MultiListenableBuilder(
                      listenables: [
                        sheetController.selectionPainterNotifier,
                        sheetController.paintConfig,
                      ],
                      builder: (BuildContext context) {
                        return Stack(
                          children: sheetController.paintConfig.visibleRows.map((RowConfig rowConfig) {
                            return HorizontalResizeDivider(rowConfig: rowConfig, mouseListener: mouseListener);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: rowHeadersWidth,
                  height: columnHeadersHeight,
                  decoration: const BoxDecoration(
                    color: Color(0xfff8f9fa),
                    border: Border(
                      right: BorderSide(color: Color(0xffc7c7c7), width: 4),
                      bottom: BorderSide(color: Color(0xffc7c7c7), width: 4),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(top: columnHeadersHeight, left: rowHeadersWidth),
                  child: RepaintBoundary(
                    child: MultiListenableBuilder(
                      listenables: [
                        sheetController.selectionPainterNotifier,
                        sheetController.paintConfig,
                      ],
                      builder: (BuildContext context) {
                        return CustomPaint(
                          isComplex: true,
                          painter: SelectionPainter(sheetController: sheetController),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(top: columnHeadersHeight, left: rowHeadersWidth),
                  child: ValueListenableBuilder<CellConfig?>(
                      valueListenable: sheetController.editNotifier,
                      builder: (BuildContext context, CellConfig? cellConfig, _) {
                        return Stack(
                          children: [
                            if (cellConfig != null)
                              Positioned(
                                left: cellConfig.rect.left,
                                top: cellConfig.rect.top,
                                child: Container(
                                  height: cellConfig.rect.height,
                                  constraints: BoxConstraints(minWidth: cellConfig.rect.width),
                                  child: SheetTextField(cellConfig: cellConfig),
                                ),
                              )
                          ],
                        );
                      }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HorizontalResizeDivider extends StatefulWidget {
  final RowConfig rowConfig;
  final MouseListener mouseListener;

  const HorizontalResizeDivider({
    required this.rowConfig,
    required this.mouseListener,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HorizontalResizeDividerState();
}

class _HorizontalResizeDividerState extends State<HorizontalResizeDivider> {
  bool hoverVisible = false;
  bool hovered = false;
  double delta = 0;
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.rowConfig.rect.bottom - 5.5 + delta,
      left: widget.rowConfig.rect.left,
      child: Stack(
        children: [
          if (hoverVisible) ...<Widget>[
            SizedBox(
              width: widget.rowConfig.rect.width,
              height: 11,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 3,
                    width: 16,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 3,
                    width: 16,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            if (dragging) Container(height: 5, width: double.maxFinite, color: const Color(0xffc4c7c5), margin: const EdgeInsets.symmetric(vertical: 3)),
          ],
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (_) {
              if (widget.mouseListener.isResizing == false) {
                setState(() {
                  dragging = true;
                  hoverVisible = true;
                });
                delta = 0;
                widget.mouseListener.resizedRow = widget.rowConfig;
              }
            },
            onPanUpdate: (details) {
              if (details.globalPosition.dy >= widget.rowConfig.rect.top + 10) {
                widget.mouseListener.cursorListener.value = SystemMouseCursors.resizeRow;
                setState(() => delta += details.delta.dy);
              } else {
                widget.mouseListener.cursorListener.value = SystemMouseCursors.basic;
              }
            },
            onPanEnd: (_) {
              widget.mouseListener.resizedRow = null;
              widget.mouseListener.sheetController.resizeRowBy(widget.rowConfig, delta);
              setState(() {
                dragging = false;
                hoverVisible = hovered;
                delta = 0;
              });
              widget.mouseListener.cursorListener.value = hovered ? SystemMouseCursors.resizeRow : SystemMouseCursors.basic;
            },
            child: MouseRegion(
              onEnter: (_) {
                hovered = true;
                if (widget.mouseListener.isResizing == false) {
                  setState(() => hoverVisible = true);
                  widget.mouseListener.cursorListener.value = SystemMouseCursors.resizeRow;
                }
              },
              onExit: (_) {
                hovered = false;
                if (widget.mouseListener.isResizing == false) {
                  setState(() => hoverVisible = false);
                  widget.mouseListener.cursorListener.value = SystemMouseCursors.basic;
                }
              },
              child: SizedBox(
                width: widget.rowConfig.rect.width,
                height: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalResizeDivider extends StatefulWidget {
  final ColumnConfig columnConfig;
  final MouseListener mouseListener;

  const VerticalResizeDivider({
    required this.columnConfig,
    required this.mouseListener,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _VerticalResizeDividerState();
}

class _VerticalResizeDividerState extends State<VerticalResizeDivider> {
  bool hoverVisible = false;
  bool hovered = false;
  double delta = 0;
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.columnConfig.rect.top,
      left: widget.columnConfig.rect.right - 5.5 + delta,
      child: Stack(
        children: [
          if (hoverVisible) ...<Widget>[
            SizedBox(
              width: 11,
              height: widget.columnConfig.rect.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 16,
                    width: 3,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 5),
                  Container(
                    height: 16,
                    width: 3,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            if (dragging) Container(width: 5, height: double.maxFinite, color: const Color(0xffc4c7c5), margin: const EdgeInsets.symmetric(horizontal: 3)),
          ],
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (_) {
              if (widget.mouseListener.isResizing == false) {
                setState(() {
                  dragging = true;
                  hoverVisible = true;
                });
                delta = 0;
                widget.mouseListener.resizedColumn = widget.columnConfig;
              }
            },
            onPanUpdate: (details) {
              if (details.globalPosition.dx >= widget.columnConfig.rect.left + 10) {
                widget.mouseListener.cursorListener.value = SystemMouseCursors.resizeColumn;
                setState(() => delta += details.delta.dx);
              } else {
                widget.mouseListener.cursorListener.value = SystemMouseCursors.basic;
              }
            },
            onPanEnd: (_) {
              widget.mouseListener.resizedColumn = null;
              widget.mouseListener.sheetController.resizeColumnBy(widget.columnConfig, delta);
              setState(() {
                dragging = false;
                hoverVisible = hovered;
                delta = 0;
              });
              widget.mouseListener.cursorListener.value = hovered ? SystemMouseCursors.resizeColumn : SystemMouseCursors.basic;
            },
            child: MouseRegion(
              onEnter: (_) {
                hovered = true;
                if (widget.mouseListener.isResizing == false) {
                  setState(() => hoverVisible = true);
                  widget.mouseListener.cursorListener.value = SystemMouseCursors.resizeColumn;
                }
              },
              onExit: (_) {
                hovered = false;
                if (widget.mouseListener.isResizing == false) {
                  setState(() => hoverVisible = false);
                  widget.mouseListener.cursorListener.value = SystemMouseCursors.basic;
                }
              },
              child: SizedBox(
                width: 11,
                height: widget.columnConfig.rect.height,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SheetTextField extends StatelessWidget {
  final CellConfig cellConfig;

  const SheetTextField({super.key, required this.cellConfig});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffa8c7fa), width: 2, strokeAlign: BorderSide.strokeAlignOutside),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xff3572e3), width: 2),
        ),
        child: IntrinsicWidth(
          child: TextField(
            autofocus: true,
            controller: TextEditingController(text: cellConfig.value),
            style: const TextStyle(color: Colors.black, fontSize: 12, height: 1),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            ),
          ),
        ),
      ),
    );
  }
}
