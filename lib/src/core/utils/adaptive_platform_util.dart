import 'platform_util.dart';

/// Shared platform selection for adaptive Material/Cupertino widgets.
bool useAdaptiveCupertino({
  bool forceCupertino = false,
  bool forceMaterial = false,
}) {
  if (forceMaterial) return false;
  if (forceCupertino) return true;
  return PlatformUtil.isIOS || PlatformUtil.isMacOS;
}
