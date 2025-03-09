import 'package:cruise/features/register/presentation/views/verification_screen.dart';
import 'package:cruise/features/register/presentation/views/widgets/register_step_one.dart';
import 'package:cruise/features/register/presentation/views/widgets/register_step_three.dart';
import 'package:cruise/features/register/presentation/views/widgets/register_step_two.dart';
import 'package:flutter/material.dart';

import 'phone_verification_screen.dart';

class RegisterFlowScreen extends StatefulWidget {
  @override
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
        title: '',
        subtitle: '',
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
        title: '',
        subtitle: '',
      ),
    ];

    return Scaffold(
      body: steps[currentStep],
    );
  }
}
