enum LoanType {
  conventional,
  fha,
  va,
  cash;

  String get fullName {
    switch (this) {
      case LoanType.conventional:
        return "Conventional (Conv) Loan";
      case LoanType.fha:
        return "Federal Housing Administration (FHA) Loan";
      case LoanType.va:
        return "Veterans Affairs (VA) Loan";
      case LoanType.cash:
        return "Cash Purchase";
    }
  }

  String get abbreviation {
    switch (this) {
      case LoanType.conventional:
        return "Conv";
      case LoanType.fha:
        return "FHA";
      case LoanType.va:
        return "VA";
      case LoanType.cash:
        return "CASH";
    }
  }
}
