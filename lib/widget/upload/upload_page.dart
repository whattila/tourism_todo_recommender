import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_todo_recommender/bloc/upload/upload_event.dart';
import '../../bloc/upload/upload_bloc.dart';
import '../../bloc/upload/upload_state.dart';
import '../../models/todo.dart';
import '../../repository/tourism_repository.dart';

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
      child: const UploadView(),
    );
  }
}

class UploadView extends StatelessWidget {
  const UploadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((UploadBloc bloc) => bloc.state.status);
    final isNewTodo = context.select(
          (UploadBloc bloc) => bloc.state.isNewTodo,
    );

    const fabBackgroundColor = Colors.deepOrange;
    const fabForegroundColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewTodo
              ? 'Create and upload new todo'
              : 'Edit my todo',
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(isNewTodo ? 'UPLOAD' : 'UPDATE'),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        foregroundColor: fabForegroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context.read<UploadBloc>().add(const UploadSubmitted()),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [_ShortDescriptionField(), _NatureField(), _AddressField(), _LongDescriptionField()],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShortDescriptionField extends StatelessWidget {
  const _ShortDescriptionField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UploadBloc>().state;
    final hintText = state.initialTodo?.shortDescription ?? 'The short description of your touristic todo';

    // Users should not write something too long here.
    const maximumCharacters = 50;

    return TextFormField(
      key: const Key('uploadView_shortDescription_textFormField'),
      initialValue: state.shortDescription,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: 'Short description',
        hintText: hintText,
        border: const OutlineInputBorder()
      ),
      maxLength: maximumCharacters,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maximumCharacters),
      ],
      onChanged: (value) {
        context.read<UploadBloc>().add(UploadShortDescriptionChanged(value));
      },
    );
  }
}

class _NatureField extends StatelessWidget {
  const _NatureField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UploadBloc>().state;
    final hintText = state.initialTodo?.nature ?? 'What kind of activity your touristic todo is';

    // Users should not write something too long here.
    const maximumCharacters = 50;

    return TextFormField(
      key: const Key('uploadView_nature_textFormField'),
      initialValue: state.nature,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: 'Nature',
        hintText: hintText,
        border: const OutlineInputBorder()
      ),
      maxLength: maximumCharacters,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maximumCharacters),
      ],
      onChanged: (value) {
        context.read<UploadBloc>().add(UploadNatureChanged(value));
      },
    );
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UploadBloc>().state;
    final hintText = state.initialTodo?.address ?? 'The most accurate location where the todo is found';

    // It should not be too long, and I think this is enough for every case.
    const maximumCharacters = 100;

    return TextFormField(
      key: const Key('uploadView_address_textFormField'),
      initialValue: state.address,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: 'Address',
        hintText: hintText,
        border: const OutlineInputBorder()
      ),
      maxLength: maximumCharacters,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maximumCharacters),
      ],
      onChanged: (value) {
        context.read<UploadBloc>().add(UploadAddressChanged(value));
      },
    );
  }
}

class _LongDescriptionField extends StatelessWidget {
  const _LongDescriptionField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UploadBloc>().state;
    final hintText = state.initialTodo?.detailedDescription ?? 'The detailed description of your touristic todo';

    // Only the first 1,500 bytes of the UTF-8 representation are considered by queries by Cloud Firestore.
    // 1 char in UTF-8 is 1 to 4 bytes.
    // Actually now it does not matter as we search in the client app
    // but if we switch to e.g. Algolia, it will
    const maximumCharacters = 375;

    return TextFormField(
      key: const Key('uploadView_detailedDescription_textFormField'),
      initialValue: state.detailedDescription,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: 'Detailed description',
        hintText: hintText,
        border: const OutlineInputBorder()
      ),
      minLines: 6,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      maxLength: maximumCharacters,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maximumCharacters),
      ],
      onChanged: (value) {
        context.read<UploadBloc>().add(UploadDetailedDescriptionChanged(value));
      },
    );
  }
}
