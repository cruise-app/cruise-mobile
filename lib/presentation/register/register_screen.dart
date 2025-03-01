import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/widgets/AuthSwitcherButton.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/custom_text_field.dart';
import 'package:cruise/util/shared/widgets/go_back_button.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      children: Padding(
        padding: EdgeInsets.only(
            left: context.responsive.pageLayoutHorizontalPadding,
            right: context.responsive.pageLayoutHorizontalPadding,
            bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            CustomAppBar(
              children: [
                const GoBackButton(),
                AuthSwitcherButton(
                  message: 'Sign In',
                  action: () => GoRouter.of(context)
                      .pushReplacement(AppRouter.kLoginScreen),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Set up your profile',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Create an account and enjoy the seamless ride options cruise provide.',
              style: GoogleFonts.cabin(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const Row(
              children: [
                Expanded(child: CustomTextField(hint: 'First Name')),
                SizedBox(width: 10),
                Expanded(child: CustomTextField(hint: 'Second Name')),
              ],
            ),
            // const SizedBox(height: 15),
            // const CustomTextField(hint: 'Username'),
            const SizedBox(height: 15),
            const Row(
              children: [
                Expanded(
                  child: CustomTextField(hint: 'Password', isPassword: true),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: CustomTextField(
                        hint: 'Confirm Password', isPassword: true)),
              ],
            ),
            const SizedBox(height: 15),
            const CustomTextField(hint: 'Email'),
            const SizedBox(height: 15),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: _buildDropdown(
                    'Code',
                    ['+20', '+1', '+44', '+91'],
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(child: CustomTextField(hint: 'Phone Number')),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
                width: double.infinity,
                child: _buildDropdown('Gender', ['Male', 'Female'])),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'MM',
                    List.generate(
                        12, (index) => (index + 1).toString().padLeft(2, '0')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDropdown(
                    'DD',
                    List.generate(
                        31, (index) => (index + 1).toString().padLeft(2, '0')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDropdown(
                    'YYYY',
                    List.generate(100,
                        (index) => (DateTime.now().year - index).toString()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDropdown(String hint, List<String> items) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(18),
        hint: Text(
          hint,
          style: GoogleFonts.cabin(color: MyColors.lightGrey),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {},
      ),
    ),
  );
}
