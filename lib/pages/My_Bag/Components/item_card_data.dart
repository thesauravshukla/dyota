/// Holds data related to an item card in the shopping cart.
/// Contains both the parsed and unparsed document IDs and the user's email.
class ItemCardData {
  final String parsedDocumentId;
  final String unparsedDocumentId;
  final String userEmail;

  const ItemCardData({
    required this.parsedDocumentId,
    required this.unparsedDocumentId,
    required this.userEmail,
  });
}
