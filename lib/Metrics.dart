// import 'package:habit_tracker/model/Habit.dart';
// import 'package:habit_tracker/getDayDifference.dart';

// class Metrics {
//   static int getSuccessRate(Habit habit) {
//     print(habit.completedDays.length);
//     print(daysBetween(habit.habitStartDate!,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day +1)).toString());
//     return ((habit.completedDays.length /
//                 (daysBetween(
//                         habit.habitStartDate!,
//                         DateTime(DateTime.now().year, DateTime.now().month,
//                             DateTime.now().day)) +
//                     1)) *
//             100)
//         .round();
//   }

//   static int getProgressRate(Habit habit) {
//     // if(habit.completedDays.length == 1){
//     //     return ((1 / habit.goalDays) * 100).round();
//     // }

//     print(DateTime(
//         DateTime.now().year, DateTime.now().month, DateTime.now().day));
//     if (habit.completedDays.contains(DateTime(
//         DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
//       print("here");
//       return (((daysBetween(
//                           habit.habitStartDate!,
//                           DateTime(DateTime.now().year, DateTime.now().month,
//                               DateTime.now().day)) +
//                       1) /
//                   habit.goalDays) *
//               100)
//           .round();
//     }
//     print("here1");
//     return (((daysBetween(
//                     habit.habitStartDate!,
//                     DateTime(DateTime.now().year, DateTime.now().month,
//                         DateTime.now().day))) /
//                 habit.goalDays) *
//             100)
//         .round();
//   }
// }
