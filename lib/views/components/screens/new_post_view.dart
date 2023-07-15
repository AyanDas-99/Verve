import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/enums/file_type.dart';
import 'package:verve/state/image_upload/helper/image_picker_helper.dart';
import 'package:verve/state/post_upload/providers/post_upload_provider.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';
import 'package:verve/views/components/button.dart';
import 'package:verve/views/components/image_or_video_view.dart';
import 'package:verve/views/components/snackbars/failure_snackbar.dart';
import 'package:verve/views/components/snackbars/snackbar_model.dart';
import 'package:verve/views/components/text/regular_text.dart';
import 'package:verve/views/constants/strings.dart';

final selectedFileProvider = StateProvider.autoDispose<File?>((_) => null);
final selectedFileTypeProvider =
    StateProvider.autoDispose<FileType?>((_) => null);
final allowCommentsProvider = StateProvider<bool>((_) => true);

class NewPostView extends HookConsumerWidget {
  const NewPostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider);

    final fileToUpload = ref.watch(selectedFileProvider);
    final fileType = ref.watch(selectedFileTypeProvider);
    final allowComments = ref.watch(allowCommentsProvider);

    final titleController = useTextEditingController();
    final messageController = useTextEditingController();

    final canPost = useState(false);

    useEffect(() {
      void listener() => canPost.value = (fileToUpload != null) &&
          titleController.text.isNotEmpty &&
          messageController.text.isNotEmpty;

      titleController.addListener(listener);
      messageController.addListener(listener);

      return () {
        titleController.removeListener(listener);
        messageController.removeListener(listener);
      };
    }, [
      fileToUpload,
      titleController,
      messageController,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: regularText(Strings.addNewPost, fontSize: 25),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add title

              TextField(
                decoration: InputDecoration(
                    labelText: Strings.addTitle,
                    border: const OutlineInputBorder()),
                controller: titleController,
              ),

              const SizedBox(
                height: 20,
              ),

              // Selector
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.sizeOf(context).height * 0.3,
                ),
                child: (fileToUpload != null)
                    ? Center(child: ImageOrVideoView(fileToUpload, fileType))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // select image button
                          IconButton(
                            onPressed: () async {
                              ref
                                  .read(selectedFileTypeProvider.notifier)
                                  .state = FileType.image;
                              ref.read(selectedFileProvider.notifier).state =
                                  await ImagePickerHelper()
                                      .getImageFromGallery();
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.image,
                              size: 100,
                            ),
                          ),
                          // select video button
                          IconButton(
                            onPressed: () async {
                              ref
                                  .read(selectedFileTypeProvider.notifier)
                                  .state = FileType.video;
                              ref.read(selectedFileProvider.notifier).state =
                                  await ImagePickerHelper()
                                      .getVideoFromGallery();
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.video,
                              size: 100,
                            ),
                          )
                        ],
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Message
              TextField(
                decoration: InputDecoration(
                  labelText: Strings.addMessage,
                  border: const OutlineInputBorder(),
                ),
                controller: messageController,
              ),

              const SizedBox(
                height: 20,
              ),

              // Allow comment setting
              Row(
                children: [
                  regularText(Strings.allowComments),
                  Spacer(),
                  Switch(
                    value: ref.watch(allowCommentsProvider),
                    onChanged: (value) {
                      ref.read(allowCommentsProvider.notifier).state = value;
                    },
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              // Send buttons
              Row(
                children: [
                  const Spacer(),
                  button(
                      backgroundColor: (canPost.value)
                          ? Colors.greenAccent
                          : Colors.blueGrey.shade100,
                      onPress: (!canPost.value)
                          ? () {
                              FailureSnackBar('Fill all fields').show(context);
                            }
                          : () async {
                              final uploaded = await ref
                                  .read(postUploadProvider.notifier)
                                  .upload(
                                    postedBy: currentUserId,
                                    title: titleController.text,
                                    message: messageController.text,
                                    allowComments: allowComments,
                                    fileType: fileType!,
                                    file: fileToUpload!,
                                  );

                              if (context.mounted) {
                                if (uploaded) {
                                  Navigator.pop(context);
                                } else {
                                  FailureSnackBar(Strings.failedToUploadPost)
                                      .show(context);
                                }
                              }
                            },
                      text: Strings.post),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
