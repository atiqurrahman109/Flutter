
import 'package:sms/entity/schoolclass.dart';
import 'package:sms/entity/teacher.dart';

class Routines {
  int id;
  String dayOfWeek;
  String startTime;
  String endTime;
  SchoolClass schoolClass;
  Teacher teacher;
  SchoolClass section;
  String subject;

  Routines({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.schoolClass,
    required this.teacher,
    required this.section,
    required this.subject,
  });

}




