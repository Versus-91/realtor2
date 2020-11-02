class SelectedPropertyTypes {
  SelectedPropertyTypes(
      {this.titleTxt = '', this.isSelected = false, this.id, this.icon});

  String titleTxt;
  String icon;

  bool isSelected;
  int id;
  static List<SelectedPropertyTypes> popularFList = <SelectedPropertyTypes>[
    SelectedPropertyTypes(
      titleTxt: 'Free Breakfast',
      isSelected: false,
    ),
    SelectedPropertyTypes(
      titleTxt: 'Free Parking',
      isSelected: false,
    ),
    SelectedPropertyTypes(
      titleTxt: 'Pool',
      isSelected: true,
    ),
    SelectedPropertyTypes(
      titleTxt: 'Pet Friendly',
      isSelected: false,
    ),
    SelectedPropertyTypes(
      titleTxt: 'Free wifi',
      isSelected: false,
    ),
  ];

  static List<SelectedPropertyTypes> accomodationList = [
    SelectedPropertyTypes(
      titleTxt: 'All',
      isSelected: false,
    ),
    SelectedPropertyTypes(
      titleTxt: 'Apartment',
      isSelected: false,
    ),
    SelectedPropertyTypes(
      titleTxt: 'Home',
      isSelected: true,
    ),
    SelectedPropertyTypes(
      titleTxt: 'Villa',
      isSelected: false,
    ),
    SelectedPropertyTypes(
      titleTxt: 'Hotel',
      isSelected: false,
    ),
    SelectedPropertyTypes(
      titleTxt: 'Resort',
      isSelected: false,
    ),
  ];
}
