import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_time/modules/search/cubit/cubit.dart';
import 'package:shopping_time/modules/search/cubit/states.dart';
import 'package:shopping_time/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

@override
Widget build(BuildContext context)
{
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  return BlocProvider(
    create: (BuildContext context) => SearchCubit(),
    child: BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state){
      },
      builder: (context, state){
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children:
                [
                  defaultFormField(
                    controller: searchController,
                    type: TextInputType.text,
                    validate: (String? value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'enter text to search';
                      }
                      return null;
                    },
                    onSubmit: (String text)
                    {
                      SearchCubit.get(context).search(text);
                    },
                    label: 'Search',
                    prefix: Icons.search,
                  ),
                  const SizedBox(height: 10.0,),
                  if(state is SearchLoadingState)
                    LinearProgressIndicator(),
                  if(state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) => buildListProduct(
                          SearchCubit.get(context).model!.data!.data![index],
                          context,
                          isOldPrice: false,
                        ),
                        separatorBuilder: (context, index) => myDivider(),
                        itemCount: SearchCubit.get(context).model!.data!.data!.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}