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

class ActivitiesResponse {
  final List<ChildInfo> children;
  final List<ActivityItem> activities;
  final List<ActivitiesByStudent> activitiesByStudent;
  final PaginationInfo pagination;
  final ActivityFilters filters;

  ActivitiesResponse({
    required this.children,
    required this.activities,
    required this.activitiesByStudent,
    required this.pagination,
    required this.filters,
  });

  factory ActivitiesResponse.fromJson(Map<String, dynamic> json) {
    return ActivitiesResponse(
      children: (json['children'] as List? ?? [])
          .map((child) => ChildInfo.fromJson(child as Map<String, dynamic>))
          .toList(),
      activities: (json['activities'] as List? ?? [])
          .map((activity) => ActivityItem.fromJson(activity as Map<String, dynamic>))
          .toList(),
      activitiesByStudent: (json['activitiesByStudent'] as List? ?? [])
          .map((item) => ActivitiesByStudent.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>),
      filters: ActivityFilters.fromJson(json['filters'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ChildInfo {
  final String id;
  final String studentId;
  final String name;
  final String email;

  ChildInfo({
    required this.id,
    required this.studentId,
    required this.name,
    required this.email,
  });

  factory ChildInfo.fromJson(Map<String, dynamic> json) {
    return ChildInfo(
      id: _extractId(json['id'] ?? json['_id']),
      studentId: json['studentId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

class ActivityItem {
  final String id;
  final ChildInfo student;
  final String eventType;
  final CourseInfo? course;
  final BatchInfo? batch;
  final LessonInfo? lesson;
  final Map<String, dynamic>? value;
  final List<String> tags;
  final String? createdAt;
  final String? updatedAt;

  ActivityItem({
    required this.id,
    required this.student,
    required this.eventType,
    this.course,
    this.batch,
    this.lesson,
    this.value,
    required this.tags,
    this.createdAt,
    this.updatedAt,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: _extractId(json['id'] ?? json['_id']),
      student: ChildInfo.fromJson(
        json['student'] is Map<String, dynamic>
          ? json['student'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
      eventType: json['eventType']?.toString() ?? '',
      course: json['course'] != null && json['course'] is Map<String, dynamic>
          ? CourseInfo.fromJson(json['course'] as Map<String, dynamic>)
          : null,
      batch: json['batch'] != null && json['batch'] is Map<String, dynamic>
          ? BatchInfo.fromJson(json['batch'] as Map<String, dynamic>)
          : null,
      lesson: json['lesson'] != null && json['lesson'] is Map<String, dynamic>
          ? LessonInfo.fromJson(json['lesson'] as Map<String, dynamic>)
          : null,
      value: json['value'] is Map<String, dynamic>
          ? json['value'] as Map<String, dynamic>
          : null,
      tags: (json['tags'] as List? ?? [])
          .map((tag) => tag.toString())
          .toList(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
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

class ActivitiesByStudent {
  final ChildInfo student;
  final int count;
  final List<ActivityItem> activities;

  ActivitiesByStudent({
    required this.student,
    required this.count,
    required this.activities,
  });

  factory ActivitiesByStudent.fromJson(Map<String, dynamic> json) {
    return ActivitiesByStudent(
      student: ChildInfo.fromJson(
        json['student'] is Map<String, dynamic>
          ? json['student'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
      count: (json['count'] is int)
          ? json['count'] as int
          : (json['count'] is num)
              ? (json['count'] as num).toInt()
              : 0,
      activities: (json['activities'] as List? ?? [])
          .map((activity) => ActivityItem.fromJson(
            activity is Map<String, dynamic>
              ? activity as Map<String, dynamic>
              : <String, dynamic>{},
          ))
          .toList(),
    );
  }
}

class PaginationInfo {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      page: (json['page'] is int)
          ? json['page'] as int
          : (json['page'] is num)
              ? (json['page'] as num).toInt()
              : 1,
      limit: (json['limit'] is int)
          ? json['limit'] as int
          : (json['limit'] is num)
              ? (json['limit'] as num).toInt()
              : 20,
      total: (json['total'] is int)
          ? json['total'] as int
          : (json['total'] is num)
              ? (json['total'] as num).toInt()
              : 0,
      totalPages: (json['totalPages'] is int)
          ? json['totalPages'] as int
          : (json['totalPages'] is num)
              ? (json['totalPages'] as num).toInt()
              : 0,
      hasNextPage: json['hasNextPage'] == true,
      hasPrevPage: json['hasPrevPage'] == true,
    );
  }
}

class ActivityFilters {
  final String? eventType;
  final String? courseId;
  final String? batchId;

  ActivityFilters({
    this.eventType,
    this.courseId,
    this.batchId,
  });

  factory ActivityFilters.fromJson(Map<String, dynamic> json) {
    return ActivityFilters(
      eventType: json['eventType']?.toString(),
      courseId: json['courseId']?.toString(),
      batchId: json['batchId']?.toString(),
    );
  }
}

