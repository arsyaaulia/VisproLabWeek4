import 'package:flutter/material.dart';
import 'dart:math';

class Counter{
  int value;
  Color color;
  String label;

  Counter({
    required this.value,
    required this.color,
    this.label = 'Counter'
  });
}

class GlobalState extends ChangeNotifier{
  final List<Counter> _counters=[];

  List<Counter> get counters => _counters;

  void addCounter(){
    final random = Random();
    final color = Color.fromRGBO(
      random.nextInt(256), 
      random.nextInt(256), 
      random.nextInt(256), 
      1.0,
    );
    _counters.add(Counter(value: 0, color: color));
    notifyListeners();
  }

  void removeCounterAt(int index){
    if (index >= 0 && index < _counters.length){
      _counters.removeAt(index);
      notifyListeners();
    }
  }

  void incrementCounter(int index){
    if(index >= 0 && index < _counters.length){
      _counters[index].value++;
      notifyListeners();
    }
  }

  void decrementCounter(int index){
    if (index >= 0 && index < _counters.length){
      if(_counters[index].value > 0){
        _counters[index].value--;
        notifyListeners();
      }
    }
  }

  void updateCounterColor(int index, Color newColor){
    if (index >= 0 && index < _counters.length){
      _counters[index].color = newColor;
      notifyListeners();
    }
  }

  void updateCounterLabel(int index, String newLabel) {
    if (index >= 0 && index < _counters.length) {
      _counters[index].label = newLabel;
      notifyListeners(); 
    }
  }

  void reorderCounters(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final counter = _counters.removeAt(oldIndex);
    _counters.insert(newIndex, counter);
    notifyListeners();
  }
}