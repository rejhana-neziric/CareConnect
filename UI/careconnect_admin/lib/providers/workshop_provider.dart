import 'dart:convert';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/responses/workshop.dart';
import 'package:careconnect_admin/models/responses/workshop_statistics.dart';
import 'package:careconnect_admin/models/search_objects/workshop_search_object.dart';
import 'package:careconnect_admin/models/workshopML/training_result.dart';
import 'package:careconnect_admin/models/workshopML/workshop_prediction.dart';
import 'package:careconnect_admin/providers/base_provider.dart';
import 'package:careconnect_admin/screens/workshops/participant_list_screeen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WorkshopProvider extends BaseProvider<Workshop> {
  WorkshopProvider() : super("Workshop");

  @override
  Workshop fromJson(data) {
    return Workshop.fromJson(data);
  }

  @override
  int? getId(Workshop item) {
    return item.workshopId;
  }

  Future<WorkshopStatistics> getStatistics() async {
    var url = "$baseUrl$endpoint/statistics";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      notifyListeners();

      final stats = WorkshopStatistics.fromJson(data);

      return stats;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<SearchResult<Workshop>?> loadData({
    String? fts,
    String? nameGTE,
    String? status,
    DateTime? dateGTE,
    DateTime? dateLTE,
    double? price,
    int? maxParticipants,
    int? participants,
    String? workshopType,
    int page = 0,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    final filterObject = WorkshopSearchObject(
      fts: fts,
      nameGTE: nameGTE,
      status: status,
      dateGTE: dateGTE,
      dateLTE: dateLTE,
      price: price,
      maxParticipants: maxParticipants,
      participants: participants,
      workshopType: workshopType,
      page: page,
      sortBy: sortBy,
      sortAscending: sortAscending,
      includeTotalCount: true,
      retrieveAll: true,
    );

    final filter = filterObject.toJson();

    final result = await get(filter: filter);

    notifyListeners();
    return result;
  }

  Future<WorkshopStatistics> loadStats() async {
    final statistics = await getStatistics();
    notifyListeners();
    return statistics;
  }

  Future<bool> handleWorkshopAction(
    Workshop workshop,
    String action,
    BuildContext context,
  ) async {
    switch (action) {
      case 'Publish':
        return await publishWorkshop(workshop);
      case 'Close':
        return await closeWorkshop(workshop);
      case 'Cancel':
        return await cancelWorkshop(workshop);
      case 'View Participants':
        viewWorkshopParticipants(workshop, context);
        return true;
    }
    return false;
  }

  Future<bool> publishWorkshop(Workshop workshop) async {
    var response = await changeState(workshop.workshopId, "publish");
    notifyListeners();
    return response;
  }

  Future<bool> closeWorkshop(Workshop workshop) async {
    var response = await changeState(workshop.workshopId, "close");
    notifyListeners();
    return response;
  }

  Future<bool> cancelWorkshop(Workshop workshop) async {
    var response = await changeState(workshop.workshopId, "cancel");
    notifyListeners();
    return response;
  }

  void viewWorkshopParticipants(Workshop workshop, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParticipantListScreeen(workshop: workshop),
      ),
    );
  }

  Future<bool> changeState(int id, String action) async {
    var url = "$baseUrl$endpoint/$id/$action";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var updated = fromJson(data);
      var index = item.result.indexWhere((e) => getId(e) == id);
      if (index != -1) {
        item.result[index] = updated;
        notifyListeners();
      }
      return true;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<TrainingResult> trainModel() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint/train'),
        headers: createHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return TrainingResult.fromJson(json);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to train model');
      }
    } catch (e) {
      throw Exception('Error training model: $e');
    }
  }

  Future<WorkshopPrediction> predictForNewWorkshop({
    required String name,
    required String description,
    required String workshopType,
    required DateTime date,
    required double? price,
    required int? maxParticipants,
  }) async {
    try {
      final workshopData = {
        'name': name,
        'description': description,
        'workshopType': workshopType,
        'date': date.toIso8601String(),
        'price': price,
        'maxParticipants': maxParticipants,
      };

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint/predict'),
        headers: createHeaders(),
        body: jsonEncode(workshopData),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WorkshopPrediction(
          workshopId: 0,
          workshopName: name,
          predictedParticipants: (json['predictedParticipants'] ?? 0)
              .toDouble(),
          maxParticipants: maxParticipants,
          utilizationPercentage: json['utilizationPercentage']?.toDouble(),
          recommendation: json['recommendation'],
        );
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to predict');
      }
    } catch (e) {
      throw Exception('Error predicting for new workshop: $e');
    }
  }

  Future<bool> isModelTrained() async {
    try {
      final testWorkshop = {
        'name': 'Test',
        'description': 'Test',
        'workshopType': 'Parents',
        'date': DateTime.now().add(Duration(days: 7)).toIso8601String(),
        'price': 50.0,
        'maxParticipants': 30,
        'modifiedDate': DateTime.now().toIso8601String(),
      };

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint/predict'),
        headers: createHeaders(),

        body: jsonEncode(testWorkshop),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getModelStatus() async {
    try {
      final isModelReady = await isModelTrained();

      return {
        'isTrained': isModelReady,
        'status': isModelReady ? 'Ready' : 'Not Trained',
        'message': isModelReady
            ? 'Model is trained and ready for predictions'
            : 'Model needs to be trained before making predictions',
      };
    } catch (e) {
      return {
        'isTrained': false,
        'status': 'Error',
        'message': 'Error checking model status: $e',
      };
    }
  }
}
