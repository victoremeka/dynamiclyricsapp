import 'package:flutter/material.dart';
import 'Tabs/listeners.dart';
import 'Tabs/lyrics.dart';
import 'Tabs/related.dart';
import 'Tabs/up_next.dart';
import 'package:http/http.dart' as http;

class Player extends StatefulWidget {

  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  int _index = 0;
  bool isTapped = false;

  final List<String> tabNames = [
    'UP NEXT',
    'LYRICS',
    'RELATED',
  ];
  final List<Widget> tabs =  const [
    UpNext(),
    Lyrics(),
    Related(),
  ];
  
  late List<String> rawData;
  late List<String> lyrics;
  late List<int> timeStamps;
  late int songDuration;
  late ScrollController _scrollController;
  double _scrollIndex = 0; // For scroll controller
  late Stopwatch _timer;
  int _lyricIndex = -1;
  late http.Response response;
  
  void _play() async{
    isTapped = !isTapped;
    if(!_timer.isRunning) {
      _animationController.forward();
      _timer.start();
      for (int i = 0; i < timeStamps[timeStamps.length-1]; i++){
        await Future.delayed(const Duration(seconds: 1));
        if (timeStamps.contains(i) && _lyricIndex < timeStamps.length){
          _lyricIndex++;
          _lyricIndex > 0 ? 
            _scrollIndex = _scrollIndex + 48
          : _scrollIndex = 0;
          _scrollController.animateTo(
            _scrollIndex, 
            duration: const Duration(milliseconds: 450), curve: Curves.linear);
          LyricData.index.value = _lyricIndex;
        }
        if(!isTapped){
          break;
        }
      }
      } else {
        _animationController.reverse();
        _timer.stop();
      }
  }

  void _importLyrics() async{

    response = await http.get(Uri.parse('https://gist.githubusercontent.com/victoremeka/b9852605157556ae4096cf6c48526fc6/raw/a17898cbdcfec879e3aec29c86fd1f24036258c9/did_i_makae_you_up_lyrics.txt'));
    response.statusCode == 200 ?
      rawData = response.body.split('\n') // Returns an iterable object
    : throw Exception('page-not-found');

    List<String> j; // Proxy variable for timestamps
    String k; // Proxy variable for lyrics

    for (String i in rawData){

      j = i.split(':');
      k = i.replaceAll('♪', '').trim();
      i.startsWith(RegExp(r'[0-9]')) ? timeStamps.add(
        int.parse(j[0])*60 + int.parse(j[1])
      ) : setState(() => lyrics.add(k));
    }
    LyricData.lyrics.value = lyrics;
    songDuration = timeStamps[timeStamps.length -1];
  }


  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    lyrics = [];
    timeStamps = [];
    rawData = [];
    _importLyrics();
    _scrollController = ScrollController();
    _timer = Stopwatch();
  }

  @override
  void dispose(){
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: _scrollController,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 5, 31, 43),
        body: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              image: const DecorationImage(
                                image: NetworkImage("https://upload.wikimedia.org/wikipedia/en/4/4b/Half_alive_conditions_of_a_punk.png")
                              )
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                              'Did I Make You Up?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'half·alive',
                              style: TextStyle(
                                color: Colors.white54
                              ),
                            ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              _play();
                            }, 
                            color: Colors.white,
                            splashRadius: 16,
                            icon:  AnimatedIcon(
                              progress: _animationController,
                              icon: AnimatedIcons.play_pause),
                            ),
                          const Icon(
                            Icons.skip_next_rounded,
                            color: Colors.white,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 8, 57, 80),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    )
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Container(
                      height: 4,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2)
                      ),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int i = 0; i < 3; i++)
                              GestureDetector(
                                onTap: () => setState(() => _index = i),
                                child: Column(
                                  children: [
                                    Text(
                                      tabNames[i],
                                      style: TextStyle(
                                        fontWeight: _index == i ? FontWeight.bold : FontWeight.w400,
                                        color: _index == i ? Colors.white : Colors.white70
                                      )
                                    ),
                                  ],
                                )
                              ),
                          ]
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: tabs[_index]),
              ]
            ),
          ),
        )
      ),
    );
  }
}