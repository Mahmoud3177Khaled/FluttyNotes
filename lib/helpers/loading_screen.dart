import 'dart:async';

import 'package:firstfluttergo/constants/colors.dart';
import 'package:firstfluttergo/helpers/loading_controller.dart';
import 'package:flutter/material.dart';

class LoadingScreen {
  
  static final LoadingScreen _onlyInstance = LoadingScreen._sharedInctance();
  LoadingScreen._sharedInctance();
  factory LoadingScreen() => _onlyInstance;

  LoadingController? controller;

  LoadingController showOverlay({required BuildContext context, required String text}) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size; 

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.5,
                    maxHeight: size.height * 0.15,
                    // minWidth: size.width * 0.1,
                    // minHeight: size.height * 0.1,
                  ),
                
                  decoration: BoxDecoration(
                    color: const Color(0xFFe5e5e5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:  Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        
                        children: [
                          const SizedBox(height: 10),
                      
                          const CircularProgressIndicator(
                            color: maintheme,
                          ),
                    
                          const SizedBox(height: 20),
                  
                          StreamBuilder(
                            stream: _text.stream, 
                            builder: (context, snapshot) {
                              if(snapshot.hasData) {
                                return Text(
                                  snapshot.data.toString(),
                                  textAlign: TextAlign.center, 
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600
                                  ), 
                                );
                              } else {
                                return Container();
                              }
                      
                      
                            },
                            
                          )
                        ],
                      )
                      
                    ),
                  )
                ),
              ],
            ),
          ),
        );
      },
      
    );
  
    state.insert(overlay);

    return LoadingController(close: () {
      _text.close();
      overlay.remove();
      return true;
    }, 
    update: (text) {
      _text.add(text);
      return true;
    },);
  }

  void show({required BuildContext context, required String text}) {
    if(controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(context: context, text: text);
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }
}