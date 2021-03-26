import 'package:flutter/material.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/presentation/theme/memorme_colors.dart';
import 'package:memorme_android_flutter/widgets/memory/memory_preview.dart';
import 'package:memorme_android_flutter/widgets/story_previews/picture_story_preview.dart';
import 'package:memorme_android_flutter/widgets/story_previews/text_story_preview.dart';

/// Displays a grid of [Memory] from a provided list of [memories]
///
/// Goes into select mode if [isSelectActive] is true and checks if a memory's ID is true in [selectedMemories]
/// Takes optional callbacks for [onTileTap] and [onScrollHit]
/// [onTileTap] is when a grid tile is tapped
/// [onTileHold] is when a grid tile is long pressed
/// [onScrollHit] is when the user scrolls to 200 pixels above the bottom, which checks according to [shouldCheckScroll]
///
/// In select mode, an app bar pops up at the top.
/// [onCloseSelectMode] is called when the exit button is tapped
/// [actions] are the buttons on the right of the bar
class MemoriesGrid extends StatefulWidget {
  final List<Memory> memories;
  final bool isSelectActive;
  final Map<Memory, bool> selectedMemories;
  final void Function(Memory memory, bool isSelectActive) onTileTap;
  final void Function(Memory memory, bool isSelectActive) onTileHold;
  final void Function() onScrollHit;
  final bool Function() shouldCheckScroll;
  final void Function() onCloseSelectMode;
  final List<Widget> actions;
  const MemoriesGrid(
      {Key key,
      this.memories = const [],
      this.onTileTap,
      this.onTileHold,
      this.onScrollHit,
      this.shouldCheckScroll,
      this.isSelectActive = false,
      this.selectedMemories = const {},
      this.onCloseSelectMode,
      this.actions = const []})
      : super(key: key);

  @override
  _MemoriesGridState createState() => _MemoriesGridState();
}

class _MemoriesGridState extends State<MemoriesGrid> {
  ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (widget.shouldCheckScroll == null || widget.shouldCheckScroll()) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        if (maxScroll - currentScroll <= _scrollThreshold) {
          if (widget.onScrollHit != null) {
            widget.onScrollHit.call();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.isSelectActive)
          AppBar(
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  widget.onCloseSelectMode?.call();
                }),
            title: Text(widget.selectedMemories.length.toString()),
            actions: widget.actions,
          ),
        Expanded(
          child: Padding(
              padding: EdgeInsets.only(top: 3),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.memories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    childAspectRatio: 0.85),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        //on tile tap, if callback passed in, call it
                        this.widget.onTileTap?.call(
                            widget.memories[index], this.widget.isSelectActive);
                      },
                      onLongPress: () {
                        this.widget.onTileHold?.call(
                            widget.memories[index], this.widget.isSelectActive);
                      },
                      child: widget.isSelectActive
                          ?
                          // select is active
                          // is memory selected?
                          widget.selectedMemories[widget.memories[index]] ==
                                  true
                              ? // memory is selected
                              Stack(
                                  children: [
                                    Container(
                                      color: MemorMeColors.blue.withAlpha(100),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: MemoryPreview(
                                            memory: widget.memories[index]),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8.0,
                                      left: 8.0,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: MemorMeColors.blue,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : // memory is not selected
                              Stack(
                                  children: [
                                    MemoryPreview(
                                        memory: widget.memories[index]),
                                    Positioned(
                                      top: 8.0,
                                      left: 8.0,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: MemorMeColors.background
                                              .withAlpha(200),
                                          border: Border.all(
                                              color: MemorMeColors.darkGrey
                                                  .withAlpha(200),
                                              width: 4.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                          :
                          // select is inactive
                          MemoryPreview(memory: widget.memories[index]));
                },
                controller: _scrollController,
              )),
        ),
      ],
    );
  }
}
