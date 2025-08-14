class Student {
  final String id;
  final String name;
  final String email;
  final String studentId;
  final String department;
  final String yearOfStudy;
  final List<String> courses;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
    required this.department,
    required this.yearOfStudy,
    required this.courses,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      studentId: json['studentId'],
      department: json['department'],
      yearOfStudy: json['yearOfStudy'],
      courses: List<String>.from(json['courses']),
    );
  }
}

class FeeDetails {
  final String feeType;
  final String academicSession;
  final DateTime dueDate;

  FeeDetails({
    required this.feeType,
    required this.academicSession,
    required this.dueDate,
  });

  factory FeeDetails.fromJson(Map<String, dynamic> json) {
    return FeeDetails(
      feeType: json['feeType'],
      academicSession: json['academicSession'],
      dueDate: DateTime.parse(json['dueDate']),
    );
  }
}

class Payment {
  final String id;
  final double amount;
  final String feeId;
  final FeeDetails feeDetails;
  final String paymentProvider;
  final String status;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.amount,
    required this.feeId,
    required this.feeDetails,
    required this.paymentProvider,
    required this.status,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['_id'],
      amount: json['amount'].toDouble(),
      feeId: json['feeId'],
      feeDetails: FeeDetails.fromJson(json['feeDetails']),
      paymentProvider: json['paymentProvider'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Receipt {
  final String id;
  final String receiptNumber;
  final double amount;
  final DateTime date;
  final String pdfUrl;
  final Map<String, dynamic> branding;

  Receipt({
    required this.id,
    required this.receiptNumber,
    required this.amount,
    required this.date,
    required this.pdfUrl,
    required this.branding,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['_id'],
      receiptNumber: json['receiptNumber'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      pdfUrl: json['pdfUrl'],
      branding: json['branding'],
    );
  }
}

class DashboardResponse {
  final bool success;
  final Student student;
  final List<Payment> payments;
  final List<Receipt> receipts;

  DashboardResponse({
    required this.success,
    required this.student,
    required this.payments,
    required this.receipts,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      success: json['success'],
      student: Student.fromJson(json['data']['student']),
      payments: (json['data']['payments'] as List)
          .map((payment) => Payment.fromJson(payment))
          .toList(),
      receipts: (json['data']['receipts'] as List)
          .map((receipt) => Receipt.fromJson(receipt))
          .toList(),
    );
  }
}