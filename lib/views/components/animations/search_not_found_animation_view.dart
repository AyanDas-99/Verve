import 'package:verve/views/components/animations/lottie_animation_view.dart';
import 'package:verve/views/constants/asset_files.dart';

class SearchNotFoundAnimationView extends LottieAnimationView {
  SearchNotFoundAnimationView({super.key})
      : super(
            animation: AssetFiles.searchNotFoundAnimation,
            repeat: true,
            reverse: false);
}
