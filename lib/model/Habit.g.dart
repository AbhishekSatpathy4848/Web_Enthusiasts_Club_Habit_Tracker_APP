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
      name: fields[0] as String,
      color: fields[1] as Color,
      streakStartDate: fields[2] as DateTime,
      habitStartDate: fields[3] as DateTime,
      streaks: fields[4] as int,
      maxStreaks: fields[5] as int,
      goalDays: fields[6] as int,
      bestStreakStartDate: fields[8] as DateTime,
      completedDays: (fields[7] as List).cast<DateTime>(),
      successRate: fields[9] as int,
      progressRate: fields[10] as int,
      dailyReminderTime: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.bestStreakStartDate)
      ..writeByte(9)
      ..write(obj.successRate)
      ..writeByte(10)
      ..write(obj.progressRate)
      ..writeByte(11)
      ..write(obj.dailyReminderTime);
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
