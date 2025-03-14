import 'package:cruise/features/register/presentation/manager/register_bloc.dart';
import 'package:cruise/features/register/presentation/views/widgets/action_button.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/widgets/custom_text_field.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class RegisterStepThree extends StatelessWidget {
  RegisterStepThree(
      {super.key,
      required this.onNext,
      required this.onPrevious,
      required this.phoneController,
      required this.selectedCountryCode,
      required this.onSelectedCountryCodeChanged});
  final Function onNext;
  final Function onPrevious;
  final TextEditingController phoneController;
  String selectedCountryCode;
  final ValueChanged<String?> onSelectedCountryCodeChanged;

  @override
  // ignore: library_private_types_in_public_api

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
                    onChanged: onSelectedCountryCodeChanged,
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
                  action: () {
                    onPrevious();
                  },
                  message: "Back",
                  color: Colors.grey,
                  size: MediaQuery.of(context).size.width * 0.4,
                ),
                BlocListener<RegisterBloc, RegisterState>(
                  listener: (context, state) => {
                    if (state is RegisterStepThreeStateSuccess)
                      {print("Done"), onNext()}
                    else if (state is RegisterStepThreeStateFailure)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
                        )
                      }
                  },
                  child: RegisterActionButton(
                    action: () {
                      context.read<RegisterBloc>().add(
                            RegisterStepThreeSubmitted(
                                phoneNumber: phoneController.text,
                                countryCode: selectedCountryCode),
                          );
                    },
                    message: 'Verify',
                    size: MediaQuery.of(context).size.width * 0.4,
                  ),
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
