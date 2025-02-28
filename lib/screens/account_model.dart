class AccountModel {
  final String accountType;
  final String accountNumber;
  final String branchName;
  final double availableBalance;

  AccountModel({
    required this.accountType,
    required this.accountNumber,
    required this.branchName,
    required this.availableBalance,
  });
}
