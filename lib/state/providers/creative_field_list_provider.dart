import 'package:hooks_riverpod/hooks_riverpod.dart';

// List of all fields users can choose from as their favourite

final creativeFieldListProvider = Provider<Iterable<String>>((ref) {
  return [
    "Visual Arts and Design",
    "Media and Entertainment",
    "Writing and Publishing",
    "Fashion and Styling",
    "User Experience and Interface",
    "Performing Arts",
    "Marketing and Advertising",
    "Crafts and DIY",
    "Culinary Arts",
    "Event Planning and Management",
    "Technology and Sound"
  ];
});
