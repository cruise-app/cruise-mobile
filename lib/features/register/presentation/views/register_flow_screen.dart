import 'package:cruise/features/register/presentation/views/verification_screen.dart';
import 'package:cruise/features/register/presentation/views/widgets/register_step_one.dart';
import 'package:cruise/features/register/presentation/views/widgets/register_step_three.dart';
import 'package:cruise/features/register/presentation/views/widgets/register_step_two.dart';
import 'package:cruise/util/shared/app_router.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController phoneController = TextEditingController();

  void nextStep() {
    setState(() {
      currentStep++;
    });
  }

  void previousStep() {
    setState(() {
      currentStep--;
    });
  }

  void completeRegistration() {
    // Handle final submission
    print("User Data:");
    print("Name: \${firstNameController.text} \${secondNameController.text}");
    print("Gender: \$selectedGender");
    print("DOB: \$selectedMonth-\$selectedDay-\$selectedYear");
    print("Email: \${emailController.text}");
    print("Phone: \${phoneController.text}");
    GoRouter.of(context).push(AppRouter.kLoginScreen);
    // TODO: Trigger Bloc event or API call to store user data
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
        onNext: nextStep,
        onPrevious: previousStep,
      ),
      VerificationScreen(
        onPrevious: previousStep,
        onNext: nextStep,
        title: 'Verify your email',
        subtitle: 'Enter the 4-digit code sent to your email',
      ),
      RegisterStepThree(
        phoneController: phoneController,
        onNext: nextStep,
        onPrevious: previousStep,
        onSelectedCountryCodeChanged: (String? value) {},
      ),
      VerificationScreen(
        onPrevious: previousStep,
        onNext: completeRegistration,
        title: 'Verify your phone',
        subtitle: 'Enter the 4-digit code sent to your phone',
      ),
    ];

    return Scaffold(
      body: steps[currentStep],
    );
  }
}
