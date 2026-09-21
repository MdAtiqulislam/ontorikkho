import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../app/modules/forYou/models/posts_model.dart';
import '../app/modules/subscription/controllers/subscriprtion_controller.dart';
import '../constraints/api_end_points.dart';
import '../utils/util.dart';
import 'local_services.dart';

class RemoteServices {
  static final http.Client client = http.Client();
  static String baseURL = APIEndPoints.baseURL;
  static String token = "";

  static Future<Map<String, String>> _getHeaders({bool isJson = false}) async {
    token = await LocalServices.getToken() ?? "";
    final headers = {"Authorization": "Bearer $token"};
    if (isJson) {
      headers["Content-Type"] = "application/json";
      headers["Access-Control-Allow-Origin"] = "*";
    }
    return headers;
  }

  static Uri _buildUri(String endpoint, [Map<String, dynamic>? params]) {
    return Uri.parse(baseURL + endpoint).replace(queryParameters: params);
  }

  static void _logRequest(String method, Uri uri, [dynamic body]) {
    if (kDebugMode) {
      print("$method Request URL: $uri");
      print("$method Request Token: $token");
      if (body != null) print("Request Body: $body");
    }
  }

  static Future<dynamic> postRequest({
    required String endpoint,
    Map<dynamic, dynamic>? body,
    Map<String, dynamic>? parameters,
  })
  async {
    final uri = _buildUri(endpoint, parameters);
    final headers = await _getHeaders();
    _logRequest("POST", uri, body);

    try {
      final response = await http.post(uri, body: body, headers: headers);


      print(response.body);
      print(response.statusCode);


      return handleResponse(response);
    } catch (e) {
      _handleError("POST", e);
      return null;
    }
  }

  static Future<dynamic> postRequestWithJsonData({
    required String endpoint,
    Map<dynamic, dynamic>? body,
    Map<String, dynamic>? parameters,
  })
  async {
    final uri = _buildUri(endpoint, parameters);
    final headers = await _getHeaders(isJson: true);
    _logRequest("POST", uri, body);

    try {
      final response = await http.post(
        uri,
        body: json.encode(body),
        headers: headers,
        encoding: Encoding.getByName("utf-8"),
      );
      return handleResponse(response);
    } catch (e) {
      _handleError("POST (JSON)", e);
      return null;
    }
  }

  static Future<dynamic> putRequest({
    required String endpoint,
    Map<dynamic, dynamic>? body,
  })
  async {
    final uri = _buildUri(endpoint);
    final headers = await _getHeaders();
    _logRequest("PUT", uri, body);

    try {
      final response = await http.put(uri, body: body, headers: headers);
      return handleResponse(response);
    } catch (e) {
      _handleError("PUT", e);
      return null;
    }
  }

  static Future<dynamic> putRequestWithJson({
    required String endpoint,
    Map<dynamic, dynamic>? body,
    Map<String, dynamic>? parameters,
  })
  async {
    final uri = _buildUri(endpoint, parameters);
    final headers = await _getHeaders(isJson: true);
    _logRequest("PUT (JSON)", uri, body);

    try {
      final response = await http.put(
        uri,
        body: json.encode(body),
        headers: headers,
        encoding: Encoding.getByName("utf-8"),
      );
      return handleResponse(response);
    } catch (e) {
      _handleError("PUT (JSON)", e);
      return null;
    }
  }

  static Future<dynamic> patchRequest({
    required String endpoint,
    Map<dynamic, dynamic>? body,
  })
  async {
    final uri = _buildUri(endpoint);
    final headers = await _getHeaders();
    _logRequest("PATCH", uri);

    try {
      final response = await http.patch(uri, body: body, headers: headers);
      return handleResponse(response);
    } catch (e) {
      _handleError("PATCH", e);
      return null;
    }
  }

  static Future<dynamic> deleteRequest({
    required String endpoint,
    Map<dynamic, dynamic>? body,
  })
  async {
    final uri = _buildUri(endpoint);
    final headers = await _getHeaders();
    _logRequest("DELETE", uri);

    try {
      final response = await http.delete(uri, body: body, headers: headers);
      return handleResponse(response);
    } catch (e) {
      _handleError("DELETE", e);
      return null;
    }
  }

  static Future<dynamic> getRequest({
    required String endpoint,
    Map<String, dynamic>? parameters,
  })
  async {
    final uri = _buildUri(endpoint, parameters);
    final headers = await _getHeaders();
    _logRequest("GET", uri);

    try {
      final response = await client.get(uri, headers: headers);
      return handleResponse(response);
    } catch (e) {
      _handleError("GET", e);
      return null;
    }
  }

  static Future<dynamic> getRequestLoadMore({
    required String url,
    Map<String, dynamic>? parameters,
  })
  async {
    final uri = Uri.parse(url).replace(queryParameters: parameters);
    final headers = await _getHeaders();
    _logRequest("GET (LoadMore)", uri);

    try {
      final response = await client.get(uri, headers: headers);
      return handleResponse(response);
    } catch (e) {
      _handleError("GET (LoadMore)", e);
      return null;
    }
  }

  static Future<dynamic> postWithImages({
    required List<File> images,
    required String endpoint,
    String? key,
    Map<String, String>? body,
  })
  async {
    final uri = _buildUri(endpoint);
    try {
      final request = http.MultipartRequest('POST', uri)
        ..headers["access-key"] = key ?? "0a93e525aa73df8b5ef676fe7d1d49c5aisdu98sa7d"
        ..fields.addAll(body ?? {});

      for (final image in images) {
        final stream = http.ByteStream(image.openRead());
        final length = await image.length();
        final multipartFile = http.MultipartFile('file[]', stream, length,
            filename: image.path.split('/').last);
        request.files.add(multipartFile);
      }

      final response = await http.Response.fromStream(await request.send());
      return handleResponse(response);
    } catch (e) {
      _handleError("Upload Images", e);
      return null;
    }
  }


  /// User registration method with form fields and multiple files
  static Future<dynamic> userSubscription({
    required Map<String, String> formData,
    required Map<String, File?> files,
    required String endpoint ,
    required List<HealthCondition> healthConditions,
  })
  async {
    // API endpoint for registration
    try {
      final uri =Uri.parse( baseURL+endpoint);

      // Prepare multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add auth headers
      final headers = await _getHeaders();
      request.headers.addAll(headers);

      for (var condition in healthConditions) {
        request.fields['health_conditions[]'] = condition.key;
      }

      // Add form data fields
      request.fields.addAll(formData);

      // Add files, skip if file is null
      for (final entry in files.entries) {
        final fieldName = entry.key; // e.g. "nid", "profile", "tin", "cv"
        final file = entry.value;
        if (file != null && await file.exists()) {
          final multipartFile = await http.MultipartFile.fromPath(fieldName, file.path);
          request.files.add(multipartFile);
        }
      }

      // Send request
      final streamedResponse = await request.send();

      // Convert streamed response to http.Response
      final response = await http.Response.fromStream(streamedResponse);

      print(endpoint);
      print(response.body.toString());


      // Handle response as usual
      return handleResponse(response);

    } catch (e) {
      _handleError("User Registration", e);
      return null;
    }
  }

  static Future<dynamic> postWithMultipleImages({
    required String endpoint,
    required String requestType,
    Map<String, String>? body,
    Map<String, String>? parameters,
    Map<String, String>? files,
  }) async {
    final uri = _buildUri(endpoint, parameters);
    final headers = await _getHeaders();

    _logRequest("Multipart", uri, body);

    try {
      final request = http.MultipartRequest(requestType, uri);

      request.headers.addAll(headers);

      if (body != null) {
        request.fields.addAll(body);
      }

      if (files != null) {
        for (final entry in files.entries) {
          if (entry.value.isNotEmpty) {
            request.files.add(
              await http.MultipartFile.fromPath(
                entry.key,
                entry.value,
              ),
            );
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return handleResponse(response);
    } catch (e) {
      _handleError("Multipart Request", e);
      return null;
    }
  }

  static Future<dynamic> multipartRequest({
    required String filePath,
    required String fieldName,
    required String endpoint,
    required String requestType,
    Map<String, String>? body,
    Map<String, String>? parameters,
  })
  async {
    final uri = _buildUri(endpoint, parameters);
    final headers = await _getHeaders();
    _logRequest("Multipart", uri, body);

    try {
      final request = http.MultipartRequest(requestType, uri)
        ..headers.addAll(headers)
        ..fields.addAll(body ?? {});

      if (filePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));
      }

      final response = await http.Response.fromStream(await request.send());
      return handleResponse(response);
    } catch (e) {
      _handleError("Multipart Request", e);
      return null;
    }
  }


  /// Upload multiple missing documents with parallel arrays:
  /// document_id[] and files[]
  static Future<dynamic> missingDocumentUpload({
    required List<int> documentIds,
    required List<File> files,
    required String endpoint,
  })
  async {
    final uri = _buildUri(endpoint);
    final headers = await _getHeaders();
    _logRequest("POST (MissingDocs)", uri);

    try {
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers);

      // Add each file and corresponding document ID
      for (int i = 0; i < documentIds.length; i++) {
        final docId = documentIds[i];
        final file = files[i];
        request.fields['document_ids[$i]'] = docId.toString();
        request.files.add(
          await http.MultipartFile.fromPath(
            'files[$i]',
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print("MissingDocs Upload Response: ${response.statusCode}");
        print(response.body);
      }

      return handleResponse(response);
    } catch (e) {
      _handleError("Missing Document Upload", e);
      return null;
    }
  }



  static Future<dynamic> createPostMultipart({
    required String endpoint,
    required String content,
    required String associationId,
    required String youtubeLink,
    required List<File> mediaFiles,
    String? pageId
  })
  async {
    final uri = _buildUri(endpoint);
    final headers = await _getHeaders();

    print(uri);
    try {
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..fields['content'] = content
        ..fields['association_id'] = associationId
        ..fields['youtube_link'] = youtubeLink
        ..fields['page_id'] = pageId??"";

      for (int i = 0; i < mediaFiles.length; i++) {
        final file = mediaFiles[i];
        request.files.add(
          await http.MultipartFile.fromPath(
            'media[$i]', // or 'media[]' if backend expects array
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print("CreatePost Status: ${response.statusCode}");
        print(response.body);
      }

      return handleResponse(response);
    } catch (e) {
      _handleError("Create Post", e);
      return null;
    }
  }



  // RemoteServices class er moddhe
  static Future<dynamic> updatePostMultipart({
    required String endpoint,
    required String postId,
    required String content,
    required String associationId,
    required String youtubeLink,
    List<Media>? existingMedia,
    List<String>? removeMediaIds,
    List<File>? newMediaFiles,
    String? privacy,
    bool? isLive,
    String? pageId,
    bool? removeAllMedia,
    String? otherLink,
  }) async {
    final uri = _buildUri(endpoint);
    final headers = await _getHeaders();

    try {
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..fields['id'] = postId
        ..fields['content'] = content
        ..fields['association_id'] = associationId
        ..fields['youtube_link'] = youtubeLink;
       // ..fields['privacy'] = privacy ?? 'public'
        //..fields['is_live'] = (isLive ?? false).toString()
       // ..fields['page_id'] = pageId ?? ''
       // ..fields['remove_all_media'] = (removeAllMedia ?? false).toString();

      if (otherLink != null) {
        request.fields['other_link'] = otherLink;
      }

      // Existing media IDs
      if (existingMedia != null && existingMedia.isNotEmpty) {
        final existingIds = existingMedia.map((m) => m.id).whereType<int>().toList();
        for (int i = 0; i < existingIds.length; i++) {
          request.fields['existing_media_ids[$i]'] = existingIds[i].toString();
        }
      }

      // Removed media IDs
      if (removeMediaIds != null && removeMediaIds.isNotEmpty) {
        for (int i = 0; i < removeMediaIds.length; i++) {
          request.fields['remove_media_ids[$i]'] = removeMediaIds[i];
        }
      }

      // New media files
      if (newMediaFiles != null && newMediaFiles.isNotEmpty) {
        for (int i = 0; i < newMediaFiles.length; i++) {
          final file = newMediaFiles[i];
          request.files.add(await http.MultipartFile.fromPath(
            'media[$i]',
            file.path,
            filename: file.path.split('/').last,
          ));
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print("UpdatePost Status: ${response.statusCode}");
        print(response.body);
      }

      return handleResponse(response);
    } catch (e) {
      _handleError("Update Post", e);
      return null;
    }
  }



  static dynamic handleResponse(http.Response response) {
    try {
      final dynamic data = json.decode(response.body);
      final String message = data is Map
          ? (data["msg"] ?? data["message"] ?? APIEndPoints.generalHttpErrorMSG)
          : APIEndPoints.generalHttpErrorMSG;

      // ✅ Step 1: HTTP status check (200–299)
      if (isHttpStatusSuccess(response.statusCode)) {
        // ✅ Step 2: Check if API returned failure in data
        if (data is Map) {
          final dynamic statusValue = data["status"];

          // Handle different false-like values (false, 0, "false", "error")
          final bool isApiError = statusValue == false ||
              statusValue == 0 ||
              statusValue == "false" ||
              statusValue == "error";

          if (isApiError) {
            APIEndPoints.httpErrorMSG.value = formatMessages(message);
            return null;
          }
        }

        // ✅ Step 3: Everything OK → return data
        return data;
      } else {
        // Non-200 status → HTTP level error
        APIEndPoints.httpErrorMSG.value =
            formatMessages("$message (${response.statusCode})");
        return null;
      }
    } catch (e) {
      // ✅ Step 4: Catch unexpected decode or format error
      APIEndPoints.httpErrorMSG.value = APIEndPoints.generalHttpErrorMSG;
      return null;
    }
  }


  static void _handleError(String type, Object e) {
    APIEndPoints.httpErrorMSG.value = APIEndPoints.generalHttpErrorMSG;
    if (kDebugMode) {
      print("Error in $type request: ${ e as Exception}");
    }
  }
}
