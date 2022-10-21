ArrayList<Student> mStudents = new ArrayList<Student>();
static final String SPLIT_TOKEN = "\t";
static final int STUDENT_NAME  = 0;
static final int STUDENT_PROP  = 1;
static final int NUM_OF_FIELDS = 2;

static final int NUM_OF_SELECTED_STUDENTS = 3;

void setup() {
  println("+++ PARSING STUDENTS\n");
  String[] mStudentsTxt = loadStrings("students.txt");
  for (int i = 0; i < mStudentsTxt.length; i++) {
    String[] s = mStudentsTxt[i].split(SPLIT_TOKEN);
    if (s.length == NUM_OF_FIELDS) {
      println("    " + s[STUDENT_NAME] + " > " + s[STUDENT_PROP]);
      mStudents.add(new Student(s[STUDENT_NAME], int(s[STUDENT_PROP])));
    } else {
      println("### PROBLEM WITH: " + s[STUDENT_NAME] + " (" + s.length + ")");
    }
  }
  
  println("\n+++ SELECTING STUDENTS\n");
  ArrayList<Student> mSelectedStudents = new ArrayList<Student>();
  for (int i = 0; i < NUM_OF_SELECTED_STUDENTS; i++) {
    int r = (int)random(mStudents.size());
    Student s = mStudents.remove(r);
    mSelectedStudents.add(s);
    println("    " + s.name);
  }
  
  println("\n+++ SAVING SELECTED STUDENTS\n");
  String[] mSelectedStudentsTxt = new String[mSelectedStudents.size()];
  for (int i = 0; i < mSelectedStudentsTxt.length; i++) {
    mSelectedStudentsTxt[i] = mSelectedStudents.get(i).name;
  }
  saveStrings("data/selected_students.txt", mSelectedStudentsTxt);

  exit();
}

class Student {
  Student(String pName, int pProperty) {
    name = pName;
    property = pProperty;
  }
  String name;
  int property;
}
