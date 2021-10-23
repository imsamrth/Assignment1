import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:assignment_1/api/connectivity_provider.dart';
import 'package:assignment_1/page/No_internet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';


class repoList extends StatelessWidget {
  static const String title = 'Local Auth';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Jake`s Git',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  // We will fetch data from this Rest api
  final _baseUrl = 'https://api.github.com/users/JakeWharton/repos?page';

  // At the beginning, we fetch the first 20 posts
  int _page = 1;
  int _limit = 15;

  late APICacheDBModel cacheDBModel;
  


  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  bool _isCache = false ;

  // This holds the posts fetched from the server
  List _posts = [];

  void Network_connected() async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("API_previousFetch");
    if(!isCacheExist){

    }else{
      var cacheData = await APICacheManager().getCacheData("API_previousFetch");
      return _posts = json.decode(cacheData.syncData);
    }
  }

  // This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res =
      await http.get(Uri.parse("https://api.github.com/users/JakeWharton/repos?page=1&per_page=15"));
      setState(() {
        _posts = json.decode(res.body);
      });

      if(res.statusCode == 200){
         cacheDBModel = new APICacheDBModel(key: "API_previousFetch", syncData: res.body);
      APICacheManager().addCacheData(cacheDBModel);
      _isCache = true ;}
    } catch (err) {
      print('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        final res =
        await http.get(Uri.parse("https://api.github.com/users/JakeWharton/repos?page=" +_page.toString() +"&per_page=15"));

        final List fetchedPosts = json.decode(res.body);
        if (fetchedPosts.length > 0) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context,listen: false).startMonitoring();
    _firstLoad();
    _controller = new ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jake`s Git'),
      ),
      body: pageUI());
  }

  Widget build_home(BuildContext context) {
    return Scaffold(
        body: _isFirstLoadRunning
            ? Center(child: CircularProgressIndicator(),
        )
            : Column(
            children: [
              Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: _posts.length,
                    itemBuilder: (_, index) => Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),

                      child: Column(
                        children:[
                          ListTile(
                            title: Text(_posts[index]['name'],     style: TextStyle(fontSize: 24.0)  ),
                            subtitle: Text(_posts[index]['description'].toString(),style: TextStyle(fontSize: 16.0),),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.code_sharp,size: 25,),
                              TextButton(
                                child:Text(_posts[index]['language'].toString()),
                                onPressed: ()
                                {},
                              ),
                              SizedBox(width: 8,),
                              Icon(Icons.face,size: 25,),
                              TextButton(
                                child: Text(_posts[index]['watchers'].toString()),
                                onPressed: (){},
                              ),
                              SizedBox(width: 8,),
                              Icon(Icons.bug_report_sharp,size: 25,),
                              TextButton(
                                child: Text(_posts[index]['open_issues'].toString()),
                                onPressed: (){},
                              ),
                              SizedBox(width: 8,)
                            ],
                          ),
                        ],),


                    ),
                  )
              ),



              // when the _loadMore function is running
              if (_isLoadMoreRunning == true)
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // When nothing else to load
              if (_hasNextPage == false)
                Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 40),
                  color: Colors.amber,
                  child: Center(
                    child: Text('You have fetched all of the content'),
                  ),
                )
              ,]));
  }


  Widget build_offline(BuildContext context) {
    return Scaffold(
        body: _isFirstLoadRunning
            ? Center(child: CircularProgressIndicator(),
        )
            : Column(
            children: [
              Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (_, index) => Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),

                      child: Column(
                        children:[
                          Icon(Icons.book),


                          ListTile(

                            title: Text(_posts[index]['name'],     style: TextStyle(fontSize: 24.0)  ),
                            subtitle: Text(_posts[index]['description'].toString(),style: TextStyle(fontSize: 16.0),),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Icon(Icons.code_sharp),
                              TextButton(
                                child:Text(_posts[index]['language'].toString()),
                                onPressed: ()
                                {},
                              ),
                              SizedBox(width: 8,),
                              Icon(Icons.face),
                              TextButton(
                                child: Text(_posts[index]['watchers'].toString()),
                                onPressed: (){},
                              ),
                              SizedBox(width: 8,),
                              Icon(Icons.bug_report),
                              TextButton(
                                child: Text(_posts[index]['open_issues'].toString()),
                                onPressed: (){},
                              ),
                              SizedBox(width: 8,)
                            ],
                          ),
                        ],),


                    ),
                  )
              ),



              // When nothing else to load
              if (_isCache == true)
                Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 40),
                  color: Colors.amber,
                  child: Center(
                    child: Text('You are Offline'),
                  ),
                )
              ,]));
  }


  Widget pageUI(){
    return Consumer<ConnectivityProvider>(
      builder: (context,model,child){
        if(model.isOnline != null){

         if( model.isOnline) {
           return build_home(context);

        }
         else{
           Network_connected();

           if(_isCache){  return build_offline(context);}
           else{NoInternet();}

           }

        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),);
      },
    );
  }
}