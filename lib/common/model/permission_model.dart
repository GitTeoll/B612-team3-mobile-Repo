abstract class PermissionBase {}

class PermissionLoading extends PermissionBase {}

class PermissionAccepted extends PermissionBase {}

class PermissionDenied extends PermissionBase {
  final String message;

  PermissionDenied({
    required this.message,
  });
}
