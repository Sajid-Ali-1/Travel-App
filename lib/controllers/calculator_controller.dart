import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:travel_app/services/rate_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/enums/loan_type.dart';
import '../utils/constants/financial_constants.dart';
import '../models/closing_cost.dart';

class CalculatorController extends GetxController {
  LoanType loanType = LoanType.conventional;
  double propertyPriceController = 0;
  double loanAmount = 0;
  double loanTermYears = 0;
  double annualIntrestRatePercentage = 0;
  double annualTax = 0;
  double annualInsurance = 0;

  double estimatedLoanPayoff = 0;
  double closingFees = 0;
  double commissionPercentage = 0;
  double sellerToPayClosingCost = 0;
  double salePrice = 0;
  List<LiabilityRate> rateSchedule = [];

  @override
  void onInit() {
    resetValues();
    loadRates();
    super.onInit();
  }

  void resetValues() {
    loanType = LoanType.conventional;
    propertyPriceController = 0;
    loanAmount = 0;
    loanTermYears = 30;
    annualIntrestRatePercentage = 6.5;
    annualTax = 0;
    annualInsurance = 0;

    estimatedLoanPayoff = 0;
    closingFees = FinancialConstants.defaultSellerClosingFees;
    commissionPercentage = FinancialConstants.defaultCommissionPercentage;
    sellerToPayClosingCost = 0;
    salePrice = 0;
  }

  Future<void> loadRates() async {
    rateSchedule = await RateService().loadRates();
  }

  //------------------------------- Buyer Quick Estimate Calculations --------------------------------//
  /// Calculate PITI (Principal, Interest, Taxes, Insurance)
  double calculatePITI() {
    double principalAndInterest = _calculatePrincipalAndInterest();

    final double monthlyMIP = loanType == LoanType.fha
        ? calculateMonthlyMortgageInsurance()
        : 0.0;
    // PITI = Principal & Interest + Monthly Taxes + Monthly Insurance
    double totalPITI =
        principalAndInterest +
        (annualTax / 12) +
        (annualInsurance / 12) +
        monthlyMIP;
    if (kDebugMode) {
      print(totalPITI);
    }
    return totalPITI.ceilToDouble();
  }

  double _calculatePrincipalAndInterest() {
    double monthlyInterestRate = annualIntrestRatePercentage / 100 / 12;
    double totalPayments = loanTermYears * 12;
    // Using the formula for monthly mortgage payment (Principal & intrest)
    final a = pow(1 + monthlyInterestRate, totalPayments);
    final b = monthlyInterestRate * a;
    final c = a - 1;
    double pi = loanAmount * b / c;
    (pow(1 + monthlyInterestRate, totalPayments) - 1);
    if (kDebugMode) {
      print("totalPayments: $totalPayments");
      print("monthlyInterestRate: $monthlyInterestRate");
      print(a);
      print(b);
      print(c);
      print(b / c);
      print(pi);
    }

    return pi;
  }

  //------------------------------- Seller Net Sheet Calculations --------------------------------//

  double calculateSellerCommission() {
    return salePrice * (commissionPercentage / 100);
  }

  double calculateSellerNetProceeds() {
    return salePrice - estimatedLoanPayoff - _calculateTotalSellerExpenses();
  }

  double _calculateTotalSellerExpenses() {
    // Calculate title insurance using salePrice or propertyPriceController
    double price = salePrice > 0 ? salePrice : propertyPriceController;
    double titleInsuranceCost =
        (price / 1000) * FinancialConstants.ownersTitleRatePerThousand;

    return closingFees +
        sellerToPayClosingCost +
        titleInsuranceCost +
        FinancialConstants.defaultProcessingFees +
        calculateSellerCommission();
  }

  //------------------------------- Title Insurance Calculations --------------------------------//
  final List<Map<String, dynamic>> titleInsuranceRateTiers = [
    {'start': 15000.0, 'end': 30000.0, 'ratePerThousand': 5.50},
    {'start': 30000.0, 'end': 50000.0, 'ratePerThousand': 5.00},
    {'start': 50000.0, 'end': 100000.0, 'ratePerThousand': 4.25},
    {'start': 100000.0, 'end': 135000.0, 'ratePerThousand': 3.00},
    {'start': 135000.0, 'end': 250000.0, 'ratePerThousand': 2.50},
    {'start': 250000.0, 'end': 350000.0, 'ratePerThousand': 2.40},
    {'start': 350000.0, 'end': 1000000.0, 'ratePerThousand': 2.09},
    {'start': 1000000.0, 'end': 5000000.0, 'ratePerThousand': 1.82},
    {'start': 5000000.0, 'end': 10000000.0, 'ratePerThousand': 1.30},
    {'start': 10000000.0, 'end': 100000000.0, 'ratePerThousand': 1.20},
    {'start': 100000000.0, 'end': double.infinity, 'ratePerThousand': 1.10},
  ];

  /// Calculates the Title Insurance Premium ("Sum") based on a given Liability Amount.
  ///
  /// The calculation uses a cumulative, tiered rate structure with a starting
  /// minimum premium.
  ///
  /// @param liabilityAmount The total amount of the policy coverage.
  /// @returns The calculated premium (Sum) as a double.
  double calculateTitleInsuranceBasicPrice(double liabilityAmount) {
    // Ensure the liability amount is non-negative.
    if (liabilityAmount < 0) {
      throw ArgumentError('Liability Amount cannot be negative.');
    }

    // Define the absolute minimum liability and the base premium associated with it.
    const double minLiability = 15000.0;
    const double basePremium = 195.0; // The initial "Sum" for $15,000

    // 1. Handle the minimum liability case.
    if (liabilityAmount <= minLiability) {
      // The sum is the base premium for any amount up to $15,000.
      return basePremium;
    }

    // 2. Initialize the total premium with the base premium.
    double totalSum = basePremium;

    // 3. Keep track of the last processed liability amount. We start counting
    // marginal premium from the minimum liability amount.
    double lastProcessedLiability = minLiability;

    // 4. Iterate through the rate tiers to calculate the cumulative premium.
    for (final tier in titleInsuranceRateTiers) {
      final double tierStart = tier['start'] as double;
      final double tierEnd = tier['end'] as double;
      final double rate = tier['ratePerThousand'] as double;

      // Skip tiers that start before the last processed amount if the liability
      // amount has already been fully processed by the base premium logic.
      if (tierStart < lastProcessedLiability) continue;

      // Check if any portion of the liability amount falls within this tier's range.
      if (liabilityAmount > tierStart) {
        // The calculation starts at the tier's start point.
        final double calculationStart = tierStart;

        // The calculation ends either at the tier's end point OR the total liability amount,
        // whichever is smaller.
        final double calculationEnd =
            (tierEnd == double.infinity || liabilityAmount < tierEnd)
            ? liabilityAmount
            : tierEnd;

        // Calculate the positive amount in this tier: calculationEnd - calculationStart
        final double amountInTier = calculationEnd - calculationStart;

        // Safety check: ensure we are only calculating for a positive amount.
        if (amountInTier > 0) {
          final double tierPremium = (amountInTier / 1000.0) * rate;
          totalSum += tierPremium;
          lastProcessedLiability = calculationEnd;
        }

        // If the calculation reached the total liability amount, we are done.
        if (calculationEnd == liabilityAmount) {
          break;
        }
      }
    }

    // Round the final result to two decimal places for currency format.
    return double.parse(totalSum.round().toStringAsFixed(2));
  }

  double calculateSellersTitleInsuranceCost() {
    // Use salePrice if available, otherwise use propertyPriceController
    double price = salePrice > 0 ? salePrice : propertyPriceController;
    final ownerTitleInsuranceCost = calculateTitleInsuranceBasicPrice(price);
    return ownerTitleInsuranceCost;
  }

  double calculateLoanTitleInsuranceCost() {
    final double loanTitleInsuranceCost =
        calculateTitleInsuranceBasicPrice(loanAmount) * (30 / 100) + 40;
    return loanTitleInsuranceCost;
  }

  //------------------------------- Value Adjustment Methods --------------------------------//

  void increasePropertyPrice() {
    propertyPriceController += 1000;
    update();
  }

  void decreasePropertyPrice() {
    if (propertyPriceController >= 1000) {
      propertyPriceController -= 1000;
      update();
    }
  }

  void increaseLoanAmount() {
    loanAmount += 1000;
    update();
  }

  void decreaseLoanAmount() {
    if (loanAmount >= 1000) {
      loanAmount -= 1000;
      update();
    }
  }

  void increaseSalePrice() {
    if (salePrice > 0) {
      salePrice += 1000;
    } else {
      propertyPriceController += 1000;
    }
    update();
  }

  void decreaseSalePrice() {
    if (salePrice > 0) {
      if (salePrice >= 1000) {
        salePrice -= 1000;
      }
    } else {
      if (propertyPriceController >= 1000) {
        propertyPriceController -= 1000;
      }
    }
    update();
  }

  void increaseEstimatedLoanPayoff() {
    estimatedLoanPayoff += 1000;
    update();
  }

  void decreaseEstimatedLoanPayoff() {
    if (estimatedLoanPayoff >= 1000) {
      estimatedLoanPayoff -= 1000;
      update();
    }
  }

  double calculateRatePerThousandTax({
    required double propertyValue, // e.g., Sale Price or Assessed Value
  }) {
    // --- Constants for the Tax Rate ---
    const double ratePerThousand = 12.0;

    if (propertyValue <= 0) {
      return 0.0;
    }

    // Formula: (Property Value / 1,000) * Rate Per Thousand
    // This calculates how many thousands are in the value, then multiplies by the rate.
    final double taxAmount = (propertyValue / 1000.0) * ratePerThousand;

    // Round result to two decimal places for currency.
    return double.parse(taxAmount.toStringAsFixed(2));
  }

  /// Calculates the Annual Homeowners Insurance Premium based on a Rate Per Thousand.
  ///
  /// Rate: 7.0 per $1,000 of the dwelling coverage amount (replacement cost).
  double calculateHomeownersInsurancePremium({
    required double
    dwellingCoverageAmount, // The estimated replacement cost of the home
  }) {
    // --- Constant for the Annual Insurance Rate ---
    const double annualRatePerThousand = 7.0;

    if (dwellingCoverageAmount <= 0) {
      return 0.0;
    }

    // Formula: (Dwelling Coverage Amount / 1,000) * Rate Per Thousand
    // This calculates how many thousands of coverage are needed, then applies the rate.
    final double annualPremium =
        (dwellingCoverageAmount / 1000.0) * annualRatePerThousand;

    // Round result to two decimal places for currency.
    return double.parse(annualPremium.toStringAsFixed(2));
  }

  // ------------------------------- Fixed Closing Costs For Buyer --------------------------------//

  double calculateOriginationDiscountFee() {
    return loanAmount * 0.01;
  }

  double calculateAnnualMortgageInsurance() {
    // Typically 1.25%/0.83%  of the base loan amount for most FHA loans
    return loanAmount * 0.0125;
  }

  double calculateMonthlyMortgageInsurance() {
    // Typically 1.25% of the base loan amount annually, divided by 12 for monthly
    // return 283.33;
    return calculateAnnualMortgageInsurance() / 12;
  }

  double calculateVAFundingFee() {
    // VA funding fee varies (typically 2.15% for first-time use)
    return loanAmount * 0.0215;
  }

  /// Returns the closing costs for the current loan type
  ClosingCost getFixedClosingCosts() {
    switch (loanType) {
      case LoanType.conventional:
        return ClosingCost(
          appraisal: FinancialConstants.convAppraisalFee,
          creditReport: FinancialConstants.creditReportFee,
          floodCertification: FinancialConstants.floodCertificationFee,
          underwritingProcessing: FinancialConstants.underwritingProcessingFee,
          originationDiscount: calculateOriginationDiscountFee(),
          lendersTitlePolicy: calculateLoanTitleInsuranceCost(),
          titleEnd: FinancialConstants.titleEndFee,
          closingFee: FinancialConstants.nonCashLoanClosingFee,
          recordingFee: FinancialConstants.nonCashLoanRecordingFee,
        );

      case LoanType.fha:
        return ClosingCost(
          appraisal: FinancialConstants.fhaAppraisalFee,
          creditReport: FinancialConstants.creditReportFee,
          floodCertification: FinancialConstants.floodCertificationFee,
          underwritingProcessing: FinancialConstants.underwritingProcessingFee,
          originationDiscount: calculateOriginationDiscountFee(),
          lendersTitlePolicy: calculateLoanTitleInsuranceCost(),
          titleEnd: FinancialConstants.titleEndFee,
          closingFee: FinancialConstants.nonCashLoanClosingFee,
          recordingFee: FinancialConstants.nonCashLoanRecordingFee,
          mortgageInsurance: calculateAnnualMortgageInsurance(),
          monthlyMortgageInsurance: calculateMonthlyMortgageInsurance(),
        );

      case LoanType.va:
        return ClosingCost(
          appraisal: FinancialConstants.vaAppraisalFee,
          creditReport: FinancialConstants.creditReportFee,
          floodCertification: FinancialConstants.floodCertificationFee,
          lendersTitlePolicy: calculateLoanTitleInsuranceCost(),
          originationDiscount: calculateOriginationDiscountFee(),
          titleEnd: FinancialConstants.titleEndFee,
          recordingFee: FinancialConstants.nonCashLoanRecordingFee,
          vaFundingFee: calculateVAFundingFee(),
        );

      case LoanType.cash:
        return ClosingCost(
          closingFee: FinancialConstants.cashLoanClosingFee,
          recordingFee: FinancialConstants.cashLoanRecordingFee,
        );
    }
  }

  /// Generates a formatted email body for the quick estimate results.
  /// Includes loan details, monthly payment (PITI) and fixed closing costs
  /// appropriate for the selected `loanType`.
  Future<String> generateQuickEstimateEmailBody() async {
    final buffer = StringBuffer();
    final userSection = await _buildUserDetailsSection();

    if (userSection.isNotEmpty) {
      buffer.write(userSection);
    }

    buffer.writeln('${loanType.fullName} - Quick Estimate');
    buffer.writeln('');
    buffer.writeln(
      'Property Price: \$${propertyPriceController.toStringAsFixed(2)}',
    );
    buffer.writeln('Loan Amount: \$${loanAmount.toStringAsFixed(2)}');
    buffer.writeln('Loan Term (years): ${loanTermYears.toStringAsFixed(0)}');
    buffer.writeln(
      'Interest Rate (annual %): ${annualIntrestRatePercentage.toStringAsFixed(2)}',
    );
    buffer.writeln('Annual Tax: \$${annualTax.toStringAsFixed(2)}');
    buffer.writeln('Annual Insurance: \$${annualInsurance.toStringAsFixed(2)}');
    buffer.writeln('Monthly PITI: \$${calculatePITI().toStringAsFixed(2)}');
    buffer.writeln('');

    final fixed = getFixedClosingCosts();
    final costs = fixed.toList();
    if (costs.isNotEmpty) {
      buffer.writeln('Fixed Closing Costs:');
      for (final entry in costs) {
        // entry.key already includes a label like 'Appraisal:' and entry.value is already formatted
        buffer.writeln('${entry.key} \$${entry.value}');
      }
      buffer.writeln('');
    }

    buffer.writeln(
      'This is only an estimate. Contact your lender for detailed closing costs.',
    );
    buffer.writeln('Generated by Travel App Quick Estimate Calculator.');

    return buffer.toString();
  }

  // Local keys (same keys used in settings screen)
  static const String _kFirstNameKey = 'user_first_name';
  static const String _kLastNameKey = 'user_last_name';
  static const String _kEmailKey = 'user_email';
  static const String _kPhoneKey = 'user_phone';

  Future<String> _buildUserDetailsSection() async {
    final prefs = await SharedPreferences.getInstance();
    final first = prefs.getString(_kFirstNameKey) ?? '';
    final last = prefs.getString(_kLastNameKey) ?? '';
    final email = prefs.getString(_kEmailKey) ?? '';
    final phone = prefs.getString(_kPhoneKey) ?? '';

    final buffer = StringBuffer();
    if (first.isNotEmpty ||
        last.isNotEmpty ||
        email.isNotEmpty ||
        phone.isNotEmpty) {
      buffer.writeln('User Details:');
      if (first.isNotEmpty) buffer.writeln('First Name: $first');
      if (last.isNotEmpty) buffer.writeln('Last Name: $last');
      if (email.isNotEmpty) buffer.writeln('Email: $email');
      if (phone.isNotEmpty) buffer.writeln('Phone: $phone');
      buffer.writeln('');
    }
    return buffer.toString();
  }

  /// Generates a formatted email body for the seller net sheet results.
  /// Includes selling price, loan payoff, fees, commission and net proceeds.
  Future<String> generateNetSheetEmailBody() async {
    final buffer = StringBuffer();
    final userSection = await _buildUserDetailsSection();
    if (userSection.isNotEmpty) buffer.write(userSection);

    buffer.writeln('Seller Net Sheet - Quick Estimate');
    buffer.writeln('');

    final double sellingPrice = salePrice > 0
        ? salePrice
        : propertyPriceController;
    buffer.writeln('Selling Price: \$${sellingPrice.toStringAsFixed(2)}');
    buffer.writeln(
      'Estimated Loan Payoff: \$${estimatedLoanPayoff.toStringAsFixed(2)}',
    );
    buffer.writeln('Closing Fees: \$${closingFees.toStringAsFixed(2)}');
    buffer.writeln(
      'Seller Paids: \$${sellerToPayClosingCost.toStringAsFixed(2)}',
    );

    final double titleInsurance = calculateSellersTitleInsuranceCost();
    buffer.writeln('Title Insurance: \$${titleInsurance.toStringAsFixed(2)}');

    final double processingFees = FinancialConstants.defaultProcessingFees;
    buffer.writeln('Processing Fees: \$${processingFees.toStringAsFixed(2)}');

    final double commission = calculateSellerCommission();
    buffer.writeln(
      'Commission (${commissionPercentage.toStringAsFixed(2)}%): \$${commission.toStringAsFixed(2)}',
    );

    final double net = calculateSellerNetProceeds();
    buffer.writeln('Net Proceeds: \$${net.toStringAsFixed(2)}');
    buffer.writeln('');

    buffer.writeln(
      'This is only an estimate. Contact your closing agent or lender for detailed figures.',
    );

    return buffer.toString();
  }

  /// Generates a formatted email body for the title insurance results.
  /// Includes owner/lender policy values, seller's and loan title insurance
  /// costs, a summary of the rate tiers used for calculation, and a disclaimer.
  Future<String> generateTitleInsuranceEmailBody() async {
    final buffer = StringBuffer();
    final userSection = await _buildUserDetailsSection();
    if (userSection.isNotEmpty) buffer.write(userSection);

    buffer.writeln('Title Insurance - Estimate');
    buffer.writeln('');

    final double ownerPolicyValue = salePrice > 0
        ? salePrice
        : propertyPriceController;
    final double lenderPolicyValue = loanAmount;

    buffer.writeln(
      'Owner Policy Amount: \$${ownerPolicyValue.toStringAsFixed(2)}',
    );
    buffer.writeln(
      'Lender Policy Amount: \$${lenderPolicyValue.toStringAsFixed(2)}',
    );

    final double sellersTitleInsurance = calculateSellersTitleInsuranceCost();
    final double loanTitleInsurance = calculateLoanTitleInsuranceCost();

    buffer.writeln(
      "Seller's Title Insurance: \$${sellersTitleInsurance.toStringAsFixed(2)}",
    );
    buffer.writeln(
      'Loan Title Insurance: \$${loanTitleInsurance.toStringAsFixed(2)}',
    );
    buffer.writeln('');

    buffer.writeln(
      'This is only an estimate. Contact your title company or closing agent for exact premiums.',
    );

    return buffer.toString();
  }
}
