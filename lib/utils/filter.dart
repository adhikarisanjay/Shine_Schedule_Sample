final filters = [
  Filters(filterPath: 'look1.deepar', imagePath: 'beauty.jpg'),
  Filters(filterPath: 'look2.deepar', imagePath: 'beauty.jpg'),
  Filters(filterPath: 'MakeupLook.deepar', imagePath: 'MakeupLook.png'),
  Filters(
      filterPath: 'Split_View_Look.deepar', imagePath: 'Split_View_Look.jpg'),
];

class Filters {
  String imagePath;
  String filterPath;
  Filters({required this.filterPath, required this.imagePath});
}
