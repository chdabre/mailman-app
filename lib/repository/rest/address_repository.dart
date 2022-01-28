import 'package:logging/logging.dart';
import 'package:mailman/entity/address_entity.dart';
import 'package:mailman/model/address.dart';
import 'package:mailman/repository/rest/api_client.dart';
import 'package:mailman/repository/address_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AddressRestRepository extends AddressRepository {
  final Logger _log = Logger('AddressRepository');
  final ApiClient _client;

  AddressRestRepository(this._client);

  @override
  Future<List<Address>> list() async {
    try {
      Map<String, dynamic> params = {
      };

      _log.info('Retrieving Address list');

      var response = await _client.get('/api/v1/address/',
        queryParameters: params,
      );

      _log.info('Received Address list $response');

      return (response['data'] ?? [])
          .map<Address>(
            (el) => Address.fromEntity(AddressEntity.fromJson(el)),
          ).toList();
    } on IOError catch (error, stacktrace) {
      _log.severe("Failed listing Addresses", error, stacktrace);

      await Sentry.captureException(
        error,
        stackTrace: stacktrace,
      );

      return [];
    }
  }

  @override
  Future<Address?> get({required int id,}) async {
    try {
      Map<String, dynamic> params = {
      };

      _log.info('Retrieving Address with id $id');

      var response = await _client.get('/api/v1/address/$id/',
        queryParameters: params,
      );

      _log.info('Received Address $response');

      return Address.fromEntity(
          AddressEntity.fromJson(response)
      );
    } on IOError catch (error, stacktrace) {
      _log.warning('Failed to retrieve Address', error, stacktrace);

      await Sentry.captureException(
        error,
        stackTrace: stacktrace,
      );

    }
  }

  @override
  Future<Address?> create({ required Address address}) async {
    try {
      var entity = address.toEntity();
      var requestData = entity.toJson();
      _log.info('Creating new Address with request data $requestData');

      var response = await _client.post('/api/v1/address/',
        data: requestData,
      );

      _log.info('Created Address $response');

      return Address.fromEntity(
          AddressEntity.fromJson(response)
      );
    } on IOError catch (error, stacktrace) {
      _log.warning('Failed to create Address', error, stacktrace);

      await Sentry.captureException(
        error,
        stackTrace: stacktrace,
      );
    }
  }

  @override
  Future<void> delete({ required Address address}) async {
    try {
      var entity = address.toEntity();
      _log.info('Deleting Address with id ${entity.id}');

      var response = await _client.delete('/api/v1/address/${entity.id!}/',);

      _log.info('Deleted Address $response');

    } on IOError catch (error, stacktrace) {
      _log.warning('Failed to delete Address (${error.code} | ${error.message} | ${error.data})', error, stacktrace);
    }
  }

  @override
  Future<Address?> setPrimary({required Address address}) async {
    try {
      var entity = address.toEntity();
      _log.info('Setting Address ${entity.id} to primary address');

      var response = await _client.post('/api/v1/address/${entity.id}/set_primary/',);

      _log.info('Updated Address $response');

      return Address.fromEntity(
          AddressEntity.fromJson(response)
      );
    } on IOError catch (error, stacktrace) {
      _log.warning('Failed to update Address', error, stacktrace);

      await Sentry.captureException(
        error,
        stackTrace: stacktrace,
      );
    }
  }
}

