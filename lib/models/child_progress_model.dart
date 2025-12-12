// Helper function to safely extract string ID from JSON
String _extractId(dynamic idValue) {
  if (idValue == null) return '';
  if (idValue is String) return idValue;
  if (idValue is Map) {
    if (idValue['\$oid'] != null) return idValue['\$oid'].toString();
    if (idValue['id'] != null) return idValue['id'].toString();
    if (idValue['_id'] != null) return idValue['_id'].toString();
    return idValue.toString();
  }
  return idValue.toString();
}

class ChildListItem {
  final String id;
  final String studentId;
  final String name;

  ChildListItem({
    required this.id,
    required this.studentId,
    required this.name,
  });

  factory ChildListItem.fromJson(Map<String, dynamic> json) {
    return ChildListItem(
      id: _extractId(json['_id'] ?? json['id']),
      studentId: json['studentId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class ChildrenListResponse {
  final List<ChildListItem> children;
  final int total;

  ChildrenListResponse({
    required this.children,
    required this.total,
  });

  factory ChildrenListResponse.fromJson(Map<String, dynamic> json) {
    return ChildrenListResponse(
      children: (json['children'] as List? ?? [])
          .map((child) => ChildListItem.fromJson(child as Map<String, dynamic>))
          .toList(),
      total: (json['total'] is int)
          ? json['total'] as int
          : (json['total'] is num)
              ? (json['total'] as num).toInt()
              : 0,
    );
  }
}

class ChildProgressResponse {
  final StudentInfo student;
  final ProgressSummary summary;
  final List<EnrollmentInfo> enrollments;
  final String period;
  final ProgressFilters filters;

  ChildProgressResponse({
    required this.student,
    required this.summary,
    required this.enrollments,
    required this.period,
    required this.filters,
  });

  factory ChildProgressResponse.fromJson(Map<String, dynamic> json) {
    return ChildProgressResponse(
      student: StudentInfo.fromJson(
        json['student'] is Map<String, dynamic>
          ? json['student'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
      summary: ProgressSummary.fromJson(
        json['summary'] is Map<String, dynamic>
          ? json['summary'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
      enrollments: (json['enrollments'] as List? ?? [])
          .map((enrollment) => EnrollmentInfo.fromJson(
            enrollment is Map<String, dynamic>
              ? enrollment as Map<String, dynamic>
              : <String, dynamic>{},
          ))
          .toList(),
      period: json['period']?.toString() ?? '30d',
      filters: ProgressFilters.fromJson(
        json['filters'] is Map<String, dynamic>
          ? json['filters'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
    );
  }
}

class StudentInfo {
  final String id;
  final String studentId;
  final String name;
  final String email;
  final String contactNumber;
  final String? profileImage;
  final StudentLevelInfo? studentLevel;
  final BoardInfo? board;
  final ClassInfo? classInfo;

  StudentInfo({
    required this.id,
    required this.studentId,
    required this.name,
    required this.email,
    required this.contactNumber,
    this.profileImage,
    this.studentLevel,
    this.board,
    this.classInfo,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      id: _extractId(json['id'] ?? json['_id']),
      studentId: json['studentId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      contactNumber: json['contactNumber']?.toString() ?? '',
      profileImage: json['profileImage']?.toString(),
      studentLevel: json['studentLevel'] != null && json['studentLevel'] is Map<String, dynamic>
          ? StudentLevelInfo.fromJson(json['studentLevel'] as Map<String, dynamic>)
          : null,
      board: json['board'] != null && json['board'] is Map<String, dynamic>
          ? BoardInfo.fromJson(json['board'] as Map<String, dynamic>)
          : null,
      classInfo: json['class'] != null && json['class'] is Map<String, dynamic>
          ? ClassInfo.fromJson(json['class'] as Map<String, dynamic>)
          : null,
    );
  }
}

class StudentLevelInfo {
  final String name;
  final String description;
  final String classRange;

  StudentLevelInfo({
    required this.name,
    required this.description,
    required this.classRange,
  });

  factory StudentLevelInfo.fromJson(Map<String, dynamic> json) {
    return StudentLevelInfo(
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      classRange: json['classRange']?.toString() ?? '',
    );
  }
}

class BoardInfo {
  final String name;
  final String code;

  BoardInfo({
    required this.name,
    required this.code,
  });

  factory BoardInfo.fromJson(Map<String, dynamic> json) {
    return BoardInfo(
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }
}

class ClassInfo {
  final String name;
  final int number;

  ClassInfo({
    required this.name,
    required this.number,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      name: json['name']?.toString() ?? '',
      number: (json['number'] is int)
          ? json['number'] as int
          : (json['number'] is num)
              ? (json['number'] as num).toInt()
              : 0,
    );
  }
}

class ProgressSummary {
  final double avgScore;
  final int totalAttempts;
  final double maxScore;
  final double minScore;
  final double completionRate;
  final double attendanceRate;
  final int timeSpentMinutes;
  final int lessonsViewed;
  final int totalLessons;
  final int completedLessons;

  ProgressSummary({
    required this.avgScore,
    required this.totalAttempts,
    required this.maxScore,
    required this.minScore,
    required this.completionRate,
    required this.attendanceRate,
    required this.timeSpentMinutes,
    required this.lessonsViewed,
    required this.totalLessons,
    required this.completedLessons,
  });

  factory ProgressSummary.fromJson(Map<String, dynamic> json) {
    return ProgressSummary(
      avgScore: (json['avgScore'] ?? 0).toDouble(),
      totalAttempts: (json['totalAttempts'] is int)
          ? json['totalAttempts'] as int
          : (json['totalAttempts'] is num)
              ? (json['totalAttempts'] as num).toInt()
              : 0,
      maxScore: (json['maxScore'] ?? 0).toDouble(),
      minScore: (json['minScore'] ?? 0).toDouble(),
      completionRate: (json['completionRate'] ?? 0).toDouble(),
      attendanceRate: (json['attendanceRate'] ?? 0).toDouble(),
      timeSpentMinutes: (json['timeSpentMinutes'] is int)
          ? json['timeSpentMinutes'] as int
          : (json['timeSpentMinutes'] is num)
              ? (json['timeSpentMinutes'] as num).toInt()
              : 0,
      lessonsViewed: (json['lessonsViewed'] is int)
          ? json['lessonsViewed'] as int
          : (json['lessonsViewed'] is num)
              ? (json['lessonsViewed'] as num).toInt()
              : 0,
      totalLessons: (json['totalLessons'] is int)
          ? json['totalLessons'] as int
          : (json['totalLessons'] is num)
              ? (json['totalLessons'] as num).toInt()
              : 0,
      completedLessons: (json['completedLessons'] is int)
          ? json['completedLessons'] as int
          : (json['completedLessons'] is num)
              ? (json['completedLessons'] as num).toInt()
              : 0,
    );
  }
}

class EnrollmentInfo {
  final String id;
  final CourseInfo course;
  final BatchInfo batch;
  final EnrollmentProgress progress;
  final String status;
  final String? enrolledAt;
  final String? lastAccessedAt;

  EnrollmentInfo({
    required this.id,
    required this.course,
    required this.batch,
    required this.progress,
    required this.status,
    this.enrolledAt,
    this.lastAccessedAt,
  });

  factory EnrollmentInfo.fromJson(Map<String, dynamic> json) {
    return EnrollmentInfo(
      id: _extractId(json['id'] ?? json['_id']),
      course: CourseInfo.fromJson(
        json['course'] is Map<String, dynamic>
          ? json['course'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
      batch: BatchInfo.fromJson(
        json['batch'] is Map<String, dynamic>
          ? json['batch'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
      progress: EnrollmentProgress.fromJson(
        json['progress'] is Map<String, dynamic>
          ? json['progress'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
      status: json['status']?.toString() ?? 'active',
      enrolledAt: json['enrolledAt']?.toString(),
      lastAccessedAt: json['lastAccessedAt']?.toString(),
    );
  }
}

class CourseInfo {
  final String id;
  final String title;
  final String? description;

  CourseInfo({
    required this.id,
    required this.title,
    this.description,
  });

  factory CourseInfo.fromJson(Map<String, dynamic> json) {
    return CourseInfo(
      id: _extractId(json['_id'] ?? json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }
}

class BatchInfo {
  final String id;
  final String code;
  final String title;

  BatchInfo({
    required this.id,
    required this.code,
    required this.title,
  });

  factory BatchInfo.fromJson(Map<String, dynamic> json) {
    return BatchInfo(
      id: _extractId(json['_id'] ?? json['id']),
      code: json['code']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }
}

class EnrollmentProgress {
  final int lessonsCompleted;
  final int totalLessons;
  final double percentage;
  final String? lastAccessedAt;

  EnrollmentProgress({
    required this.lessonsCompleted,
    required this.totalLessons,
    required this.percentage,
    this.lastAccessedAt,
  });

  factory EnrollmentProgress.fromJson(Map<String, dynamic> json) {
    return EnrollmentProgress(
      lessonsCompleted: (json['lessonsCompleted'] is int)
          ? json['lessonsCompleted'] as int
          : (json['lessonsCompleted'] is num)
              ? (json['lessonsCompleted'] as num).toInt()
              : 0,
      totalLessons: (json['totalLessons'] is int)
          ? json['totalLessons'] as int
          : (json['totalLessons'] is num)
              ? (json['totalLessons'] as num).toInt()
              : 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
      lastAccessedAt: json['lastAccessedAt']?.toString(),
    );
  }
}

class ProgressFilters {
  final String? courseId;
  final String? batchId;

  ProgressFilters({
    this.courseId,
    this.batchId,
  });

  factory ProgressFilters.fromJson(Map<String, dynamic> json) {
    return ProgressFilters(
      courseId: json['courseId']?.toString(),
      batchId: json['batchId']?.toString(),
    );
  }
}

