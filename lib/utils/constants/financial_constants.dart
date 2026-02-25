class FinancialConstants {
  // Buyer-side default fees
  static const double cashLoanClosingFee = 800.0;
  static const double cashLoanRecordingFee = 300.0;
  static const double nonCashLoanClosingFee = 800.0;
  static const double nonCashLoanRecordingFee = 300.0;
  // static const double cashLoanClosingFee = 800.0;
  // static const double cashLoanRecordingFee = 50.0;
  // static const double nonCashLoanClosingFee = 700.0;
  // static const double nonCashLoanRecordingFee = 200.0;
  static const double defaultProcessingFees = 120.0;

  // Seller-side defaults
  static const double defaultSellerClosingFees = 800.0;
  // static const double defaultSellerClosingFees = 700.0;
  static const double defaultCommissionPercentage = 6.0;

  // Title insurance rates
  static const double ownersTitleRatePerThousand = 3.40; // owners rate
  static const double lendersTitleRatePerThousand = 1.8; // lender's rate

  // Itemized fixed closing costs (buyer-side defaults)
  static const double convAppraisalFee = 900.0;
  static const double fhaAppraisalFee = 900.0;
  static const double vaAppraisalFee = 900.0; // 600.0 or 800.0
  // static const double convAppraisalFee = 750.0;
  // static const double fhaAppraisalFee = 750.0;
  // static const double vaAppraisalFee = 800.0; // 600.0 or 800.0
  static const double creditReportFee = 50.0;
  static const double underwritingProcessingFee = 650.0;
  static const double floodCertificationFee = 25;
  // static const double floodCertificationFee = 13.50;
  // Origination discount fee (kept as a dollar/flat value here to match previous data)

  static const double titleEndFee = 75.00;
}
