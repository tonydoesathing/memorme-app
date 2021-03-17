import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/logic/edit_collection_bloc/edit_collection_bloc.dart';

class EditCollectionArguments {
  final Function(Collection value) onSave;
  final Collection collection;

  EditCollectionArguments({this.onSave, this.collection});
}

class EditCollectionPage extends StatefulWidget {
  final Function(Collection value) onSave;
  EditCollectionPage({Key key, this.onSave}) : super(key: key);

  @override
  _EditCollectionPageState createState() => _EditCollectionPageState();
}

class _EditCollectionPageState extends State<EditCollectionPage> {
  EditCollectionBloc _editCollectionBloc;

  @override
  void initState() {
    super.initState();
    _editCollectionBloc = BlocProvider.of<EditCollectionBloc>(context);
  }

  void _checkCanSave(Collection collection) {
    // check to make sure there's everything for a Collection
    _editCollectionBloc.add(EditCollectionBlocSaveCollection());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditCollectionBloc, EditCollectionBlocState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Edit Collection"),
            actions: [
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    _checkCanSave(state.collection);
                  })
            ],
          ),
          body: Text(state.collection.title ?? ""),
        );
      },
      listener: (context, state) {
        if (state is EditCollectionSaved) {
          // saved properly
          if (widget.onSave != null) {
            widget.onSave(state.collection);
          }
        }
      },
    );
  }
}
