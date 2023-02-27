import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Panel extends StatefulWidget {
  const Panel({super.key});

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  double panelSize = 100;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      double screenHeight = constraints.maxHeight;
      void changeSize(){
      setState(() => panelSize == 100 ? panelSize = screenHeight - ((10/100)*screenHeight) : panelSize = 100);
      }
      return Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              color: Colors.green[200],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: panelSize,
                width: double.infinity, 
                color: Colors.black,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          changeSize();
                        },
                        icon: Icon(
                          CupertinoIcons.chevron_up_chevron_down,
                          color: Colors.green[200],
                        ),
                      ),
                    ),
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment: panelSize == 100 ? Alignment.centerLeft : Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: panelSize == 100 ? 50 : 200,
                        height: panelSize == 100 ? 50 : 200,
                        color: Colors.green[200],
                      ),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      );
    });
  }
}