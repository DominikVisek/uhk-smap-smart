class Reminder {
  int id;
  String time;
  double latitude;
  double longitude;
  String name;
  String description;
  double temperature;

  Reminder({
    this.id,
    this.time,
    this.latitude,
    this.longitude,
    this.name,
    this.description,
    this.temperature
  });

  factory Reminder.fromMap(Map<String, dynamic> json) =>
      new Reminder(
          id: json["id"],
          time: json["time"],
          latitude: json["latitude"],
          longitude: json["longitude"],
          name: json["name"],
          description: json["description"],
          temperature: json['temperature']
      );

  Map<String, dynamic> toMap() =>
      {
        "id": id,
        "time": time,
        "latitude": latitude,
        "longitude": longitude,
        "name": name,
        "description": description,
        "temperature": temperature,
      };

  String getTime() {
    if(time == null){
      return time;
    }

    DateTime dt = DateTime.parse(this.time);

    return dt.hour.toString() + ":" + dt.minute.toString();
  }
}
