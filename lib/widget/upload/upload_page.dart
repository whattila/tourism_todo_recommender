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
          previous.uploadStatus != current.uploadStatus &&
          current.uploadStatus == UploadStatus.success,
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
    final uploadStatus = context.select((UploadBloc bloc) => bloc.state.uploadStatus);
    final isNewTodo = context.select((UploadBloc bloc) => bloc.state.isNewTodo,);

    const fabBackgroundColor = Colors.deepOrange;
    const fabForegroundColor = Colors.white;

    return Form(
      key: _key,
      child: Scaffold(
        appBar: AppBar(title: Text(isNewTodo ? 'Create and upload new todo' : 'Edit my todo',),),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.upload),
          label: Text(isNewTodo ? 'UPLOAD' : 'UPDATE'),
          backgroundColor: uploadStatus.isLoadingOrSuccess ? fabBackgroundColor.withOpacity(0.5) : fabBackgroundColor,
          foregroundColor: fabForegroundColor,
          onPressed: uploadStatus.isLoadingOrSuccess ? null : _uploadTodo
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  _ShortDescriptionInputArea(shortDescriptionController: _shortDescriptionController, uploadStatus: uploadStatus),
                  const SizedBox(height: 8),
                  _NatureInputArea(natureController: _natureController, uploadStatus: uploadStatus),
                  const SizedBox(height: 8),
                  _AddressInputArea(addressController: _addressController, uploadStatus: uploadStatus),
                  const SizedBox(height: 8),
                  _DetailedDescriptionInputArea(detailedDescriptionController: _detailedDescriptionController, uploadStatus: uploadStatus),
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

class _ShortDescriptionInputArea extends StatelessWidget {
  const _ShortDescriptionInputArea({
    Key? key,
    required TextEditingController shortDescriptionController,
    required this.uploadStatus,
  }) : _shortDescriptionController = shortDescriptionController, super(key: key);

  final TextEditingController _shortDescriptionController;
  final UploadStatus uploadStatus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _shortDescriptionController,
      decoration: InputDecoration(
          enabled: !uploadStatus.isLoadingOrSuccess,
          labelText: 'Short description',
          hintText: 'The short description of your touristic todo',
          border: const OutlineInputBorder()
      ),
      maxLength: UploadBloc.shortDescriptionMaxCharacters,
      inputFormatters: [
        LengthLimitingTextInputFormatter(UploadBloc.shortDescriptionMaxCharacters),
      ],
      validator: UploadBloc.validateShortDescription,
    );
  }
}

class _NatureInputArea extends StatelessWidget {
  const _NatureInputArea({
    Key? key,
    required TextEditingController natureController,
    required this.uploadStatus,
  }) : _natureController = natureController, super(key: key);

  final TextEditingController _natureController;
  final UploadStatus uploadStatus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _natureController,
      decoration: InputDecoration(
          enabled: !uploadStatus.isLoadingOrSuccess,
          labelText: 'Nature',
          hintText: 'What kind of activity your touristic todo is',
          border: const OutlineInputBorder()
      ),
      maxLength: UploadBloc.natureMaxCharacters,
      inputFormatters: [
        LengthLimitingTextInputFormatter(UploadBloc.natureMaxCharacters),
      ],
      validator: UploadBloc.validateNature,
    );
  }
}

class _AddressInputArea extends StatelessWidget {
  const _AddressInputArea({
    Key? key,
    required TextEditingController addressController,
    required this.uploadStatus,
  }) : _addressController = addressController, super(key: key);

  final TextEditingController _addressController;
  final UploadStatus uploadStatus;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listenWhen: (previous, current) =>
        previous.addressStatus != current.addressStatus && current.addressStatus == AddressStatus.success,
      listener: (context, state) {
        _addressController.value = TextEditingValue(text: state.deviceAddress, selection: TextSelection.collapsed(offset: state.deviceAddress.length));
      },
      child: _AddressWidget(addressController: _addressController, uploadStatus: uploadStatus),
    );
  }
}

class _AddressWidget extends StatelessWidget {
  const _AddressWidget({
    Key? key,
    required TextEditingController addressController,
    required this.uploadStatus,
  }) : _addressController = addressController, super(key: key);

  final TextEditingController _addressController;
  final UploadStatus uploadStatus;

  @override
  Widget build(BuildContext context) {
    final addressStatus = context.select((UploadBloc bloc) => bloc.state.addressStatus);

    return Column(
        children: [
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
                enabled: !uploadStatus.isLoadingOrSuccess,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ElevatedButton.icon(
                  onPressed: () => context.read<UploadBloc>().add(const CurrentAddressRequested()),
                  icon: const Icon(Icons.pin_drop),
                  label: addressStatus == AddressStatus.loading ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3,) : const Text("Get current address"),
                ),
              ),
            ],
          ),
        ],
      );
  }
}

class _DetailedDescriptionInputArea extends StatelessWidget {
  const _DetailedDescriptionInputArea({
    Key? key,
    required TextEditingController detailedDescriptionController,
    required this.uploadStatus,
  }) : _detailedDescriptionController = detailedDescriptionController, super(key: key);

  final TextEditingController _detailedDescriptionController;
  final UploadStatus uploadStatus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _detailedDescriptionController,
      decoration: InputDecoration(
          enabled: !uploadStatus.isLoadingOrSuccess,
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
    );
  }
}

class _ImageHeader extends StatelessWidget {
  const _ImageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uploadStatus = context.select((UploadBloc bloc) => bloc.state.uploadStatus);

    return Column(
      children: [
        // TODO: replace this with dialog
        ElevatedButton.icon(
          onPressed: uploadStatus.isLoadingOrSuccess ? null :() => context.read<UploadBloc>().add(const ImageAddRequested(source: ImageSource.camera)),
          icon: const Icon(Icons.camera_alt),
          label: const Text("Take picture with camera"),
          style: ButtonStyle(
            backgroundColor: uploadStatus.isLoadingOrSuccess ?
            MaterialStateProperty.all<Color>(Colors.orange.withOpacity(0.5))
                : MaterialStateProperty.all<Color>(Colors.orange),
            foregroundColor: uploadStatus.isLoadingOrSuccess ?
            MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.5))
                : MaterialStateProperty.all<Color>(Colors.black),
          ),
        ),
        const SizedBox(height: 4),
        ElevatedButton.icon(
          onPressed: uploadStatus.isLoadingOrSuccess ?
          null
              :() => context.read<UploadBloc>().add(const ImageAddRequested(source: ImageSource.gallery)),
          icon: const Icon(Icons.photo_album),
          label: const Text("Select images from gallery"),
          style: ButtonStyle(
            backgroundColor: uploadStatus.isLoadingOrSuccess ?
            MaterialStateProperty.all<Color>(Colors.red.withOpacity(0.5))
                : MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: uploadStatus.isLoadingOrSuccess ?
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
          previous.images.length != current.images.length || current.uploadStatus.isLoadingOrSuccess,
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
                onTap: state.uploadStatus.isLoadingOrSuccess ?
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
