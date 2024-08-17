import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_time/layout/shop_cubit/shop_cubit.dart';
import 'package:shopping_time/layout/shop_cubit/shop_state.dart';
import 'package:shopping_time/modules/search/search_screen.dart';
import 'package:shopping_time/shared/components/components.dart';

class ShopLayout extends StatelessWidget
{
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state){},
      builder: (context, state)
      {
        var cubit = ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
                'Shopping Cart'
            ),
            actions:
            [
              IconButton(
                  onPressed: ()
                  {
                    navigateTo(context, const SearchScreen());
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
              ),
            ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index)
            {
              cubit.changeBottom(index);
            },
            currentIndex: cubit.currentIndex,
            items:
            const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons. apps,
                ),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons. favorite,
                ),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons. settings,
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
