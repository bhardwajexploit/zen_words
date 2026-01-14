
class QuotesModel {
  final String q;
  final String a;
  QuotesModel({required this.a, required this.q});
  factory QuotesModel.fromJson(Map<String,dynamic> json){
    return QuotesModel(
      q: json['q'],
      a: json['a'],
    );
  }
    Map<String,dynamic> toJson() {
    return
      {
        'q':q,
        'a':a,
      };

  }
}