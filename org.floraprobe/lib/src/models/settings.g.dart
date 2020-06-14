// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsBoxAdapter extends TypeAdapter<SettingsBox> {
  @override
  final typeId = 1;

  @override
  SettingsBox read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsBox(
      fields[1] as ResolutionPreset,
      fields[2] as double,
      fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsBox obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj._cameraResolution)
      ..writeByte(2)
      ..write(obj._modelThreshold)
      ..writeByte(3)
      ..write(obj._saveHistory);
  }
}
