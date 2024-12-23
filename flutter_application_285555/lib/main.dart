import 'package:flutter/material.dart';
import 'package:http/http.dart' as ht

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Stethoscope App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Stethoscope Home'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stethoscope image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/stethoscope.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to Digital Stethoscope',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Monitor your health remotely',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VoltageFetcher()),
                  );
                },
                child: Text('Connect to ESP8266 and View Voltage Reading'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DoctorContactPage()),
                  );
                },
                child: Text('Contact Doctor'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VoltageFetcher extends StatefulWidget {
  @override
  _VoltageFetcherState createState() => _VoltageFetcherState();
}

class _VoltageFetcherState extends State<VoltageFetcher> {
  String voltage = "Fetching...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVoltage();
  }

  Future<void> _fetchVoltage() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Replace with the IP address of your ESP8266
      final response = await http.get(Uri.parse('http://192.168.4.1/voltage'));

      if (response.statusCode == 200) {
        setState(() {
          voltage =
              response.body; // Assuming the response contains voltage data
        });
      } else {
        setState(() {
          voltage = "Error: ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        voltage = "Error: Unable to connect to ESP8266.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voltage Reader'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Voltage Reading: $voltage'),
                  ElevatedButton(
                    onPressed: () => _fetchVoltage(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
    );
  }
}

class DoctorContactPage extends StatelessWidget {
  final List<String> doctors = [
    'Dr. John Doe - Cardiologist',
    'Dr. Jane Smith - Pediatrician',
    'Dr. Emily Davis - General Physician',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Doctor'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(doctors[index]),
                trailing: Icon(Icons.phone, color: Colors.blueAccent),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Contacting ${doctors[index]}'),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
