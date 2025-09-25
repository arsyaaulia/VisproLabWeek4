import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_state_package/global_state_package.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

  void _showEditLabelDialog(BuildContext context, GlobalState globalState, int index) {
    final TextEditingController _controller = TextEditingController(text: globalState.counters[index].label);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Ubah Label Counter'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Label Baru'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Simpan'),
              onPressed: () {
                globalState.updateCounterLabel(index, _controller.text);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  void _showColorPickerDialog(BuildContext context, GlobalState globalState, int index) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Pilih Warna'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: globalState.counters[index].color,
              onColorChanged: (Color color) {
                globalState.updateCounterColor(index, color);
                Navigator.of(dialogContext).pop();
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Global State Counters'),
        ),
        body: Consumer<GlobalState>(
          builder: (context, globalState, child) {
            if (globalState.counters.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada Counter. \nTekan tombol +',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            return ReorderableListView(
              onReorder:(oldIndex, newIndex) {
                globalState.reorderCounters(oldIndex, newIndex);
              },

              children: globalState.counters.asMap().entries.map((entry) {
                final index = entry.key;
                final counter = entry.value;
                return ListTile(
                  key: ValueKey(counter.hashCode),
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: counter.color,
                  ),
                  title: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation){
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      key: ValueKey<int>(counter.value),
                      child: Text(
                        '${counter.label}: ${counter.value}',
                        style: TextStyle(color: counter.color),
                      )
                    )
                  ),
                  
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: (){
                          _showEditLabelDialog(context, globalState, index);
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.palette),
                        onPressed: (){
                          _showColorPickerDialog(context, globalState, index);
                        }
                      ),

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
              }) .toList(),
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<GlobalState>(
              context, listen: false
            ).addCounter();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}