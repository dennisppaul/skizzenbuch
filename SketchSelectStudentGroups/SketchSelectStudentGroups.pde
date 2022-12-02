ArrayList<Student> mStudents = new ArrayList<>(); //<>//
ArrayList<StudentGroup> mStudentGroups = new ArrayList<>();
static final int NUM_OF_GROUPS = 3;
static final int LEFT_OVER = -1;
static final String LEFT_OVER_TOKE = "L";

void setup() {
    String[] mStudentsTxt = loadStrings("students.txt");
    println("+++ PARSING " + mStudentsTxt.length + " STUDENTS\n");
    for (int i = 0; i < mStudentsTxt.length; i++) {
        if (mStudentsTxt[i] != null && mStudentsTxt[i].length()>0) {
            println("    " + mStudentsTxt[i]);
            mStudents.add(new Student(mStudentsTxt[i]));
        }
    }
    final int mNumOfStudents = mStudents.size();
    final int mNumOfStudentsPerGroup = mNumOfStudents / NUM_OF_GROUPS;

    print("\n+++ CREATING " + NUM_OF_GROUPS + " groups with " + mNumOfStudentsPerGroup + " students per group");
    final int mNumOfLeftOVerStudents = mStudentsTxt.length - NUM_OF_GROUPS * mNumOfStudentsPerGroup;
    if (mNumOfLeftOVerStudents > 0) {
        print(". " + mNumOfLeftOVerStudents + " student(s) will be left over");
    }
    println(".");


    println("\n+++ SELECTING STUDENTS\n");
    for (int j = 0; j < NUM_OF_GROUPS; j++) {
        println("+++ GROUP: " + j);
        StudentGroup mGroup = new StudentGroup(j);
        for (int i = 0; i < mNumOfStudentsPerGroup; i++) {
            int r = (int)random(mStudents.size());
            Student s = mStudents.remove(r);
            mGroup.students.add(s);
            println("    " + s.name);
        }
        mStudentGroups.add(mGroup);
    }
    if (mNumOfLeftOVerStudents > 0) {
        println("+++ LEFT OVER STUDENTS");
        StudentGroup mLeftOverGroup = new StudentGroup(LEFT_OVER);
        mLeftOverGroup.students = mStudents;
        for (int i = 0; i < mLeftOverGroup.students.size(); i++) {
            println("    " + mLeftOverGroup.students.get(i).name);
        }
        mStudentGroups.add(mLeftOverGroup);
    }

    println("\n+++ SAVING STUDENT GROUPS\n");
    String[] mSelectedStudentsTxt = new String[mNumOfStudents];
    int mLine = 0;
    for (int i = 0; i < mStudentGroups.size(); i++) {
        for (int j = 0; j < mStudentGroups.get(i).students.size(); j++) {
            final String mGroupID = mStudentGroups.get(i).ID >= 0 ? nf(mStudentGroups.get(i).ID, LEFT_OVER_TOKE.length()) : LEFT_OVER_TOKE;
            final String mStudentInGroup = mGroupID + "\t" + mStudentGroups.get(i).students.get(j).name;
            mSelectedStudentsTxt[mLine] = mStudentInGroup;
            println("    " + mSelectedStudentsTxt[mLine]);
            mLine++;
        }
    }
    saveStrings("data/selected_students.txt", mSelectedStudentsTxt);

    exit();
}

class Student {
    final String name;
    Student(String pName) {
        name = pName;
    }
}

class StudentGroup {
    final int ID;
    ArrayList<Student> students = new ArrayList<Student>();
    StudentGroup(int pID) {
        ID = pID;
    }
}
