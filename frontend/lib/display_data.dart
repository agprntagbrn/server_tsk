import 'package:flutter/material.dart';
import 'package:frontend/services/Api.dart';

class DisplayScreen extends StatefulWidget {
  @override
  DisplayScreenState createState() => DisplayScreenState();
}

class DisplayScreenState extends State<DisplayScreen> {
  List<dynamic> personData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPersonData();
  }

  Future<void> fetchPersonData() async {
    try {
      setState(() => isLoading = true);
      var data = await Api.getPerson();
      setState(() {
        personData = data['persons'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        personData = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Gagal memuat data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Person Data Display'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchPersonData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchPersonData,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : personData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning, size: 50, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No person data available.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : _buildPersonList(),
      ),
    );
  }

  Widget _buildPersonList() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.greenAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: personData.length,
        itemBuilder: (context, index) {
          final person = personData[index];
          return _buildPersonCard(person);
        },
      ),
    );
  }

  Widget _buildPersonCard(Map<String, dynamic> person) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _showPersonDetails(person),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(
              Icons.person_2,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Nama: ${person['nama']}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NIM: ${person['nim']}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Jurusan: ${person['jurusan']}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
        ),
      ),
    );
  }

  void _showPersonDetails(Map<String, dynamic> person) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Mahasiswa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailItem('Nama', person['nama']),
            _buildDetailItem('NIM', person['nim']),
            _buildDetailItem('Jurusan', person['jurusan']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
