import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:pagination_with_either/api_service/api_service.dart';
import 'package:pagination_with_either/api_service/model.dart';

part 'datas_event.dart';
part 'datas_state.dart';

class DatasBloc extends Bloc<DatasEvent, DatasState> {
  DatasBloc() : super(DatasInitial()) {
    List<Model> models = [];
    int pageCount = 1;
    on<DatasEvent>((event, emit) async {
      log("Bloc fetch event called");
      if (pageCount != 1) {
        emit(MoreDataLoading(isLoading: true, datas: models));
      } else {
        emit(InitialLoading());
      }
      try {
        final Either<String, List<Model>> newDataOption =
            await ApiService.fetchData(pageCount);

        newDataOption.fold((failure) {
          log(failure);
        }, (success) {
          log("success either");
          pageCount++;
          models.addAll(success);
          emit(LoadedDataState(datas: models, isLoading: false));
        });
      } catch (e) {
        log("Somthing issue while loading data $e");
      }
    });
  }
}
