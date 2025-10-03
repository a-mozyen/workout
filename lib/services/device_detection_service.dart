class DeviceInfo {
  final String name;
  final String description;
  final List<String> howToUse;

  const DeviceInfo({
    required this.name,
    required this.description,
    required this.howToUse,
  });
}

class DeviceDetectionService {
  // Placeholder for real ML inference. Returns a sample device.
  DeviceInfo detectFromMockCapture() {
    return const DeviceInfo(
      name: '...Coming Soon...',
      description: '',
      howToUse: [],
    );
  }
}
