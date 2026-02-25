import 'package:get/get.dart';
import 'package:travel_app/controllers/calculator_controller.dart';
import 'package:travel_app/utils/enums/loan_type.dart';

class ClosingCost {
  // Common fields for all loan types
  final double? appraisal;
  final double? creditReport;
  final double? floodCertification;
  final double? closingFee;
  final double? recordingFee;
  final double? titleEnd;

  // Fields for Conventional and FHA loans
  final double? underwritingProcessing;
  final double? originationDiscount;
  final double? lendersTitlePolicy;

  // FHA Loan specific fields
  final double? mortgageInsurance; // Mortgage Insurance Premium
  final double? monthlyMortgageInsurance; // Monthly Mortgage Insurance

  // VA Loan specific field
  final double? vaFundingFee;

  const ClosingCost({
    // Common fields
    this.appraisal,
    this.creditReport,
    this.floodCertification,
    this.closingFee,
    this.recordingFee,
    this.titleEnd,
    // Conventional and FHA fields
    this.underwritingProcessing,
    this.originationDiscount,
    this.lendersTitlePolicy,
    // FHA specific fields
    this.mortgageInsurance,
    this.monthlyMortgageInsurance,
    // VA specific field
    this.vaFundingFee,
  });

  // Calculated total of non-null costs
  double get total {
    double sum = 0;
    if (appraisal != null) sum += appraisal!;
    if (creditReport != null) sum += creditReport!;
    if (underwritingProcessing != null) sum += underwritingProcessing!;
    if (floodCertification != null) sum += floodCertification!;
    if (originationDiscount != null) sum += originationDiscount!;
    if (lendersTitlePolicy != null) sum += lendersTitlePolicy!;
    if (titleEnd != null) sum += titleEnd!;
    if (closingFee != null) sum += closingFee!;
    if (recordingFee != null) {
      sum += Get.find<CalculatorController>().loanType == LoanType.cash
          ? (-recordingFee!)
          : recordingFee!;
    }
    if (mortgageInsurance != null) sum += mortgageInsurance!;
    // if (monthlyMortgageInsurance != null) sum += monthlyMortgageInsurance!;
    if (vaFundingFee != null) sum += vaFundingFee!;
    return sum;
  }

  // Get monthly costs (separate from one-time costs)
  double get monthlyTotal => monthlyMortgageInsurance ?? 0;

  // Costs with their display names for UI
  static const Map<String, String> labels = {
    'appraisal': 'Appraisal:',
    'creditReport': 'Credit Report:',
    'underwritingProcessing': 'Underwriting/Processing Fee:',
    'floodCertification': 'Flood Certification:',
    'originationDiscount':
        'Origination Discount Fee: (*Varies on market and/or lender)',
    'lendersTitlePolicy': 'Lender\'s Title Policy:',
    'titleEnd': 'Title End 9 22 8.1:',
    'closingFee': 'Closing Fee:',
    'recordingFee': 'Recording Fee:',
    // FHA specific labels
    'mortgageInsurance': 'Mortgage Insurance:',
    'monthlyMortgageInsurance': 'Monthly Mortgage Insurance:',
    // VA specific label
    'vaFundingFee': 'VA Funding Fee:',
  };

  // Get non-null costs as list entries for display
  List<MapEntry<String, String>> toList() {
    final List<MapEntry<String, String>> entries = [];

    // Only add non-null values
    void addIfNotNull(String key, double? value) {
      if (value != null) {
        entries.add(MapEntry(labels[key]!, value.toStringAsFixed(2)));
      }
    }

    // Add one-time closing costs
    addIfNotNull('appraisal', appraisal);
    addIfNotNull('creditReport', creditReport);
    addIfNotNull('underwritingProcessing', underwritingProcessing);
    addIfNotNull('floodCertification', floodCertification);
    addIfNotNull('originationDiscount', originationDiscount);
    addIfNotNull('lendersTitlePolicy', lendersTitlePolicy);
    addIfNotNull('titleEnd', titleEnd);
    addIfNotNull('closingFee', closingFee);
    addIfNotNull('recordingFee', recordingFee);

    // Add VA specific costs
    addIfNotNull('vaFundingFee', vaFundingFee);

    // Add FHA specific costs
    addIfNotNull('mortgageInsurance', mortgageInsurance);

    // Add monthly costs in a separate section if they exist
    if (monthlyMortgageInsurance != null) {
      addIfNotNull('monthlyMortgageInsurance', monthlyMortgageInsurance);
    }
    // Add one-time total if there are any costs
    if (entries.isNotEmpty) {
      entries.add(MapEntry('Total Closing Costs:', total.toStringAsFixed(2)));
    }

    return entries;
  }

  // Create a ClosingCost with all values set to zero
  factory ClosingCost.zero() => const ClosingCost(
    // Common fields
    appraisal: 0,
    creditReport: 0,
    floodCertification: 0,
    closingFee: 0,
    recordingFee: 0,
    titleEnd: 0,
    // Conventional and FHA fields
    underwritingProcessing: 0,
    originationDiscount: 0,
    lendersTitlePolicy: 0,
    // FHA specific fields
    mortgageInsurance: 0,
    monthlyMortgageInsurance: 0,
    // VA specific field
    vaFundingFee: 0,
  );
}
