import 'package:cruise/features/register/presentation/views/widgets/action_button.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/widgets.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/custom_text_field.dart';
import 'package:cruise/util/shared/widgets/go_back_button.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterStepOne extends StatefulWidget {
  final VoidCallback onNext;
  const RegisterStepOne({required this.onNext, super.key});

  @override
  _RegisterStepOneState createState() => _RegisterStepOneState();
}

class _RegisterStepOneState extends State<RegisterStepOne> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  String? selectedGender;
  String? selectedMonth, selectedDay, selectedYear;

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
            const CustomAppBar(children: [GoBackButton()]),
            const SizedBox(height: 20),
            Text('Set up your profile',
                style: GoogleFonts.poppins(
                    fontSize: 28, fontWeight: FontWeight.w600)),
            const SizedBox(height: 30),
            CustomTextField(
                hint: 'First Name', controller: firstNameController),
            const SizedBox(height: 20),
            CustomTextField(
                hint: 'Second Name', controller: secondNameController),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: _buildDropdown(
                hint: 'Gender',
                items: ['Male', 'Female'],
                value: selectedGender,
                onChanged: (value) => setState(() => selectedGender = value),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                    child: _buildDropdown(
                        hint: 'MM',
                        items: List.generate(12, (i) => (i + 1).toString()),
                        value: selectedMonth,
                        onChanged: (value) =>
                            setState(() => selectedMonth = value))),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildDropdown(
                        hint: 'DD',
                        items: List.generate(31, (i) => (i + 1).toString()),
                        value: selectedDay,
                        onChanged: (value) =>
                            setState(() => selectedDay = value))),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildDropdown(
                        hint: 'YYYY',
                        items: List.generate(
                            100, (i) => (DateTime.now().year - i).toString()),
                        value: selectedYear,
                        onChanged: (value) =>
                            setState(() => selectedYear = value))),
              ],
            ),
            const SizedBox(height: 30),
            RegisterActionButton(message: 'Next', action: widget.onNext)
          ],
        ),
      ),
    );
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
}
