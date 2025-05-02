import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_either/api_service/api_service.dart';
import 'package:pagination_with_either/bloc/datas_bloc.dart';
import 'package:pagination_with_either/api_service/model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController _controller;
  bool isLoading = false;
  List<Model> datas = [];
  int pageCount = 1;
  @override
  void initState() {
    ApiService.fetchData(1);
    context.read<DatasBloc>().add(LoadDataEvent());
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent * 0.9 <=
              _controller.position.pixels &&
          !isLoading) {
        context.read<DatasBloc>().add(LoadDataEvent());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BlocConsumer<DatasBloc, DatasState>(
        listener: (context, state) {
          if(state is MoreDataLoading){
            isLoading = state.isLoading;
          }else if(state is LoadedDataState){
            isLoading = state.isLoading;
            datas = state.datas;
          }
        },
        builder: (context, state) {
          if(state is InitialLoading){
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            controller: _controller,
            itemCount: datas.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == datas.length) {
                return Center(child: CircularProgressIndicator());
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(child: Text((index + 1).toString())),
                    shape: Border.all(),
                    title: Text(datas[index].title.toString()),
                    subtitle: Text(
                      datas[index].body.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
