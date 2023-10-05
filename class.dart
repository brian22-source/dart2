class Student {
  String name;
  String phoneNumber;

  Student(this.name, this.phoneNumber);

  void displayInfo() {
    print('Name: $name');
    print('Phone Number: $phoneNumber');
  }
}

void main() {
  Student student = Student("Brian Mbithi", "0756911730");
  student.displayInfo();
}
