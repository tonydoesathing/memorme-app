import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository_event.dart';
import 'package:memorme_android_flutter/widgets/memory_display.dart';

class ViewMemoryPageArguments {
  final Memory memory;

  ViewMemoryPageArguments(this.memory);
}

class ViewMemoryPage extends StatefulWidget {
  final Memory memory;
  const ViewMemoryPage(this.memory, {Key key}) : super(key: key);

  @override
  _ViewMemoryPageState createState() => _ViewMemoryPageState();
}

class _ViewMemoryPageState extends State<ViewMemoryPage> {
  Memory memory;
  @override
  void initState() {
    super.initState();
    memory = widget.memory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: MemoryDisplay(
        memory,
        onEditSave: (memory) {
          setState(() {
            this.memory = memory;
          });
        },
        deleteMemory: (Memory memory) =>
            RepositoryProvider.of<MemoryRepository>(context)
                .removeMemory(memory)
                .then((mem) {
          RepositoryProvider.of<MemoryRepository>(context)
              .addEvent(MemoryRepositoryRemoveMemory(mem));
          return mem;
        }),
      )),
    );
  }
}
