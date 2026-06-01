enum EventProfileStatus {
  ativo,
  alterado,
  cancelado,
}

class ProfileEventEntry {
  const ProfileEventEntry({
    required this.eventId,
    required this.status,
  });

  final String eventId;
  final EventProfileStatus status;
}
