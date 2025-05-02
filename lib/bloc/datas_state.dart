part of 'datas_bloc.dart';

@immutable
sealed class DatasState {}

final class DatasInitial extends DatasState {}
class InitialLoading extends DatasState{}
class MoreDataLoading extends DatasState{
  bool isLoading;
  List<Model>datas;
  MoreDataLoading({required this.isLoading,required this.datas});
}
class LoadedDataState extends DatasState{
    bool isLoading;
    List<Model>datas;
    LoadedDataState({required this.datas,required this.isLoading});
}