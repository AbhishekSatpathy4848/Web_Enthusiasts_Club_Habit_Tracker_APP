// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      fields[0] as String,
      fields[1] as Color,
      fields[2] as DateTime,
      fields[3] as DateTime,
      fields[4] as int,
      fields[5] as int,
      fields[6] as int,
      (fields[7] as List).cast<DateTime>(),
      fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.streakStartDate)
      ..writeByte(3)
      ..write(obj.habitStartDate)
      ..writeByte(4)
      ..write(obj.streaks)
      ..writeByte(5)
      ..write(obj.maxStreaks)
      ..writeByte(6)
      ..write(obj.goalDays)
      ..writeByte(7)
      ..write(obj.completedDays)
      ..writeByte(8)
      ..write(obj.bestStreakStartDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
