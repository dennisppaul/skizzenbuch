import java.util.Iterator;

void setup() {
  String[] mStudentsTxt = loadStrings("students.txt");

  ArrayList<Student> mStudents = new ArrayList<Student>();
  println("+++ PARSING STUDENTS\n");

  for (int i = 0; i < mStudentsTxt.length; i++) {
    println("    " + mStudentsTxt[i]);
    mStudents.add(new Student(mStudentsTxt[i]));
  }

  println("\n+++ CREATING PAIRS STUDENTS\n");
  ArrayList<Pair> mStudentPairs = new ArrayList<Pair>();

  Iterator<Student> i = mStudents.iterator();
  while (i.hasNext()) {
    Student a = i.next();
    i.remove();

    Student b = i.next();
    i.remove();

    mStudentPairs.add(new Pair(a, b));
    println("    " + a.name + "\t>\t" + b.name);
  }

  println("\n+++ SAVING SELECTED STUDENTS\n");
  String[] mSelectedStudentsTxt = new String[mStudentPairs.size()];
  for (int j = 0; j < mSelectedStudentsTxt.length; j++) {
    mSelectedStudentsTxt[j] = mStudentPairs.get(j).a.name + "\t" + mStudentPairs.get(j).b.name;
  }
  saveStrings("data/student_pairs.txt", mSelectedStudentsTxt);

  exit();
}

class Student {
  Student(String pName) {
    name = pName;
  }
  String name;
}

class Pair {
  Pair(Student pA, Student pB) {
    a = pA;
    b = pB;
  }
  Student a;
  Student b;
}
