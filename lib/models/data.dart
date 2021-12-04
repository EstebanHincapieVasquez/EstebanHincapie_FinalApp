class Data {
  String author = '';
  String content = '';
  String date = '';
  String imageUrl = '';
  String? readMoreUrl = '';
  String time = '';
  String title = '';
  String url = '';
  int logintype = 0;

  Data({
    required this.author,
    required this.content,
    required this.date,
    required this.imageUrl,
    required this.readMoreUrl,
    required this.time,
    required this.title,
    required this.url,
    required this.logintype
    });

  Data.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    content = json['content'];
    date = json['date'];
    imageUrl = json['imageUrl'];
    readMoreUrl = (json['readMoreUrl']==null)?'':json['readMoreUrl'];
    time = json['time'];
    title = json['title'];
    url = json['url'];
    logintype = json['logintype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = author;
    data['content'] = content;
    data['date'] = date;
    data['imageUrl'] = imageUrl;
    data['readMoreUrl'] = readMoreUrl;
    data['time'] = time;
    data['title'] = title;
    data['url'] = url;
    data['logintype'] = logintype;
    return data;
  }
}