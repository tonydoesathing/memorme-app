import 'package:equatable/equatable.dart';

class Memory extends Equatable {
  final List<String> _media;
  final List<String> _stories;

  /// stores lists of [_media] and [_stories]
  const Memory(this._media, this._stories);

  @override
  List<Object> get props => [_media, _stories];
}
