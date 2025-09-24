import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_state_package/global_state_package.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalState(),
      child: const CounterApp(),
    ),
  );
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Global State Counters'),
          
        ),
        body: Consumer<GlobalState>(
          builder: (context, globalState, child) {
            if (globalState.counters.isEmpty){
              return const Center(
                child: Text(
                  'Belum ada Counter. \nTekan tombol +',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              itemCount: globalState.counters.length,
              itemBuilder: (context, index) {
                final counter = globalState.counters[index];
                return ListTile(
                  title: Text(
                    '${counter.label}: ${counter.value}',
                    style: TextStyle(color: counter.color),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          globalState.decrementCounter(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          globalState.incrementCounter(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          globalState.removeCounterAt(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),

        floatingActionButton: Center(
          heightFactor: 1.0,
          child: FloatingActionButton(
            onPressed: () {
              Provider.of<GlobalState>(
                context, listen: false
              ). addCounter();
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}