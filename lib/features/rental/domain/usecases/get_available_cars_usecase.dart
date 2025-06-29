import 'package:cruise/features/rental/data/services/rental_services.dart';
import 'package:cruise/util/shared/failure_model.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/car_model.dart';

class GetAvailableCarsUsecase {
  final RentalService _rentalService;

  GetAvailableCarsUsecase() : _rentalService = RentalService();

  Future<Either<Failure, List<CarModel>>> call(
      Map<String, dynamic> query) async {
    return _rentalService.getAvailableCars(query);
  }
} 