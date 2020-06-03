class PriceArea {
  List<dynamic> coordinates;
  List<List<dynamic>> multiCoordinates;
  String priceGroup;
  String priceGroupInfo;
  String polygonType;
  int areaId;


  PriceArea({this.coordinates, this.priceGroup, this.priceGroupInfo, this.polygonType, this.areaId, this.multiCoordinates});


  factory PriceArea.fromJson(Map<String, dynamic> json) {
    if (json['geometry']['type'] == 'Polygon') {
      return PriceArea(
          coordinates: json['geometry']['coordinates'],
          priceGroup: json['properties']['DISTRICT_NAME'],
          priceGroupInfo: json['properties']['TAXA'],
          polygonType: json['geometry']['type'],
          areaId: json['properties']['DISTRICT_ID']
      );
    } else {
      List<List<dynamic>> list = [];
      List<dynamic> multiList = json['geometry']['coordinates'];
      multiList.forEach((v) {
        list.add(v);
      });
      return PriceArea(
          multiCoordinates: list,
          priceGroup: json['properties']['DISTRICT_NAME'],
          priceGroupInfo: json['properties']['TAXA'],
          polygonType: json['geometry']['type'],
          areaId: json['properties']['DISTRICT_ID']
      );
    }
  }
}