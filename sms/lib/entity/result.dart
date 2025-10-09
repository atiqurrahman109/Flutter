class Result {
  final int id;
  final String subject;
  final int marks;
  final String grade;

  Result({
    required this.id,
    required this.subject,
    required this.marks,
    required this.grade,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'],
      subject: json['subject'],
      marks: json['marks'],
      grade: json['grade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'marks': marks,
      'grade': grade,
    };
  }
}
