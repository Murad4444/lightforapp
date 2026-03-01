import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ota_update/ota_update.dart';

void main() => runApp(const MaterialApp(
      home: MyApp1(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp1 extends StatefulWidget {
  const MyApp1({super.key});

  @override
  State<MyApp1> createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  // --- НАСТРОЙКИ OTA ---
  final String currentVersion = "1.0.0"; 
  final String jsonUrl = "https://raw.githubusercontent.com/Murad4444/lightforapp/refs/heads/main/version.json";
  // ----------------------

  double myOpacity = 0.5;
  double myopacity1 = 0.5;
  double myopacity2 = 0.5;
  String textlight = "Traffic Light";
  
  bool isUpdating = false;
  String updateStatus = "";

  @override
  void initState() {
    super.initState();
    // Автоматическая проверка при старте
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    try {
      final response = await http.get(Uri.parse(jsonUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Если версия на Гитхабе НЕ РАВНА текущей
        if (data['version'] != currentVersion) {
          setState(() {
            isUpdating = true;
            updateStatus = "Найдено обновление: ${data['version']}";
          });
          executeOtaUpdate(data['url']);
        }
      }
    } catch (e) {
      debugPrint("Ошибка сети: $e");
    }
  }

  void executeOtaUpdate(String url) {
    try {
      OtaUpdate().execute(url).listen((OtaEvent event) {
        setState(() {
          updateStatus = "Загрузка: ${event.value}%";
        });
      }, onError: (e) {
        setState(() {
          isUpdating = false;
          textlight = "Ошибка загрузки";
        });
      });
    } catch (e) {
      setState(() => isUpdating = false);
    }
  }

  // Твои функции светофора
  void _stop() => setState(() { myOpacity = 1.0; myopacity1 = 0.5; myopacity2 = 0.5; textlight = "STOP!"; });
  void _ready() => setState(() { myopacity1 = 1.0; myOpacity = 0.5; myopacity2 = 0.5; textlight = "BE READY!"; });
  void _GO() => setState(() { myopacity2 = 1.0; myOpacity = 0.5; myopacity1 = 0.5; textlight = "GO!"; });

  @override
  Widget build(BuildContext context) {
    if (isUpdating) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.amber),
              const SizedBox(height: 20),
              Text(updateStatus, style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Traffic Light OTA"), backgroundColor: Colors.blueGrey),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(textlight, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _lightButton(Colors.red, myOpacity, _stop),
            const SizedBox(height: 20),
            _lightButton(Colors.yellow, myopacity1, _ready),
            const SizedBox(height: 20),
            _lightButton(Colors.green, myopacity2, _GO),
          ],
        ),
      ),
    );
  }

  Widget _lightButton(Color color, double opacity, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(opacity),
          shape: BoxShape.circle,
          boxShadow: [
            if (opacity == 1.0) BoxShadow(color: color.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)
          ],
        ),
      ),
    );
  }
}
