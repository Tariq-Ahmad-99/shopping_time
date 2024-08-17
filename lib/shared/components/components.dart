import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_time/shared/styles/colors.dart';

import '../../layout/shop_cubit/shop_cubit.dart';
import '../../modules/wep_view/wep_view_screen.dart';


Widget buildArticleItem(article, context, {bool isDark = false}) {

  return article != null ? InkWell(
    onTap: () {
      navigateTo(context, WebViewScreen(article['url']));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: article['urlToImage'] != null
                  ? DecorationImage(
                image: NetworkImage('${article['urlToImage']}'),
                fit: BoxFit.cover,
              )
                  : null,
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: SizedBox(
              height: 120.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${article['title'] ?? ''}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${article['publishedAt'] ?? ''}',
                    style: TextStyle(
                      color: isDark ? Colors.grey[300] : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ): Container();
}

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(
    context,
    widget,
    ) =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => widget,
            ),
            (Route<dynamic> route) => false,
        );


void showToast({
  required String text,
  required ToastStates state,
}) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
enum ToastStates {success, error, warning}

Color chooseToastColor(ToastStates state)
{
  Color color;
  switch(state)
  {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}






Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);



Widget articleBuilder(list, context, {isSearch = false}) => ConditionalBuilder(
  condition: list.length > 0,
  builder: (context) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    itemBuilder: (context, index) => buildArticleItem(
      list[index], context,
      //isDark: NewsCubit.get(context).isDark,
    ),
    separatorBuilder: (context, index) => myDivider(),
    itemCount: 10,
  ),
  fallback: (context) => isSearch ? Container() : const Center(child: CircularProgressIndicator(),),
);

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  required String? Function(String?) validate,
  required String label,
  required IconData prefix,
  bool isPassword = false,
  IconData? suffix,
  void Function()? suffixPressed,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  validator: validate,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix != null ? IconButton(
      onPressed: suffixPressed,
      icon: Icon(
        suffix,
      ),
    ) : null,
    border: const OutlineInputBorder(),
  ),
);

Widget defaultButton({
  double width = double.infinity,
  Color background = defaultColor,
  double radius = 0.0,
  void Function()? function,
  required String text,
  bool isUpperCase = true,
}) => Container(
  width: width,
  height: 50.0,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(
      radius,
    ),
    color: background,
  ),
  child: MaterialButton(
    onPressed: function,
    child: Text(
      isUpperCase ? text.toUpperCase() : text,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),

  ),
);

Widget defaultTextButton({
  required void Function()? function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(text.toUpperCase()),
    );


Widget buildListProduct(
    model,
    context, {
      bool isOldPrice = true,
    }) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 120.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children:[
                      Image(
                        image: NetworkImage(model.image!),
                        width: 120.0,
                        height: 120.0,
                      ),
                      if(model.discount != 0 && isOldPrice)
                        Container(
                          color: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                          child: const Text(
                            'Discount',
                            style: TextStyle(
                              fontSize: 8.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.name!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.0,
                            height: 1.3,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children:
                          [
                            Text(
                              model.price.toString(),
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: defaultColor,
                              ),
                            ),
                            const SizedBox(width: 5.0,),
                            if(model.discount != 0 && isOldPrice)
                              Text(
                                model.oldPrice.toString(),
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            const Spacer(),
                            IconButton(
                              onPressed: ()
                              {
                                ShopCubit.get(context).changeFavorites(model.id!);
                              },
                              icon: CircleAvatar(
                                radius: 15,
                                backgroundColor: ShopCubit.get(context).favorites[model.id]!
                                    ? defaultColor
                                    : Colors.grey,
                                child: const Icon(
                                  Icons.favorite_border,
                                  size: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );


