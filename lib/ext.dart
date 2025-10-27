import 'package:eventarc/events/cloud/firestore/v1.dart';
import 'package:toxic/extensions/string.dart';

extension XDocumentEventData on DocumentEventData {
  String get documentPath => (hasValue() ? value.name : oldValue.name)
      .split("/(default)/documents/")
      .last;

  String idOf(String segment) => documentPath.nextPath(segment) ?? "";
}

extension XDocument on Document {
  Map<String, dynamic> get asMap {
    Map<String, dynamic> map = {};
    for (MapEntry<String, Value> e in fields.entries) {
      map[e.key] = e.value.dartValue;
    }

    return map;
  }
}

extension XValue on Value {
  dynamic get dartValue {
    if (hasStringValue()) return stringValue;
    if (hasIntegerValue()) return integerValue;
    if (hasDoubleValue()) return doubleValue;
    if (hasBooleanValue()) return booleanValue;
    if (hasTimestampValue()) return timestampValue;
    if (hasMapValue()) {
      Map<String, dynamic> map = {};
      for (var entry in mapValue.fields.entries) {
        map[entry.key] = entry.value.dartValue;
      }
      return map;
    }
    if (hasArrayValue()) {
      return arrayValue.values.map((v) => v.dartValue).toList();
    }
    return null;
  }
}
