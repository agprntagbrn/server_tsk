const express = require("express");
const cors = require("cors");
const mysql = require('mysql');
const app = express();

// Enable CORS
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const port = 3000;

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'flutter-mysql'
});

// Connect to MySQL
db.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL: ' + err.stack);
        return;
    }
    console.log('Connected to MySQL as ID ' + db.threadId);
});

app.listen(port, () => {
    console.log(`Successfully connected to ${port}`);
});

// POST API
app.post("/api/add_person", (req, res) => {
    const { nama, nim, jurusan } = req.body;

    const query = "INSERT INTO person (nama, nim, jurusan) VALUES (?, ?, ?)";
    db.query(query, [nama, nim, jurusan], (err, result) => {
        if (err) {
            console.error("Error inserting person: ", err);
            return res.status(500).send({
                "Status_code": 500,
                "Message": "Error adding person data"
            });
        }
        
        res.status(200).send({
            "Status_code": 200,
            "Message": "Person data is added successfully",
            "person": { id: result.insertId, nama, nim, jurusan }
        });
    });
});

// GET API
app.get("/api/get_person", (req, res) => {
    const query = "SELECT * FROM person";
    db.query(query, (err, results) => {
        if (err) {
            console.error("Error retrieving persons: ", err);
            return res.status(500).send({
                "Status_code": 500,
                "Message": "Error retrieving person data"
            });
        }
        res.status(200).send({
            "Status_code": 200,
            "Message": "Person data retrieved successfully",
            "persons": results
        });
    });
});

// UPDATE API
app.put("/api/update_person/:id", (req, res) => {
    const id = parseInt(req.params.id, 10);
    const { nama, nim, jurusan } = req.body;

    const query = "UPDATE person SET nama = ?, nim = ?, jurusan = ? WHERE id = ?";
    db.query(query, [nama, nim, jurusan, id], (err, result) => {
        if (err) {
            console.error("Error updating person: ", err);
            return res.status(500).send({
                "Status_code": 500,
                "Message": "Error updating person data"
            });
        }
        if (result.affectedRows === 0) {
            return res.status(404).send({
                "Status_code": 404,
                "Message": "Person not found"
            });
        }
        res.status(200).send({
            "Status_code": 200,
            "Message": "Person updated successfully!"
        });
    });
});

// DELETE API
app.delete("/api/delete/:id", (req, res) => {
    const id = parseInt(req.params.id, 10);
    const query = "DELETE FROM person WHERE id = ?";
    
    db.query(query, [id], (err, result) => {
        if (err) {
            console.error("Error deleting person: ", err);
            return res.status(500).send({
                "Status_code": 500,
                "Message": "Error deleting person data"
            });
        }
        if (result.affectedRows === 0) {
            return res.status(404).send({
                "Status_code": 404,
                "Message": "Person not found"
            });
        }
        res.status(200).send({
            "Status_code": 200,
            "Message": "Person deleted successfully!"
        });
    });
});
