
import 'package:shopping_time/models/shop_app/login_model.dart';

abstract class ShopState {}

class ShopInitialState extends ShopState{}

class ShopChangeBottomNavState extends ShopState {}


class ShopLoadingHomeDataState extends ShopState{}
class ShopSuccessHomeDataState extends ShopState{}
class ShopErrorHomeDataState extends ShopState{}


class ShopSuccessCategoriesState extends ShopState{}
class ShopErrorCategoriesState extends ShopState{}

class ShopSuccessChangeFavoritesState extends ShopState
{
}
class ShopChangeFavoritesState extends ShopState{}
class ShopErrorChangeFavoritesState extends ShopState{}


class ShopSuccessGetFavoritesState extends ShopState{}
class ShopLoadingGetFavoritesState extends ShopState{}
class ShopErrorGetFavoritesState extends ShopState{}


class ShopLoadingUserDataState extends ShopState {}
class ShopSuccessUserDataState extends ShopState
{
  final ShopLoginModel loginModel;

  ShopSuccessUserDataState(this.loginModel);
}
class ShopErrorUserDataState extends ShopState{}

class ShopLoadingUpdateUserState extends ShopState {}
class ShopSuccessUpdateUserState extends ShopState
{
  final ShopLoginModel loginModel;

  ShopSuccessUpdateUserState(this.loginModel);
}
class ShopErrorUpdateUserState extends ShopState{}
