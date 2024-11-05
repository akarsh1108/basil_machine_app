import 'package:get/get.dart';

class MenuControllers extends GetxController {
  var selectedRoute = '/home'.obs; // Reactive route

  @override
  void onInit() {
    super.onInit();
    // Listen to route changes
    ever(selectedRoute, (String route) {
      Get.offNamed(route);
    });

    // // Observer for route changes, to handle back navigation and sync selectedRoute
    // Get.routing.listen((routing) {
    //   selectedRoute.value = routing.current ?? '/home'; // Update on route change
    // });
  }

  void updateRoute(String route) {
    selectedRoute.value = route;
  }
}
