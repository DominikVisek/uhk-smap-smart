class OpenWeatherItem {
  final int id;
  final double temp;
  final double windSpeed;
  final int clouds;
  final Map rain;
  final Map snow;

  OpenWeatherItem({
    this.id,
    this.temp,
    this.windSpeed,
    this.clouds,
    this.rain,
    this.snow
  });

  factory OpenWeatherItem.fromJson(Map<String, dynamic> json) {
    return OpenWeatherItem(
        id: json['id'],
        temp: json['main']['temp'],
        windSpeed: json['wind']['speed'],
        clouds: json['clouds']['all'],
        rain: json.containsKey('rain') ? json['rain'] : null,
        snow: json.containsKey('snow') ? json['snow'] : null
    );
  }

  @override
  String toString() {
    return this.id.toString();
  }
}
