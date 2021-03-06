import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/own/own_todos_bloc.dart';
import '../../bloc/own/own_todos_event.dart';
import '../../bloc/own/own_todos_state.dart';
import '../../data/todo.dart';
import '../../repository/tourism_repository.dart';
import '../upload/upload_page.dart';

class OwnTodosPage extends StatelessWidget {
  const OwnTodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OwnTodosBloc(
        tourismRepository: context.read<TourismRepository>(),
      )..add(const OwnTodosSubscriptionRequested()),
      child: const OwnTodosView(),
    );
  }
}

class OwnTodosView extends StatelessWidget {
  const OwnTodosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OwnTodosBloc, OwnTodosState>(
        listenWhen: (previous, current) =>
        previous.status != current.status,
        listener: (context, state) {
          if (state.status == OwnTodosStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('An error occured while loading your uploaded todos'),
                ),
              );
          }
        },
        child: BlocBuilder<OwnTodosBloc, OwnTodosState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == OwnTodosStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status != OwnTodosStatus.success) {
                return const SizedBox();
              } else {
                return const Center(
                  child: Text(
                    'You have not uploaded any todos yet',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
            }

            return Scrollbar(
              child: ListView(
                children: [
                  for (final todo in state.todos)
                    _TodoListTile(item: todo)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TodoListTile extends StatelessWidget {
  const _TodoListTile({Key? key, required this.item}) : super(key: key);

  final Todo item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.shortDescription),
      subtitle: Text(item.address),
      onTap: () => Navigator.of(context).push(UploadPage.route(initialTodo: item)),
    );
  }
}
