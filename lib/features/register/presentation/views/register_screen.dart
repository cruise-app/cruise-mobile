import 'package:cruise/features/register/data/services/register_service.dart';
import 'package:cruise/features/register/domain/repo/register_repo.dart';
import 'package:cruise/features/register/domain/usecases/register_usecase.dart';
import 'package:cruise/features/register/domain/usecases/verification_usecase.dart';
import 'package:cruise/features/register/presentation/manager/register_bloc.dart';
import 'package:cruise/util/responsive_manager/responsive_init.dart';
import 'package:cruise/util/shared/api_service.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:cruise/util/shared/widgets/AuthSwitcherButton.dart';
import 'package:cruise/util/shared/widgets/custom_appbar.dart';
import 'package:cruise/util/shared/widgets/custom_text_field.dart';
import 'package:cruise/util/shared/widgets/go_back_button.dart';
import 'package:cruise/util/shared/widgets/page_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController firstNameController;
  late final TextEditingController secondNameController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  String? selectedGender;
  String? selectedCountryCode = "+20";
  String? selectedMonth;
  String? selectedDay;
  String? selectedYear;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    secondNameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    if (firstNameController.text.trim().isEmpty ||
        secondNameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        selectedGender == null ||
        selectedMonth == null ||
        selectedDay == null ||
        selectedYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    context.read<RegisterBloc>().add(RegisterSubmitted(
          firstName: firstNameController.text.trim(),
          lastName: secondNameController.text.trim(),
          password: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: "$selectedCountryCode${phoneController.text.trim()}",
          gender: selectedGender!,
          year: selectedYear!,
          month: selectedMonth!,
          day: selectedDay!,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      children: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.responsive.pageLayoutHorizontalPadding,
            vertical: 18),
        child: BlocProvider(
          create: (context) => RegisterBloc(
              RegisterUsecase(RegisterRepo(RegisterService(ApiService(Dio())))),
              VerificationUsecase(RegisterService(ApiService(Dio())))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                      child: CustomTextField(
                    hint: 'First Name',
                    controller: firstNameController,
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: CustomTextField(
                    hint: 'Second Name',
                    controller: secondNameController,
                  )),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hint: 'Password',
                      controller: passwordController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: CustomTextField(
                    hint: 'Confirm Password',
                    controller: confirmPasswordController,
                  )),
                ],
              ),
              const SizedBox(height: 15),
              CustomTextField(hint: 'Email', controller: emailController),
              const SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: _buildDropdown(
                      hint: 'Code',
                      items: ['+20', '+1', '+44', '+91'],
                      value: selectedCountryCode,
                      onChanged: (value) => setState(() {
                        selectedCountryCode = value;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: CustomTextField(
                    hint: 'Phone Number',
                    controller: phoneController,
                  )),
                ],
              ),
              const SizedBox(height: 15),
              _buildDropdown(
                hint: 'Gender',
                items: ['Male', 'Female'],
                value: selectedGender,
                onChanged: (value) => setState(() {
                  selectedGender = value;
                }),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      hint: 'MM',
                      items: List.generate(12,
                          (index) => (index + 1).toString().padLeft(2, '0')),
                      value: selectedMonth,
                      onChanged: (value) => setState(() {
                        selectedMonth = value;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildDropdown(
                      hint: 'DD',
                      items: List.generate(31,
                          (index) => (index + 1).toString().padLeft(2, '0')),
                      value: selectedDay,
                      onChanged: (value) => setState(() {
                        selectedDay = value;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildDropdown(
                      hint: 'YYYY',
                      items: List.generate(100,
                          (index) => (DateTime.now().year - index).toString()),
                      value: selectedYear,
                      onChanged: (value) => setState(() {
                        selectedYear = value;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Spacer(),
              // FlutterPwValidator(
              //   width: 200,
              //   height: 80,
              //   minLength: 8,
              //   onSuccess: () {},
              //   controller: passwordController,
              // ),
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (state is RegisterLoadingState)
                            ? Colors.grey
                            : Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => {
                        _register(context),
                        GoRouter.of(context)
                            .push(AppRouter.kRegisterVerificationScreen)
                      },
                      child: Text(
                        (state is RegisterLoadingState)
                            ? 'Loading...'
                            : 'Sign Up',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                if (state is RegisterFailureState) {
                  print(state.message);
                }
                if (state is RegisterSuccessState) {
                  print(state.message);
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    String? value,
    required ValueChanged<String?> onChanged,
  }) {
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
          hint: Text(hint, style: GoogleFonts.cabin(color: MyColors.lightGrey)),
          value: value,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
