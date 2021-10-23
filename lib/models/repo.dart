class Repo {
  String repo_name ;
  String repo_description ;
  String repo_language ;
  int repo_watcher ;
  int open_bugs ;

  Repo({required this.repo_name, required this.repo_description, required this.repo_language,
    required this.repo_watcher, required this.open_bugs});


  factory Repo.fromJson(Map<String, dynamic> json){
    return Repo
      (repo_name: json['name'],
    repo_description: json['description'],
    repo_watcher: json['watchers'],
    repo_language: json['language'],
    open_bugs: json['open_issues']);
  }

}

class All{
  List<Repo> repos;

  All({required this.repos});

  factory All.fromJson(List<dynamic> json){
    List<Repo> repos = List.filled(10,new Repo(repo_name: 'Samarth',repo_description: 'sasf',repo_language: 'sdfdf',repo_watcher: 1,open_bugs: 1),);
    repos = json.map((r) => Repo.fromJson(r)).toList();
    return All(repos: repos);
  }
}