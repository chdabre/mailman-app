import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class FCMDeviceEntity extends Equatable {
  static const String _fieldName = 'name';
  static const String _fieldRegistrationId = 'registration_id';
  static const String _fieldDeviceId = 'device_id';
  static const String _fieldActive = 'active';
  static const String _fieldType = 'type';

  final String? name;
  final String? registrationId;
  final String? deviceId;
  final bool? active;
  final String? type;

  const FCMDeviceEntity({
    this.name,
    this.registrationId,
    this.deviceId,
    this.active,
    this.type,
  });

  static FCMDeviceEntity fromJson(Map<String, dynamic> json) =>
      FCMDeviceEntity(
        name: json[_fieldName],
        registrationId: json[_fieldRegistrationId],
        deviceId: json[_fieldDeviceId],
        active: json[_fieldActive],
        type: json[_fieldType],
      );

  Map<String, dynamic> toJson() => {
    if (name != null) _fieldName: name,
    if (registrationId != null) _fieldRegistrationId: registrationId,
    if (deviceId != null) _fieldDeviceId: deviceId,
    if (active != null) _fieldActive: active,
    if (type != null) _fieldType: type,
  };

  @override
  List<Object?> get props => [
    registrationId,
  ];
}