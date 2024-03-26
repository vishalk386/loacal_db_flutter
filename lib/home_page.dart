import 'package:flutter/material.dart';
import 'package:local_db_flutter/hive_methods.dart';
import 'package:local_db_flutter/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HiveMethods hiveMethods = HiveMethods();
  List<UserModel> users = [];
  bool isLoading = true;

  double weight = 0;
  double height = 0;
  int age = 0;
  double bmrResult = 0;
  bool isMale = true;


  @override
  void initState() {
    super.initState();

    fetchUsers();
    print(users.length);
  }

  void fetchUsers() async {
    var usersData = await hiveMethods.getUserLists();
    if (usersData.isNotEmpty) {
      users.addAll(usersData);
    }
    setState(() {
      isLoading = false;
    });
  }

  // void addUser() {
  //   hiveMethods.addUser(
  //       UserModel(id: 1, username: 'vishal', email: 'vishal@gmail.com'));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive DB'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (BuildContext context, index) {
            return UserCard(
              result: users[index].resultType,
              date: users[index].currentDate,
              category: users[index].category, resultColor: users[index].categoryColor,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // addUser();
          _showUserInputDialog(context);
        },
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ),
    );
  }


  void _showUserInputDialog(BuildContext context) {
    TextEditingController weightController = TextEditingController();
    TextEditingController heightController = TextEditingController();
    TextEditingController genderController = TextEditingController();
    String selectedCategory = 'BMI'; // Default category

    // Map to store fixed colors for each category
    Map<String, Color> categoryColors = {
      'BMI': Colors.blue,
      'BMR': Colors.green,
      'Due Date': Colors.orange,
      'Calories': Colors.red,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter User Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                  ),
                ),
                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                  ),
                ),
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: ['BMI', 'BMR', 'Due Date', 'Calories']
                      .map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                double weight = double.tryParse(weightController.text) ?? 0.0;
                double height = double.tryParse(heightController.text) ?? 0.0;
                String gender = genderController.text;

                // Process the user input and create a new UserModel object
                UserModel newUser = UserModel(
                  id: 11,
                  // You can set the id accordingly
                  username: 'vishal',
                  // You can set the username accordingly
                  email: 'vishal@gmail.com',
                  // You can set the email accordingly
                  weight: weight,
                  height: height,
                  gender: gender,
                  result: 0,
                  resultType: 'normal',
                  // You can set the result accordingly
                  category: selectedCategory,
                  resultColor: Colors.transparent,
                  // You can set the result color accordingly
                  currentDate: DateTime.now(),
                  // Set the current date
                  categoryColor: categoryColors[selectedCategory] ??
                      Colors.transparent,
                );

                // Create an instance of HiveMethods
                HiveMethods hiveMethods = HiveMethods();

                // Call the saveUser method to save the UserModel object
                await hiveMethods.addUser(newUser);

                print('User saved successfully.');
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

}

class UserCard extends StatelessWidget {
  final String result;
  final DateTime date;
  final String category;
  final Color resultColor;

  UserCard({
    required this.result,
    required this.date,
    required this.category,
    required this.resultColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(8),
        color: resultColor, // Set the color of the Card
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              Container(
                width: 10, // Adjust the width as needed
                height: 100,
                color: Colors.cyanAccent,
              ),
              SizedBox(width: 8), // Add spacing between the leading view and the text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Result: $result',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Date: ${date.toString()}'),
                  ],
                ),
              ),
            ],
          ),
          trailing: Chip(
            backgroundColor: Colors.blue,
            label: Text(category),
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
