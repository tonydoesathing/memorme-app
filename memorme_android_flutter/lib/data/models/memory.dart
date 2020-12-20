import 'package:equatable/equatable.dart';

class Memory extends Equatable {
  final List<String> media;
  final List<String> stories;

  /// stores lists of [media] and [stories]
  const Memory(this.media, this.stories);

  @override
  List<Object> get props => [media, stories];
}
