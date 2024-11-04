import 'package:flutter/material.dart';
import 'package:frontend/services/Api.dart';
import 'package:frontend/edit_data.dart'; // Import the edit data screen

class UpdateScreen extends StatefulWidget {
  @override
  UpdateScreenState createState() => UpdateScreenState();
}

class UpdateScreenState extends State<UpdateScreen> {
  List<dynamic> personData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPersonData();
  }

  void deletePerson(String id) async {
    try {
      await Api.deletePerson(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil dihapus')),
      );
      fetchPersonData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  Future<void> fetchPersonData() async {
    try {
      var data = await Api.getPerson();
      setState(() {
        personData = data['persons'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Person Data'),
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
                        Icon(Icons.person_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("No person data available."),
                      ],
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blueAccent, Colors.greenAccent],
                      ),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemCount: personData.length,
                      itemBuilder: (context, index) {
                        final person = personData[index];
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(
                                "Nama: ${person['nama']}", 
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("NIM: ${person['nim']}"),
                                  Text("Jurusan: ${person['jurusan']}"),
                                ],
                              ),
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                                backgroundColor: Colors.blue[100],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => EditDataScreen(
                                            initialName: person['nama'],
                                            initialNIM: person['nim'],
                                            initialJurusan: person['jurusan'],
                                            id: person['id'],
                                            onUpdate: fetchPersonData,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Konfirmasi'),
                                          content: Text('Yakin ingin menghapus data ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                deletePerson(person['id']);
                                              },
                                              child: Text('Hapus'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}