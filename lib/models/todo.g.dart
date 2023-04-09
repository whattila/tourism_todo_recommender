// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      id: json['id'] as String,
      uploaderId: json['uploaderId'] as String,
      uploaderName: json['uploaderName'] as String,
      shortDescription: json['shortDescription'] as String,
      nature: json['nature'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      detailedDescription: json['detailedDescription'] as String,
      imageReferences: (json['imageReferences'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rateStatistics: json['rateStatistics'] == null
          ? RateStatistics.empty
          : RateStatistics.fromJson(
              json['rateStatistics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TodoToJson(Todo instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'uploaderId': instance.uploaderId,
    'uploaderName': instance.uploaderName,
    'shortDescription': instance.shortDescription,
    'nature': instance.nature,
    'address': instance.address,
    'latitude': instance.latitude,
    'longitude': instance.longitude,
    'detailedDescription': instance.detailedDescription,
    'imageReferences': instance.imageReferences,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('rateStatistics', Todo._toNull(instance.rateStatistics));
  return val;
}
