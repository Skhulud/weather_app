import 'package:flutter/material.dart';
import 'package:real_time_weather_ap/ui/Homepage.dart';

import '../models/constants.dart';


class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
            width: size.width,
            height: size.height,
            color: myConstants.primaryColor.withOpacity(.5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Image.asset('asset/c05fa71cdee42.png'),
                  const SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: '',)));
                    },
                    child: Container(
                      height: 50,
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                        color: myConstants.primaryColor,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Center(
                        child: Text('Get started', style: TextStyle(color: Colors.white, fontSize: 18),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ),
        );
    }
}