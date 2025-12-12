// Helper function to safely extract string ID from JSON
String _extractId(dynamic idValue) {
  if (idValue == null) return '';
  if (idValue is String) return idValue;
  if (idValue is Map) {
    // Handle MongoDB ObjectId or nested ID objects
    if (idValue['\$oid'] != null) return idValue['\$oid'].toString();
    if (idValue['id'] != null) return idValue['id'].toString();
    if (idValue['_id'] != null) return idValue['_id'].toString();
    return idValue.toString();
  }
  return idValue.toString();
}

class DashboardModel {
  final ParentInfo parent;
  final List<ChildInfo> children;
  final OverallStats overallStats;

  DashboardModel({
    required this.parent,
    required this.children,
    required this.overallStats,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      parent: ParentInfo.fromJson(
        json['parent'] is Map<String, dynamic> 
          ? json['parent'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
      children: (json['children'] as List? ?? [])
          .map((child) => ChildInfo.fromJson(
            child is Map<String, dynamic> 
              ? child as Map<String, dynamic>
              : <String, dynamic>{},
          ))
          .toList(),
      overallStats: OverallStats.fromJson(
        json['overallStats'] is Map<String, dynamic>
          ? json['overallStats'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
    );
  }
}

class ParentInfo {
  final String id;
  final String name;
  final String email;
  final String contactNumber;
  final String? profileImage;
  final String? lastLogin;

  ParentInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    this.profileImage,
    this.lastLogin,
  });

  factory ParentInfo.fromJson(Map<String, dynamic> json) {
    return ParentInfo(
      id: _extractId(json['id'] ?? json['_id']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      contactNumber: json['contactNumber']?.toString() ?? '',
      profileImage: json['profileImage']?.toString(),
      lastLogin: json['lastLogin']?.toString(),
    );
  }
}

class ChildInfo {
  final String id;
  final String studentId;
  final String name;
  final String email;
  final String contactNumber;
  final String? profileImage;
  final StudentLevel? studentLevel;
  final Board? board;
  final ClassInfo? classInfo;
  final String? stream;
  final String? degree;
  final String? createdAt;
  final ProgressInfo? progress;
  final List<ActivityInfo> activities;
  final List<CourseEnrollment> courses;
  final int totalCourses;
  final int activeCourses;

  ChildInfo({
    required this.id,
    required this.studentId,
    required this.name,
    required this.email,
    required this.contactNumber,
    this.profileImage,
    this.studentLevel,
    this.board,
    this.classInfo,
    this.stream,
    this.degree,
    this.createdAt,
    this.progress,
    required this.activities,
    required this.courses,
    required this.totalCourses,
    required this.activeCourses,
  });

  factory ChildInfo.fromJson(Map<String, dynamic> json) {
    return ChildInfo(
      id: _extractId(json['id'] ?? json['_id']),
      studentId: json['studentId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      contactNumber: json['contactNumber']?.toString() ?? '',
      profileImage: json['profileImage']?.toString(),
      studentLevel: json['studentLevel'] != null
          ? StudentLevel.fromJson(json['studentLevel'] as Map<String, dynamic>)
          : null,
      board: json['board'] != null 
          ? Board.fromJson(json['board'] as Map<String, dynamic>) 
          : null,
      classInfo: json['class'] != null
          ? ClassInfo.fromJson(json['class'] as Map<String, dynamic>)
          : null,
      stream: json['stream']?.toString(),
      degree: json['degree']?.toString(),
      createdAt: json['createdAt']?.toString(),
      progress: json['progress'] != null
          ? ProgressInfo.fromJson(json['progress'] as Map<String, dynamic>)
          : null,
      activities: (json['activities'] as List? ?? [])
          .map((activity) => ActivityInfo.fromJson(activity as Map<String, dynamic>))
          .toList(),
      courses: (json['courses'] as List? ?? [])
          .map((course) => CourseEnrollment.fromJson(course as Map<String, dynamic>))
          .toList(),
      totalCourses: (json['totalCourses'] is int) 
          ? json['totalCourses'] as int 
          : (json['totalCourses'] is num) 
              ? (json['totalCourses'] as num).toInt() 
              : 0,
      activeCourses: (json['activeCourses'] is int)
          ? json['activeCourses'] as int
          : (json['activeCourses'] is num)
              ? (json['activeCourses'] as num).toInt()
              : 0,
    );
  }
}

class StudentLevel {
  final String name;
  final String description;
  final String classRange;

  StudentLevel({
    required this.name,
    required this.description,
    required this.classRange,
  });

  factory StudentLevel.fromJson(Map<String, dynamic> json) {
    return StudentLevel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      classRange: json['classRange'] ?? '',
    );
  }
}

class Board {
  final String name;
  final String code;

  Board({
    required this.name,
    required this.code,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
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
      name: json['name'] ?? '',
      number: json['number'] ?? 0,
    );
  }
}

class ProgressInfo {
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

  ProgressInfo({
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

  factory ProgressInfo.fromJson(Map<String, dynamic> json) {
    return ProgressInfo(
      avgScore: (json['avgScore'] ?? 0).toDouble(),
      totalAttempts: json['totalAttempts'] ?? 0,
      maxScore: (json['maxScore'] ?? 0).toDouble(),
      minScore: (json['minScore'] ?? 0).toDouble(),
      completionRate: (json['completionRate'] ?? 0).toDouble(),
      attendanceRate: (json['attendanceRate'] ?? 0).toDouble(),
      timeSpentMinutes: json['timeSpentMinutes'] ?? 0,
      lessonsViewed: json['lessonsViewed'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
      completedLessons: json['completedLessons'] ?? 0,
    );
  }
}

class ActivityInfo {
  final String id;
  final String eventType;
  final CourseInfo? course;
  final BatchInfo? batch;
  final LessonInfo? lesson;
  final Map<String, dynamic>? value;
  final String? createdAt;

  ActivityInfo({
    required this.id,
    required this.eventType,
    this.course,
    this.batch,
    this.lesson,
    this.value,
    this.createdAt,
  });

  factory ActivityInfo.fromJson(Map<String, dynamic> json) {
    return ActivityInfo(
      id: _extractId(json['id'] ?? json['_id']),
      eventType: json['eventType']?.toString() ?? '',
      course: json['course'] != null 
          ? CourseInfo.fromJson(json['course'] as Map<String, dynamic>) 
          : null,
      batch: json['batch'] != null 
          ? BatchInfo.fromJson(json['batch'] as Map<String, dynamic>) 
          : null,
      lesson: json['lesson'] != null 
          ? LessonInfo.fromJson(json['lesson'] as Map<String, dynamic>) 
          : null,
      value: json['value'] is Map<String, dynamic> 
          ? json['value'] as Map<String, dynamic>
          : null,
      createdAt: json['createdAt']?.toString(),
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
      id: _extractId(json['id'] ?? json['_id']),
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
      id: _extractId(json['id'] ?? json['_id']),
      code: json['code']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }
}

class LessonInfo {
  final String id;
  final String title;

  LessonInfo({
    required this.id,
    required this.title,
  });

  factory LessonInfo.fromJson(Map<String, dynamic> json) {
    return LessonInfo(
      id: _extractId(json['id'] ?? json['_id']),
      title: json['title']?.toString() ?? '',
    );
  }
}

class CourseEnrollment {
  final String id;
  final CourseInfo course;
  final BatchInfo batch;
  final CourseProgress progress;
  final String status;
  final String? enrolledAt;
  final String? lastAccessedAt;

  CourseEnrollment({
    required this.id,
    required this.course,
    required this.batch,
    required this.progress,
    required this.status,
    this.enrolledAt,
    this.lastAccessedAt,
  });

  factory CourseEnrollment.fromJson(Map<String, dynamic> json) {
    return CourseEnrollment(
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
      progress: CourseProgress.fromJson(
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

class CourseProgress {
  final int lessonsCompleted;
  final int totalLessons;
  final double percentage;

  CourseProgress({
    required this.lessonsCompleted,
    required this.totalLessons,
    required this.percentage,
  });

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      lessonsCompleted: json['lessonsCompleted'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }
}

class OverallStats {
  final int totalChildren;
  final int totalCourses;
  final int totalActiveCourses;
  final double overallAvgScore;
  final double overallCompletionRate;
  final double overallAttendanceRate;
  final String period;

  OverallStats({
    required this.totalChildren,
    required this.totalCourses,
    required this.totalActiveCourses,
    required this.overallAvgScore,
    required this.overallCompletionRate,
    required this.overallAttendanceRate,
    required this.period,
  });

  factory OverallStats.fromJson(Map<String, dynamic> json) {
    return OverallStats(
      totalChildren: json['totalChildren'] ?? 0,
      totalCourses: json['totalCourses'] ?? 0,
      totalActiveCourses: json['totalActiveCourses'] ?? 0,
      overallAvgScore: (json['overallAvgScore'] ?? 0).toDouble(),
      overallCompletionRate: (json['overallCompletionRate'] ?? 0).toDouble(),
      overallAttendanceRate: (json['overallAttendanceRate'] ?? 0).toDouble(),
      period: json['period'] ?? '30d',
    );
  }
}

