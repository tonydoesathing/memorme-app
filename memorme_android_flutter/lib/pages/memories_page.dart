import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/logic/memories_bloc/memories_bloc.dart';
import 'package:memorme_android_flutter/pages/edit_memory_page.dart';
import 'package:memorme_android_flutter/widgets/BottomNavBar.dart';
import 'package:memorme_android_flutter/widgets/loading_indicator.dart';
import 'package:memorme_android_flutter/widgets/memories_grid.dart';
import 'package:memorme_android_flutter/widgets/memories_list_horizontal.dart';

/// Displays a grid of [Memory] from a [MemoriesBloc]
///
/// Once it gets to 200 pixels above the end of the scrollable
/// grid, it checks to see if there are more [Memory] to load;
/// if so, it loads them
/// TODO: add variable to state to check to see if we're loading memories already
/// so then we don't call it a bajillion times on scroll
class MemoriesPage extends StatelessWidget {
  const MemoriesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(
            "Memories",
          ),
        ),
        Expanded(
          child: BlocConsumer(
            cubit: BlocProvider.of<MemoriesBloc>(context),
            builder: (context, state) {
              if (state is MemoriesInitial) {
                // memories app is loading up
                return Center(
                  child: LoadingIndicator(
                    width: 100,
                    height: 100,
                  ),
                );
              } else {
                // memories have been loaded
                // render what memories we have
                return MemoriesGrid(
                  key: PageStorageKey(key),
                  memories: state.memories,
                  onTileTap: (memory, index) {
                    //navigate to listview display
                    Navigator.pushNamed(context, '/display_memory_list',
                        arguments: MemoriesListArguments(index));
                  },
                  onScrollHit: () {
                    // load more memories if there are more
                    if (!state.hasReachedMax) {
                      BlocProvider.of<MemoriesBloc>(context)
                          .add(MemoriesBlocLoadMemories(false));
                    }
                  },
                );
              }
            },
            listener: (context, state) {
              if (state is MemoriesLoadFailure) {
                print(state.errorCode);
              }
            },
          ),
        )
      ],
    );
  }
}
