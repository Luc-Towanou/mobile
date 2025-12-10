// Petit utilitaire pour formater les dates sans package externe complexe
String formatDate(String dateString) {
  try {
    DateTime date = DateTime.parse(dateString);
    List<String> months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  } catch (e) {
    return dateString;
  }
}