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

class ProfileResponse {
  final ParentProfileInfo parent;
  final List<ChildProfileInfo> children;
  final ProfileSummary summary;

  ProfileResponse({
    required this.parent,
    required this.children,
    required this.summary,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      parent: ParentProfileInfo.fromJson(
        json['parent'] is Map<String, dynamic>
          ? json['parent'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
      children: (json['children'] as List? ?? [])
          .map((child) => ChildProfileInfo.fromJson(
            child is Map<String, dynamic>
              ? child as Map<String, dynamic>
              : <String, dynamic>{},
          ))
          .toList(),
      summary: ProfileSummary.fromJson(
        json['summary'] is Map<String, dynamic>
          ? json['summary'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
    );
  }
}

class ParentProfileInfo {
  final String id;
  final String name;
  final String email;
  final String contactNumber;
  final String? profileImage;
  final String? studentId;
  final bool isActive;
  final String? lastLogin;
  final String? createdAt;
  final String? updatedAt;

  ParentProfileInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    this.profileImage,
    this.studentId,
    required this.isActive,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  });

  factory ParentProfileInfo.fromJson(Map<String, dynamic> json) {
    return ParentProfileInfo(
      id: _extractId(json['id'] ?? json['_id']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      contactNumber: json['contactNumber']?.toString() ?? '',
      profileImage: json['profileImage']?.toString(),
      studentId: json['studentId']?.toString(),
      isActive: json['isActive'] == true,
      lastLogin: json['lastLogin']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}

class ChildProfileInfo {
  final String id;
  final String studentId;
  final String name;
  final String email;
  final String contactNumber;
  final String? profileImage;
  final StudentLevelInfo? studentLevel;
  final BoardInfo? board;
  final ClassInfo? classInfo;
  final String? stream;
  final String? degree;
  final String? createdAt;
  final String? updatedAt;
  final SubscriptionsInfo subscriptions;
  final EnrollmentsInfo enrollments;
  final bool hasActiveSubscription;
  final bool canEnrollInCourses;

  ChildProfileInfo({
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
    this.updatedAt,
    required this.subscriptions,
    required this.enrollments,
    required this.hasActiveSubscription,
    required this.canEnrollInCourses,
  });

  factory ChildProfileInfo.fromJson(Map<String, dynamic> json) {
    return ChildProfileInfo(
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
      stream: json['stream']?.toString(),
      degree: json['degree']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      subscriptions: SubscriptionsInfo.fromJson(
        json['subscriptions'] is Map<String, dynamic>
          ? json['subscriptions'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
      enrollments: EnrollmentsInfo.fromJson(
        json['enrollments'] is Map<String, dynamic>
          ? json['enrollments'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
      hasActiveSubscription: json['hasActiveSubscription'] == true,
      canEnrollInCourses: json['canEnrollInCourses'] == true,
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

class SubscriptionsInfo {
  final List<SubscriptionInfo> all;
  final SubscriptionInfo? active;
  final int total;
  final int activeCount;
  final int expiredCount;

  SubscriptionsInfo({
    required this.all,
    this.active,
    required this.total,
    required this.activeCount,
    required this.expiredCount,
  });

  factory SubscriptionsInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionsInfo(
      all: (json['all'] as List? ?? [])
          .map((sub) => SubscriptionInfo.fromJson(
            sub is Map<String, dynamic>
              ? sub as Map<String, dynamic>
              : <String, dynamic>{},
          ))
          .toList(),
      active: json['active'] != null && json['active'] is Map<String, dynamic>
          ? SubscriptionInfo.fromJson(json['active'] as Map<String, dynamic>)
          : null,
      total: (json['total'] is int)
          ? json['total'] as int
          : (json['total'] is num)
              ? (json['total'] as num).toInt()
              : 0,
      activeCount: (json['activeCount'] is int)
          ? json['activeCount'] as int
          : (json['activeCount'] is num)
              ? (json['activeCount'] as num).toInt()
              : 0,
      expiredCount: (json['expiredCount'] is int)
          ? json['expiredCount'] as int
          : (json['expiredCount'] is num)
              ? (json['expiredCount'] as num).toInt()
              : 0,
    );
  }
}

class SubscriptionInfo {
  final String id;
  final String planType;
  final double originalAmount;
  final double discountAmount;
  final double finalAmount;
  final CouponInfo? coupon;
  final PlanInfo? plan;
  final String? startDate;
  final String? endDate;
  final bool isActive;
  final String status;
  final String paymentStatus;
  final String? paymentMethod;
  final String? transactionId;
  final int? daysRemaining;
  final bool isExpired;
  final String? nextRechargeDate;
  final String? createdAt;
  final String? updatedAt;

  SubscriptionInfo({
    required this.id,
    required this.planType,
    required this.originalAmount,
    required this.discountAmount,
    required this.finalAmount,
    this.coupon,
    this.plan,
    this.startDate,
    this.endDate,
    required this.isActive,
    required this.status,
    required this.paymentStatus,
    this.paymentMethod,
    this.transactionId,
    this.daysRemaining,
    required this.isExpired,
    this.nextRechargeDate,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(
      id: _extractId(json['id'] ?? json['_id']),
      planType: json['planType']?.toString() ?? '',
      originalAmount: (json['originalAmount'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      finalAmount: (json['finalAmount'] ?? 0).toDouble(),
      coupon: json['coupon'] != null && json['coupon'] is Map<String, dynamic>
          ? CouponInfo.fromJson(json['coupon'] as Map<String, dynamic>)
          : null,
      plan: json['plan'] != null && json['plan'] is Map<String, dynamic>
          ? PlanInfo.fromJson(json['plan'] as Map<String, dynamic>)
          : null,
      startDate: json['startDate']?.toString(),
      endDate: json['endDate']?.toString(),
      isActive: json['isActive'] == true,
      status: json['status']?.toString() ?? 'active',
      paymentStatus: json['paymentStatus']?.toString() ?? 'pending',
      paymentMethod: json['paymentMethod']?.toString(),
      transactionId: json['transactionId']?.toString(),
      daysRemaining: (json['daysRemaining'] is int)
          ? json['daysRemaining'] as int
          : (json['daysRemaining'] is num)
              ? (json['daysRemaining'] as num).toInt()
              : null,
      isExpired: json['isExpired'] == true,
      nextRechargeDate: json['nextRechargeDate']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}

class CouponInfo {
  final String id;
  final String code;
  final String discountType;
  final double discountValue;

  CouponInfo({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
  });

  factory CouponInfo.fromJson(Map<String, dynamic> json) {
    return CouponInfo(
      id: _extractId(json['id'] ?? json['_id']),
      code: json['code']?.toString() ?? '',
      discountType: json['discountType']?.toString() ?? '',
      discountValue: (json['discountValue'] ?? 0).toDouble(),
    );
  }
}

class PlanInfo {
  final String id;
  final String name;
  final String description;
  final String planType;
  final List<String> features;
  final double price;
  final double originalPrice;

  PlanInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.planType,
    required this.features,
    required this.price,
    required this.originalPrice,
  });

  factory PlanInfo.fromJson(Map<String, dynamic> json) {
    return PlanInfo(
      id: _extractId(json['id'] ?? json['_id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      planType: json['planType']?.toString() ?? '',
      features: (json['features'] as List? ?? [])
          .map((feature) => feature.toString())
          .toList(),
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
    );
  }
}

class EnrollmentsInfo {
  final List<EnrollmentInfo> all;
  final List<EnrollmentInfo> active;
  final List<EnrollmentInfo> completed;
  final int total;
  final int activeCount;
  final int completedCount;

  EnrollmentsInfo({
    required this.all,
    required this.active,
    required this.completed,
    required this.total,
    required this.activeCount,
    required this.completedCount,
  });

  factory EnrollmentsInfo.fromJson(Map<String, dynamic> json) {
    return EnrollmentsInfo(
      all: (json['all'] as List? ?? [])
          .map((enrollment) => EnrollmentInfo.fromJson(
            enrollment is Map<String, dynamic>
              ? enrollment as Map<String, dynamic>
              : <String, dynamic>{},
          ))
          .toList(),
      active: (json['active'] as List? ?? [])
          .map((enrollment) => EnrollmentInfo.fromJson(
            enrollment is Map<String, dynamic>
              ? enrollment as Map<String, dynamic>
              : <String, dynamic>{},
          ))
          .toList(),
      completed: (json['completed'] as List? ?? [])
          .map((enrollment) => EnrollmentInfo.fromJson(
            enrollment is Map<String, dynamic>
              ? enrollment as Map<String, dynamic>
              : <String, dynamic>{},
          ))
          .toList(),
      total: (json['total'] is int)
          ? json['total'] as int
          : (json['total'] is num)
              ? (json['total'] as num).toInt()
              : 0,
      activeCount: (json['activeCount'] is int)
          ? json['activeCount'] as int
          : (json['activeCount'] is num)
              ? (json['activeCount'] as num).toInt()
              : 0,
      completedCount: (json['completedCount'] is int)
          ? json['completedCount'] as int
          : (json['completedCount'] is num)
              ? (json['completedCount'] as num).toInt()
              : 0,
    );
  }
}

class EnrollmentInfo {
  final String id;
  final CourseInfo course;
  final BatchInfo batch;
  final String enrolledVia;
  final double pricePaid;
  final String? couponUsed;
  final double couponDiscount;
  final EnrollmentProgress progress;
  final String status;
  final String? enrolledAt;
  final String? completedAt;
  final String? lastAccessedAt;

  EnrollmentInfo({
    required this.id,
    required this.course,
    required this.batch,
    required this.enrolledVia,
    required this.pricePaid,
    this.couponUsed,
    required this.couponDiscount,
    required this.progress,
    required this.status,
    this.enrolledAt,
    this.completedAt,
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
      enrolledVia: json['enrolledVia']?.toString() ?? 'direct',
      pricePaid: (json['pricePaid'] ?? 0).toDouble(),
      couponUsed: json['couponUsed']?.toString(),
      couponDiscount: (json['couponDiscount'] ?? 0).toDouble(),
      progress: EnrollmentProgress.fromJson(
        json['progress'] is Map<String, dynamic>
          ? json['progress'] as Map<String, dynamic>
          : <String, dynamic>{},
      ),
      status: json['status']?.toString() ?? 'active',
      enrolledAt: json['enrolledAt']?.toString(),
      completedAt: json['completedAt']?.toString(),
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

class EnrollmentProgress {
  final int lessonsCompleted;
  final int totalLessons;
  final double percentage;

  EnrollmentProgress({
    required this.lessonsCompleted,
    required this.totalLessons,
    required this.percentage,
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
    );
  }
}

class ProfileSummary {
  final int totalChildren;
  final int totalSubscriptions;
  final int activeSubscriptions;
  final int totalEnrollments;
  final int activeEnrollments;
  final int childrenWithActiveSubscription;
  final int childrenWithoutActiveSubscription;

  ProfileSummary({
    required this.totalChildren,
    required this.totalSubscriptions,
    required this.activeSubscriptions,
    required this.totalEnrollments,
    required this.activeEnrollments,
    required this.childrenWithActiveSubscription,
    required this.childrenWithoutActiveSubscription,
  });

  factory ProfileSummary.fromJson(Map<String, dynamic> json) {
    return ProfileSummary(
      totalChildren: (json['totalChildren'] is int)
          ? json['totalChildren'] as int
          : (json['totalChildren'] is num)
              ? (json['totalChildren'] as num).toInt()
              : 0,
      totalSubscriptions: (json['totalSubscriptions'] is int)
          ? json['totalSubscriptions'] as int
          : (json['totalSubscriptions'] is num)
              ? (json['totalSubscriptions'] as num).toInt()
              : 0,
      activeSubscriptions: (json['activeSubscriptions'] is int)
          ? json['activeSubscriptions'] as int
          : (json['activeSubscriptions'] is num)
              ? (json['activeSubscriptions'] as num).toInt()
              : 0,
      totalEnrollments: (json['totalEnrollments'] is int)
          ? json['totalEnrollments'] as int
          : (json['totalEnrollments'] is num)
              ? (json['totalEnrollments'] as num).toInt()
              : 0,
      activeEnrollments: (json['activeEnrollments'] is int)
          ? json['activeEnrollments'] as int
          : (json['activeEnrollments'] is num)
              ? (json['activeEnrollments'] as num).toInt()
              : 0,
      childrenWithActiveSubscription: (json['childrenWithActiveSubscription'] is int)
          ? json['childrenWithActiveSubscription'] as int
          : (json['childrenWithActiveSubscription'] is num)
              ? (json['childrenWithActiveSubscription'] as num).toInt()
              : 0,
      childrenWithoutActiveSubscription: (json['childrenWithoutActiveSubscription'] is int)
          ? json['childrenWithoutActiveSubscription'] as int
          : (json['childrenWithoutActiveSubscription'] is num)
              ? (json['childrenWithoutActiveSubscription'] as num).toInt()
              : 0,
    );
  }
}

