import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(AplikasiCuaca());

class AplikasiCuaca extends StatelessWidget {
  const AplikasiCuaca({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Cuaca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BerandaCuaca(),
    );
  }
}

class BerandaCuaca extends StatefulWidget {
  const BerandaCuaca({super.key});

  @override
  _BerandaCuacaState createState() => _BerandaCuacaState();
}

class _BerandaCuacaState extends State<BerandaCuaca> {
  String _kota = '';
  String _dataCuaca = 'Masukkan nama kota untuk mendapatkan pembaruan cuaca';

  Future<void> ambilCuaca(String kota) async {
    final apiKey = '9a15a2260c3244d590e192247250501';
    final url =
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$kota&lang=id';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['current'] != null) {
          setState(() {
            _dataCuaca =
                'Kota: ${data['location']['name']}, Suhu: ${data['current']['temp_c']}°C, Kondisi: ${data['current']['condition']['text']}';
          });
        } else {
          setState(() {
            _dataCuaca = 'Tidak ada data cuaca tersedia untuk kota ini.';
          });
        }
      } else {
        setState(() {
          _dataCuaca = 'Terjadi kesalahan saat mengambil data cuaca';
        });
      }
    } catch (e) {
      setState(() {
        _dataCuaca = 'Kesalahan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Cuaca'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Masukkan Nama Kota'),
              onChanged: (value) {
                _kota = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ambilCuaca(_kota);
              },
              child: Text('Dapatkan Cuaca'),
            ),
            SizedBox(height: 20),
            Text(
              _dataCuaca,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
