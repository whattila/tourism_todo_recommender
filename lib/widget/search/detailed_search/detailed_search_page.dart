import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_todo_recommender/bloc/search/detailed_search/detailed_search_state.dart';
import '../../../bloc/search/detailed_search/detailed_search_cubit.dart';

class DetailedSearchPage extends StatelessWidget {
  const DetailedSearchPage({Key? key}) : super(key: key);

  static Route<void> route({required DetailedSearchRequestListener listener}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => DetailedSearchCubit(listener),
        child: const DetailedSearchPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailedSearchCubit, DetailedSearchState>(
      listenWhen: (previous, current) =>
          previous.isSubmitted != current.isSubmitted &&
          current.isSubmitted == true,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const DetailedSearchView(),
    );
  }
}

class DetailedSearchView extends StatelessWidget {
  const DetailedSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detailed search"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'To search for texts in particular search areas, type the texts in the corresponding text fields. Use the other fields to set more filters.',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
              ),
              _SearchForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchForm extends StatefulWidget {
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<_SearchForm> {
  final _key = GlobalKey<FormState>();
  final uploaderController = TextEditingController();
  final shortDescriptionController = TextEditingController();
  final addressController = TextEditingController();
  final natureController = TextEditingController();
  final detailedDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: uploaderController,
          decoration: const InputDecoration(
            hintText: 'Search for uploader',
            border: OutlineInputBorder()
          ),
        ),
        TextFormField(
          controller: shortDescriptionController,
          decoration: const InputDecoration(
            hintText: 'Search in short description',
            border: OutlineInputBorder()
          ),
        ),
        TextFormField(
          controller: addressController,
          decoration: const InputDecoration(
            hintText: 'Search in address',
            border: OutlineInputBorder()
          ),
        ),
        TextFormField(
          controller: natureController,
          decoration: const InputDecoration(
            hintText: 'Search in nature',
            border: OutlineInputBorder()
          ),
        ),
        TextFormField(
          controller: detailedDescriptionController,
          decoration: const InputDecoration(
            hintText: 'Search in detailed description',
            border: OutlineInputBorder()
          ),
        ),
        const CheckboxRow(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<DetailedSearchCubit>().searchLaunched(
                      uploaderSearchTerm: uploaderController.value.text,
                      shortDescriptionSearchTerm: shortDescriptionController.value.text,
                      addressSearchTerm: addressController.value.text,
                      natureSearchTerm: natureController.value.text,
                      detailedDescriptionSearchTerm: detailedDescriptionController.value.text
                  );
                },
                icon: const Icon(Icons.search),
                label: const Text("SEARCH"),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    uploaderController.dispose();
    shortDescriptionController.dispose();
    addressController.dispose();
    natureController.dispose();
    detailedDescriptionController.dispose();

    super.dispose();
  }
}

class CheckboxRow extends StatelessWidget {
  const CheckboxRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isChecked = context.watch<DetailedSearchCubit>().state.isNearbyOnlyChecked;
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (checked) {
            if (checked != null) {
              context.read<DetailedSearchCubit>().nearbyOnlyCheckedChanged(checked);
            }
          },
        ),
        const Text("Only nearby todos")
      ],
    );
  }
}