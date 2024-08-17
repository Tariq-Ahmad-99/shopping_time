import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_time/layout/shop_cubit/shop_state.dart';
import 'package:shopping_time/models/shop_app/categories_model.dart';
import 'package:shopping_time/models/shop_app/favorites_model.dart';
import 'package:shopping_time/models/shop_app/home_model.dart';
import 'package:shopping_time/models/shop_app/login_model.dart';
import 'package:shopping_time/modules/categories/categories_screen.dart';
import 'package:shopping_time/modules/favorites/favorites_screen.dart';
import 'package:shopping_time/modules/products/products_screen.dart';
import 'package:shopping_time/modules/setting/setting_screen.dart';
import 'package:shopping_time/shared/network/end_points.dart';
import 'package:shopping_time/shared/network/remote/dio_helper.dart';
import '../../models/shop_app/change_favorite_model.dart';

class ShopCubit extends Cubit<ShopState>
{
  final String? token;
  ShopCubit({this.token}) : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingScreen(),
  ];

  void changeBottom(int index)
  {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};


  void getHomeData()
  {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
        url: HOME,
        token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data!.products.forEach((element)
      {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      });

      emit(ShopSuccessHomeDataState());
    }).catchError((error)
    {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorHomeDataState());
    });
  }


  CategoriesModel? categoriesModel;

  void getCategories()
  {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error)
    {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;


  void changeFavorites(int productId)
  {
    favorites[productId] = !favorites[productId]!;
    emit(ShopSuccessChangeFavoritesState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {

      changeFavoritesModel != null ?  ChangeFavoritesModel.fromJson(value.data) : null;

      if(changeFavoritesModel?.status == false)
        {
          favorites[productId] = !favorites[productId]!;
        }else
          {
            getFavorites();
          }


      emit(ShopSuccessChangeFavoritesState());
    }).catchError((error)
    {
      emit(ShopErrorChangeFavoritesState());
    });
  }


  FavoritesModel? favoritesModel;

  void getFavorites()
  {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error)
    {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorGetFavoritesState());
    });
  }


  ShopLoginModel? userModel;


  void getUserData() {
    print('getUserData() called');
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      final responseData = value.data;

      if (responseData['status'] == true) {
        userModel = ShopLoginModel.fromJson(responseData);

        emit(ShopSuccessUserDataState(userModel!));
      } else {
        emit(ShopErrorUserDataState());
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
})
  {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      final responseData = value.data;

      if (responseData['status'] == true) {
        userModel = ShopLoginModel.fromJson(responseData);

        emit(ShopSuccessUpdateUserState(userModel!));
      } else {
        emit(ShopErrorUpdateUserState());
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorUpdateUserState());
    });
  }


}