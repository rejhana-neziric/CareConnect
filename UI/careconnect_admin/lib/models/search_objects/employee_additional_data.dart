class EmployeeAdditionalData {
  bool? isUserIncluded;
  bool? isQualificationIncluded;
  bool? isEmployeeAvailabilityIncluded;

  EmployeeAdditionalData({
    this.isUserIncluded,
    this.isQualificationIncluded,
    this.isEmployeeAvailabilityIncluded,
  });

  Map<String, dynamic> toJson() => {
    'isUserIncluded': isUserIncluded,
    'isQualificationIncluded': isQualificationIncluded,
    'isEmployeeAvailabilityIncluded': isEmployeeAvailabilityIncluded,
  };
}
