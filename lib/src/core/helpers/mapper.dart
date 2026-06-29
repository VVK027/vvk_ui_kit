/// Contract for mapping data-layer models to domain entities.
///
/// Use in repository or service layers to keep persistence/API models separate
/// from business logic types.
///
/// ```dart
/// class UserMapper implements Mapper<UserEntity> {
///   UserMapper(this.dto);
///
///   final UserDto dto;
///
///   @override
///   UserEntity toEntity() => UserEntity(
///         id: dto.id,
///         name: dto.name,
///       );
/// }
/// ```
abstract class Mapper<T> {
  /// Converts the current object to its domain [T] representation.
  T toEntity();
}
