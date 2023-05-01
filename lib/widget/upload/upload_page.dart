import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourism_todo_recommender/bloc/upload/upload_event.dart';
import '../../bloc/upload/upload_bloc.dart';
import '../../bloc/upload/upload_state.dart';
import '../../models/todo.dart';
import '../../repository/tourism_repository.dart';
import '../image/image_page.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  static Route<void> route({Todo? initialTodo}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => UploadBloc(
          tourismRepository: context.read<TourismRepository>(),
          initialTodo: initialTodo,
        ),
        child: const UploadPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == UploadStatus.success,
      listener: (context, state) {
        final snackBarText = state.isNewTodo ? 'Todo uploaded successfully' : 'Todo updated successfully';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(snackBarText)),
          );
        Navigator.of(context).pop();
      },
      child: const _UploadForm(),
    );
  }
}

class _UploadForm extends StatefulWidget {
  const _UploadForm({Key? key}) : super(key: key);

  @override
  _UploadFormState createState() => _UploadFormState();
}

class _UploadFormState extends State<_UploadForm> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _shortDescriptionController;
  late final TextEditingController _natureController;
  late final TextEditingController _addressController;
  late final TextEditingController _detailedDescriptionController;

  @override
  void initState() {
    super.initState();
    _shortDescriptionController = TextEditingController(text: context.read<UploadBloc>().state.initialTodo?.shortDescription);
    _natureController = TextEditingController(text: context.read<UploadBloc>().state.initialTodo?.nature);
    _addressController = TextEditingController(text: context.read<UploadBloc>().state.initialTodo?.address);
    _detailedDescriptionController = TextEditingController(text: context.read<UploadBloc>().state.initialTodo?.detailedDescription);
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select((UploadBloc bloc) => bloc.state.status);
    final isNewTodo = context.select(
          (UploadBloc bloc) => bloc.state.isNewTodo,
    );

    const fabBackgroundColor = Colors.deepOrange;
    const fabForegroundColor = Colors.white;

    return Form(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isNewTodo
                ? 'Create and upload new todo'
                : 'Edit my todo',
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.upload),
          label: Text(isNewTodo ? 'UPLOAD' : 'UPDATE'),
          backgroundColor: status.isLoadingOrSuccess
              ? fabBackgroundColor.withOpacity(0.5)
              : fabBackgroundColor,
          foregroundColor: fabForegroundColor,
          onPressed: status.isLoadingOrSuccess ? null : _uploadTodo
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _shortDescriptionController,
                    decoration: InputDecoration(
                        enabled: !status.isLoadingOrSuccess,
                        labelText: 'Short description',
                        hintText: 'The short description of your touristic todo',
                        border: const OutlineInputBorder()
                    ),
                    maxLength: UploadBloc.shortDescriptionMaxCharacters,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(UploadBloc.shortDescriptionMaxCharacters),
                    ],
                    validator: UploadBloc.validateShortDescription,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _natureController,
                    decoration: InputDecoration(
                        enabled: !status.isLoadingOrSuccess,
                        labelText: 'Nature',
                        hintText: 'What kind of activity your touristic todo is',
                        border: const OutlineInputBorder()
                    ),
                    maxLength: UploadBloc.natureMaxCharacters,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(UploadBloc.natureMaxCharacters),
                    ],
                    validator: UploadBloc.validateNature,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        enabled: !status.isLoadingOrSuccess,
                        labelText: 'Address',
                        hintText: 'The most accurate location where the todo is found',
                        border: const OutlineInputBorder()
                    ),
                    maxLength: UploadBloc.addressMaxCharacters,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(UploadBloc.addressMaxCharacters),
                    ],
                    validator: UploadBloc.validateAddress,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _detailedDescriptionController,
                    decoration: InputDecoration(
                        enabled: !status.isLoadingOrSuccess,
                        labelText: 'Detailed description',
                        hintText: 'The detailed description of your touristic todo',
                        border: const OutlineInputBorder()
                    ),
                    minLines: 6,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    maxLength: UploadBloc.detailedDescriptionMaxCharacters,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(UploadBloc.detailedDescriptionMaxCharacters),
                    ],
                    validator: UploadBloc.validateDetailedDescription,
                  ),
                  const SizedBox(height: 8),
                  const _ImageHeader(),
                  const SizedBox(height: 8),
                  const _ImageList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _uploadTodo() {
    if (_key.currentState?.validate() ?? false) {
      context.read<UploadBloc>().add(
          UploadSubmitted(
              detailedDescription: _detailedDescriptionController.value.text,
              nature: _natureController.value.text,
              address: _addressController.value.text,
              shortDescription: _shortDescriptionController.value.text
          )
      );
    }
    else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('No fields can be empty')),
        );
    }
  }

  @override
  void dispose() {
    _shortDescriptionController.dispose();
    _natureController.dispose();
    _addressController.dispose();
    _detailedDescriptionController.dispose();
    super.dispose();
  }
}

class _ImageHeader extends StatelessWidget {
  const _ImageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((UploadBloc bloc) => bloc.state.status);

    return Column(
      children: [
        // TODO: replace this with dialog
        ElevatedButton.icon(
          onPressed: status.isLoadingOrSuccess ?
          null
              :() => context.read<UploadBloc>().add(const ImageAddRequested(source: ImageSource.camera)),
          icon: const Icon(Icons.camera_alt),
          label: const Text("Take picture with camera"),
          style: ButtonStyle(
            backgroundColor: status.isLoadingOrSuccess ?
            MaterialStateProperty.all<Color>(Colors.orange.withOpacity(0.5))
                : MaterialStateProperty.all<Color>(Colors.orange),
            foregroundColor: status.isLoadingOrSuccess ?
            MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.5))
                : MaterialStateProperty.all<Color>(Colors.black),
          ),
        ),
        const SizedBox(height: 4),
        ElevatedButton.icon(
          onPressed: status.isLoadingOrSuccess ?
          null
              :() => context.read<UploadBloc>().add(const ImageAddRequested(source: ImageSource.gallery)),
          icon: const Icon(Icons.photo_album),
          label: const Text("Select images from gallery"),
          style: ButtonStyle(
            backgroundColor: status.isLoadingOrSuccess ?
            MaterialStateProperty.all<Color>(Colors.red.withOpacity(0.5))
                : MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: status.isLoadingOrSuccess ?
            MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.5))
                : MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              'Your current images:',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 25),
            ),
          ],
        )
      ],
    );
  }
}

class _ImageList extends StatelessWidget {
  const _ImageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadBloc, UploadState>(
        buildWhen: (previous, current) =>
          previous.images.length != current.images.length || current.status.isLoadingOrSuccess,
        builder: (context, state) {
          if (state.images.isEmpty) {
            return const Center(
              child: Text(
                'You haven\'t added any images yet',
                style: TextStyle(fontSize: 20),
              ),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 0,
              mainAxisSpacing: 2,
              crossAxisCount: 2,
            ),
            itemCount: state.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: state.status.isLoadingOrSuccess ?
                null
                    :() async {
                  final delete = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImagePage(image: state.images[index], modifiable: true,)),
                  );

                  // TODO: can it be achieved that if we step back, we get false instead of null?
                  if (delete != null && delete) {
                    BlocProvider.of<UploadBloc>(context).add(ImageDeleted(deletedIndex: index));
                  }
                }
                ,
                child: state.images[index].createWidget(),
              );
            },
          );
        }
    );
  }
}
