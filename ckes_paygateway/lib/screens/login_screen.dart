import 'package:ckes_paygateway/widgets/custom_text_field.dart';
import 'package:ckes_paygateway/widgets/cutom_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                 'Trust\nThe\n Way You\nPay',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 64),
              ),
              const SizedBox(height: 66),
              Text(
                'Unlock a smart way to pay. Make secure payments, with Ckes earn back cash rewards, and send money almost anywhere in the world in one place.',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15), 
              ),
            //   const Spacer(),
            //   const CustomTextField(hintText: 'Password Login'),
            //   const SizedBox(height: 16),
            //    Text(
            //     'Forgot your password?',
            //     style: Theme.of(context).textTheme.bodySmall,
            //     ),
            //     const SizedBox(height: 16),
            //   Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Center(
            //         child: SizedBox(
            //           width: 335,
            //           height: 66,
            //          child:  CustomButton(text: 'Login', onPressed: () {} ),
            //         )
            //       ),
            //     ],
            //   ), 
            //   const SizedBox(height: 16),  
             ],
          ),
        ),
      ),
    );
  }
}