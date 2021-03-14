import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/logic/memories_bloc/memories_bloc.dart';
import 'package:memorme_android_flutter/pages/edit_memory_page.dart';
import 'package:memorme_android_flutter/widgets/loading_indicator.dart';
import 'package:memorme_android_flutter/widgets/memories_list_horizontal.dart';

/// Displays one [Memory] at a time from a [MemoriesBloc]
///
/// Takes an optional [focusedIndex], which is the starting page from the list of [Memory]
/// Once we get to the 2nd to last page, it checks to see if we can load more [Memory];
///  if so, it sends the request
class DisplayMemoriesList extends StatelessWidget {
  final int focusedIndex;
  const DisplayMemoriesList({Key key, this.focusedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocConsumer(
          cubit: BlocProvider.of<MemoriesBloc>(context),
          builder: (context, state) {
            if (state is MemoriesInitial) {
              return Center(
                child: LoadingIndicator(
                  width: 100,
                  height: 100,
                ),
              );
            } else {
              return MemoriesList(
                memories: state.memories,
                focusedIndex: focusedIndex ?? 0,
                onPageChanged: (index, max) {
                  // if we're near the end of the memories list we have (the next memory is the last one)
                  // and we know there are more memories
                  // load the next set of memories
                  if (index == max - 2 && !state.hasReachedMax) {
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
        ));
  }
}
