class Change {
  final int id;
  final String name;
  final String languageCode;

  Change(this.id, this.name, this.languageCode);

  static List<Change> languageList() {
    return <Change>[
      Change(1, 'English', 'en'),
      Change(2, 'Hindi', 'hi'),
    ];
  }
}
