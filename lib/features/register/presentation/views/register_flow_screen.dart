import 'package:cruise/features/register/presentation/manager/register_bloc.dart';
import 'package:cruise/features/register/presentation/views/verification_screen.dart';
import 'package:cruise/features/register/presentation/views/widgets/register_step_one.dart';
import 'package:cruise/features/register/presentation/views/widgets/register_step_three.dart';
import 'package:cruise/features/register/presentation/views/widgets/register_step_two.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterFlowScreen extends StatefulWidget {
  const RegisterFlowScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterFlowScreenState createState() => _RegisterFlowScreenState();
}

class _RegisterFlowScreenState extends State<RegisterFlowScreen> {
  int currentStep = 0;

  // Store user input across steps
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? selectedGender;
  String? selectedMonth, selectedDay, selectedYear;
  final TextEditingController emailController = TextEditingController();
  String selectedCountryCode = '+20';
  final TextEditingController phoneController = TextEditingController();

  void nextStep() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        currentStep++;
      });
    });
  }

  void previousStep() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        currentStep--;
      });
    });
  }

  void completeRegistration(BuildContext context) {
    // Handle final submission
    print("User Data:");
    print('First Name: ${firstNameController.text}');
    print('Second Name: ${secondNameController.text}');
    print("Email: ${emailController.text}");
    print("Password: ${passwordController.text}");
    print("Phone: ${phoneController.text}");
    print("Country Code: $selectedCountryCode");
    print('Month, Day, Year: $selectedMonth, $selectedDay, $selectedYear');
    print('Gender: $selectedGender');
    context.read<RegisterBloc>().add(
          RegisterSubmitted(
              firstName: firstNameController.text.trim(),
              lastName: firstNameController.text.trim(),
              password: passwordController.text.trim(),
              confirmPassword: confirmPasswordController.text.trim(),
              email: emailController.text.trim(),
              phoneNumber: selectedCountryCode + phoneController.text.trim(),
              gender: selectedGender!,
              month: selectedMonth!,
              day: selectedDay!,
              year: selectedYear!),
        );

    GoRouter.of(context).push(AppRouter.kLoginScreen);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> steps = [
      RegisterStepOne(
        firstNameController: firstNameController,
        secondNameController: secondNameController,
        selectedGender: selectedGender,
        selectedMonth: selectedMonth,
        selectedDay: selectedDay,
        selectedYear: selectedYear,
        onGenderChanged: (value) => setState(() => selectedGender = value),
        onSelectedMonthChanged: (value) =>
            setState(() => selectedMonth = value),
        onSelectedDayChanged: (value) => setState(() => selectedDay = value),
        onSelectedYearChanged: (value) => setState(() => selectedYear = value),
        onNext: nextStep,
      ),
      RegisterStepTwo(
        emailController: emailController,
        passwordController: passwordController,
        confirmPasswordController: confirmPasswordController,
        onNext: () {
          nextStep();
        },
        onPrevious: previousStep,
      ),
      VerificationScreen(
        toVerify: emailController.text,
        onPrevious: previousStep,
        onNext: (String otp) {
          print("OTP entered: $otp"); // Debugging
          nextStep(); // Ensure step updates
        },
        title: 'Verify your email',
        subtitle: 'Enter the 4-digit code sent to your email',
      ),
      RegisterStepThree(
        selectedCountryCode: selectedCountryCode!,
        phoneController: phoneController,
        onNext: nextStep,
        onPrevious: previousStep,
        onSelectedCountryCodeChanged: (value) => setState(
          () {
            selectedCountryCode = value!;
          },
        ),
      ),
      VerificationScreen(
        toVerify: selectedCountryCode + phoneController.text,
        onPrevious: previousStep,
        onNext: (String otp) {
          // Handle OTP verification
          print("OTP: \$otp");
          print('Registration Complete');

          completeRegistration(context);
        },
        title: 'Verify your phone',
        subtitle: 'Enter the 4-digit code sent to your phone',
      ),
    ];

    return Scaffold(
      body: steps[currentStep],
    );
  }
}
