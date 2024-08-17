
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_time/models/shop_app/search_model.dart';
import 'package:shopping_time/modules/search/cubit/states.dart';
import 'package:shopping_time/shared/components/contents.dart';
import 'package:shopping_time/shared/network/remote/dio_helper.dart';

import '../../../shared/network/end_points.dart';

class SearchCubit extends Cubit<SearchState>
{
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;
  void search(String text)
  {
    print('Search started');
    emit(SearchLoadingState());
    DioHelper.postData(
      url: SEARCH,
      token: token,
      data: {
        'text' : text,
      },
    ).then((value) {
      model = SearchModel.fromJson(value.data);
      print('Search success');
      emit(SearchSuccessState());
    }).catchError((error){
      print('Search error: ${error.toString()}');
      emit(SearchErrorState());
    });
  }
}