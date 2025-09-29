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
      name: 'Lat Pulldown Machine',
      description:
          'Targets the latissimus dorsi with adjustable weight and seated setup.',
      howToUse: [
        'Adjust thigh pad to lock legs in place.',
        'Select a manageable weight.',
        'Grip the bar wider than shoulder width.',
        'Pull bar to upper chest while keeping torso upright.',
        'Control the return to full stretch; avoid swinging.',
      ],
    );
  }
}
