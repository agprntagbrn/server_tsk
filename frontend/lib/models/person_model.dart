class Person {
  final String nama;
  final String nim;
  final String jurusan;

  const Person({
    required this.nama,
    required this.nim, 
    required this.jurusan,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    nama: json['nama'] as String,
    nim: json['nim'] as String,
    jurusan: json['jurusan'] as String,
  );

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'nim': nim,
    'jurusan': jurusan,
  };

  @override
  List<Object> get props => [nama, nim, jurusan];

  @override
  String toString() => 'Person(nama: $nama, nim: $nim, jurusan: $jurusan)';
}