import 'setup_core.dart';
import 'setup_repository.dart';
// import 'setup_usecases.dart';
// import 'setup_controllers.dart';
import 'setup_services.dart';

Future<void> setupServiceLocator() async {
  // Core Services
  await setupCore();

  // Repositories
  await setupRepository();

  // Use Cases
  // setupUsecases();

  // Controllers
  // await setupControllers();

  // Services
  await setupServices();
}
