import 'package:flutter/material.dart';
import 'package:shopping_time/modules/login/shop_login.dart';
import 'package:shopping_time/shared/components/components.dart';
import 'package:shopping_time/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../shared/styles/colors.dart';

class BoardingModel
{
  late final String image;
  late final String title;
  late final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget
{
  const OnBoardingScreen({super.key});


  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding =
  [
    BoardingModel(
        image: 'lib/assets/images/onboard_1.png',
        title: 'On Board 1 title',
        body: 'On Board 1 Body',
    ),
    BoardingModel(
      image: 'lib/assets/images/onboard_1.png',
      title: 'On Board 2 title',
      body: 'On Board 2 Body',
    ),
    BoardingModel(
    image: 'lib/assets/images/onboard_1.png',
    title: 'On Board 3 title',
    body: 'On Board 3 Body',
  ),
  ];

  bool isLast = false;

  void submit()
  {
    CacheHelper.saveData(
        key: 'onBoarding',
        value: true,
    ).then((value)
    {
      if(value != null)
      {
        navigateAndFinish(
          context,
          ShopLoginScreen(),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: 
        [
          defaultTextButton(
            function: submit,
            text: 'Skip',
          ),
        ],
      ),
      body:  Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children:
          [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: boardController,
                onPageChanged: (int index)
                {
                  if(index == boarding.length - 1)
                  {
                    setState(()
                    {
                      isLast = true;
                    });
                  } else
                  {
                    setState(()
                    {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) => buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
               ),
            ),
            const SizedBox(height: 40.0,),
            Row(
              children:
              [
                SmoothPageIndicator(
                    controller: boardController,
                    effect: const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: defaultColor,
                      dotHeight: 10.0,
                      expansionFactor: 4,
                      dotWidth: 10.0,
                      spacing: 5,
                    ),
                    count: boarding.length,
                ),
                const Spacer(),
                FloatingActionButton(
                    onPressed: ()
                    {
                      if(isLast)
                        {
                          submit();
                        }else
                        {
                          boardController.nextPage(
                            duration: const Duration(
                              milliseconds: 750,
                            ),
                            curve: Curves.fastLinearToSlowEaseIn,
                          );
                        }
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                    ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) =>  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:
    [
      Expanded(
        child: Image(
          image: AssetImage(model.image),
        ),
      ),
      const SizedBox(height: 30.0),
      Text(
        model.title,
        style: const TextStyle(
          fontSize: 24.0,
        ),
      ),
      const SizedBox(height: 15.0,),
      Text(
        model.body,
        style: const TextStyle(
          fontSize: 14.0,
        ),
      ),
      const SizedBox(height: 30.0),

    ],
  );
}
