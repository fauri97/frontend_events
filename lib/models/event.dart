class Event {
  int? id;
  String? name;
  String? description;
  int? vacancies;
  int? vacanciesFilled;

  Event(
      {this.id,
      this.name,
      this.description,
      this.vacancies,
      this.vacanciesFilled});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    vacancies = json['vacancies'];
    vacanciesFilled = json['vacanciesFilled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['vacancies'] = vacancies;
    data['vacanciesFilled'] = vacanciesFilled;
    return data;
  }
}
