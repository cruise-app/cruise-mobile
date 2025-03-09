import 'package:cruise/features/register/presentation/manager/register_bloc.dart';
import 'package:cruise/features/register/presentation/views/verification_screen.dart';
import 'package:cruise/features/register/presentation/views/widgets/action_button.dart';
import 'package:cruise/features/register/presentation/views/widgets/verification_widget.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/custom_text_field.dart';
import 'package:cruise/util/shared/widgets/go_back_button.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterStepThree extends StatefulWidget {
  const RegisterStepThree({super.key});

  @override
  _RegisterStepThreeState createState() => _RegisterStepThreeState();
}

class _RegisterStepThreeState extends State<RegisterStepThree> {
  final TextEditingController phoneController = TextEditingController();
  String? selectedCountryCode = "+20";

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      children: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.responsive.pageLayoutHorizontalPadding,
            vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: _buildDropdown(
                    hint: 'Code',
                    items: ['+20', '+1', '+44', '+91'],
                    value: selectedCountryCode,
                    onChanged: (value) =>
                        setState(() => selectedCountryCode = value),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: CustomTextField(
                        hint: 'Phone Number', controller: phoneController)),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RegisterActionButton(
                  action: () => Navigator.pop(context),
                  message: "Back",
                  color: Colors.grey,
                  size: MediaQuery.of(context).size.width * 0.4,
                ),
                RegisterActionButton(
                  action: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerificationScreen(
                        title: 'Phone Verification',
                        subtitle:
                            'We have sent a verification code to your phone. Please enter the code below',
                        onComplete: () {
                          BlocProvider.of<RegisterBloc>(context).add(
                            RegisterSubmitted(
                                firstName: 'd',
                                lastName: 'lastName',
                                password: 'password',
                                confirmPassword: 'confirmPassword',
                                email: 'email',
                                phoneNumber: 'phoneNumber',
                                gender: 'gender',
                                month: 'month',
                                day: 'day',
                                year: 'year'),
                          );
                        },
                      ),
                    ),
                  ),
                  message: 'Verify',
                  size: MediaQuery.of(context).size.width * 0.4,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildDropdown(
    {required String hint,
    required List<String> items,
    String? value,
    required ValueChanged<String?> onChanged}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(18),
        hint: Text(hint, style: GoogleFonts.cabin(color: MyColors.lightGrey)),
        value: value,
        items: items
            .map((String value) =>
                DropdownMenuItem<String>(value: value, child: Text(value)))
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}
