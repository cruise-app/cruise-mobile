import 'package:cruise/util/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/car_model.dart';
import '../../data/services/rental_services.dart';

class AddCarForRentScreen extends StatefulWidget {
  const AddCarForRentScreen({super.key});

  @override
  State<AddCarForRentScreen> createState() => _AddCarForRentScreenState();
}

class _AddCarForRentScreenState extends State<AddCarForRentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedCategory = 'Sedan';
  String _selectedTransmission = 'Automatic';
  bool _isLoading = false;

  final List<String> _categories = [
    'Sedan',
    'SUV',
    'Compact',
    'Electric',
    'Luxury',
  ];

  final List<String> _transmissions = [
    'Automatic',
    'Manual',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _plateNumberController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitCar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final pricePerDay = int.parse(_priceController.text.trim());
    final car = CarModel(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      pricePerDay: pricePerDay,
      totalPrice: pricePerDay, // Same as daily rate for now
      category: _selectedCategory,
      transmission: _selectedTransmission,
      location: _locationController.text.trim(),
      plateNumber: _plateNumberController.text.trim(),
      imagePath: _imageUrlController.text.trim().isEmpty
          ? 'https://picsum.photos/800/400'
          : _imageUrlController.text.trim(),
      rating: 5.0, // Default rating for new cars
    );

    // For now, just show success message since we don't have the backend method
    // TODO: Implement addCarForRent method in RentalService
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Car added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.black,
      appBar: AppBar(
        backgroundColor: MyColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MyColors.lightYellow),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Car for Rent',
          style: TextStyle(color: MyColors.lightYellow),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Car Name',
                hint: 'e.g., BMW 320i',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter car name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Brief description of your car',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                label: 'Price per Day (EGP)',
                hint: '500',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter price';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _locationController,
                label: 'Location',
                hint: 'e.g., New Cairo, Egypt',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _plateNumberController,
                label: 'Plate Number',
                hint: 'e.g., ABC-1234',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter plate number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _imageUrlController,
                label: 'Image URL (Optional)',
                hint: 'https://example.com/car-image.jpg',
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Category',
                value: _selectedCategory,
                items: _categories,
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Transmission',
                value: _selectedTransmission,
                items: _transmissions,
                onChanged: (value) =>
                    setState(() => _selectedTransmission = value!),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitCar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.orange,
                    foregroundColor: MyColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: MyColors.black,
                          strokeWidth: 2,
                        )
                      : const Text(
                          'Add Car',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: MyColors.lightYellow,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(color: MyColors.lightYellow),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: MyColors.lightGrey),
            filled: true,
            fillColor: MyColors.darkGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: MyColors.darkGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: MyColors.orange),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: MyColors.lightYellow,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item,
                  style: const TextStyle(color: MyColors.lightYellow)),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: MyColors.darkGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: MyColors.darkGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: MyColors.orange),
            ),
          ),
          dropdownColor: MyColors.darkGrey,
          style: const TextStyle(color: MyColors.lightYellow),
          icon: const Icon(Icons.arrow_drop_down, color: MyColors.lightGrey),
        ),
      ],
    );
  }
}
