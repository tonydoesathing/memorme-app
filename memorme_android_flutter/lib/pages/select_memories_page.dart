import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/logic/select_memories_bloc/select_memories_bloc.dart';
import 'package:memorme_android_flutter/widgets/memories_grid.dart';

class SelectMemoriesPageArguments {
  final void Function(List<Memory> selectedMemories) onSave;

  SelectMemoriesPageArguments({this.onSave});
}

class SelectMemoriesPage extends StatelessWidget {
  final void Function(List<Memory> selectedMemories) onSave;

  const SelectMemoriesPage({Key key, this.onSave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectMemoriesBloc, SelectMemoriesBlocState>(
      listener: (context, state) {
        if (state is SelectMemoriesBlocError) {
          print(state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: MemoriesGrid(
            memories: state.memories,
            shouldCheckScroll: () {
              return !(state is SelectMemoriesBlocLoading) &&
                  !state.hasReachedMax;
            },
            onScrollHit: () {
              if (!state.hasReachedMax) {
                BlocProvider.of<SelectMemoriesBloc>(context)
                    .add(SelectMemoriesBlocLoadMemories(false));
              }
            },
            isSelectActive: true,
            selectedMemories: state.selectedMemories,
            onTileTap: (memory, isSelectActive) {
              // if memory is selected, unselect it
              if (state.selectedMemories[memory] == true) {
                BlocProvider.of<SelectMemoriesBloc>(context)
                    .add(SelectMemoriesBlocUnselectMemory(memory));
              } else {
                // select it
                BlocProvider.of<SelectMemoriesBloc>(context)
                    .add(SelectMemoriesBlocSelectMemory(memory));
              }
            },
            onCloseSelectMode: () {
              Navigator.pop(context);
            },
            actions: [
              if (state.selectedMemories.length > 0)
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      onSave?.call(state.selectedMemories.keys.toList());
                      Navigator.pop(context);
                    })
            ],
          ),
        );
      },
    );
  }
}
