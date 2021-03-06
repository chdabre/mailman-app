import 'package:logging/logging.dart';
import 'package:mailman/entity/postcard_job_entity.dart';
import 'package:mailman/model/postcard.dart';
import 'package:mailman/repository/jobs_repository.dart';
import 'package:mailman/repository/rest/api_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class JobsRestRepository extends JobsRepository {
  final Logger _log = Logger('JobsRepository');
  final ApiClient _client;

  JobsRestRepository(this._client);

  @override
  Future<Postcard?> create(Postcard postcard) async {
    try {
      var entity = postcard.toJobEntity();
      var requestData = entity.toJson();
      var requestPreview = entity.toJson();
      if (requestPreview['front_image'] != null) requestPreview['front_image'] = '<Image b64>';
      if (requestPreview['text_image'] != null) requestPreview['text_image'] = '<Image b64>';
      _log.info('Creating new Postcard Job with request data $requestPreview');

      var response = await _client.post('/api/v1/jobs/',
        data: requestData,
      );

      _log.info('Created Job $response');

      return Postcard.fromJobEntity(
          PostcardJobEntity.fromJson(response)
      );
    } on IOError catch (error, stacktrace) {
      _log.warning('Failed to create Postcard Job (${error.code} | ${error.message} | ${error.data})', error, stacktrace);

      await Sentry.captureException(
        error,
        stackTrace: stacktrace,
      );
    }
  }

  @override
  Future<Postcard?> update(Postcard postcard) async {
    try {
      var entity = postcard.toJobEntity();
      var requestData = entity.toJson();
      var requestPreview = entity.toJson();
      if (requestPreview['front_image'] != null) requestPreview['front_image'] = '<Front Image>';
      if (requestPreview['text_image'] != null) requestPreview['text_image'] = '<Text Image>';
      _log.info('Updating Postcard Job ${entity.id} with request data $requestPreview');

      var response = await _client.patch('/api/v1/jobs/${entity.id}/',
        data: requestData,
      );

      _log.info('Updated Job $response');

      return Postcard.fromJobEntity(
          PostcardJobEntity.fromJson(response)
      );
    } on IOError catch (error, stacktrace) {
      _log.warning('Failed to update Postcard Job (${error.code} | ${error.message} | ${error.data})', error, stacktrace);

      await Sentry.captureException(
        error,
        stackTrace: stacktrace,
      );
    }
  }

  @override
  Future<void> delete(Postcard postcard) async {
    try {
      var entity = postcard.toJobEntity();
      _log.info('Deleting Postcard Job with id ${entity.id}');

      var response = await _client.delete('/api/v1/jobs/${entity.id!}/',);

      _log.info('Deleted Job $response');

    } on IOError catch (error, stacktrace) {
      _log.warning('Failed to delete Postcard Job (${error.code} | ${error.message} | ${error.data})', error, stacktrace);

      await Sentry.captureException(
        error,
        stackTrace: stacktrace,
      );
    }
  }

  @override
  Future<Postcard?> get({required int id}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<Postcard>> list() async {
    try {
      Map<String, dynamic> params = {
      };

      var response = await _client.get('/api/v1/jobs/',
        queryParameters: params,
      );

      return (response['data'] ?? [])
          .map<Postcard>(
            (el) => Postcard.fromJobEntity(PostcardJobEntity.fromJson(el)),
          ).toList();
    } on IOError catch (error, stacktrace) {
      _log.severe("Failed listing Jobs", error, stacktrace);

      await Sentry.captureException(
        error,
        stackTrace: stacktrace,
      );

      return [];
    }
  }
}

