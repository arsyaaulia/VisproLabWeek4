import 'package:flutter/material.dart';


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
    _counters.add(Counter(value: 0, color: Colors.blue));
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
}