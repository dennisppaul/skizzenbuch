import processing.serial.*;

void setup() {
    String mPath = getJarPath(Serial.class);
    String mName = getJarName(Serial.class);
    println(mPath + " >>> " + mName);
}

String getJarPath(Class pClass) {
    return getJarLocation(pClass).getParentFile().getAbsolutePath();
}

String getJarName(Class pClass) {
    return getJarLocation(pClass).getName();
}

File getJarLocation(Class pClass) {
    try {
        return new File(pClass.getProtectionDomain().getCodeSource().getLocation().toURI());
    } 
    catch(Exception e) {
        System.err.println("### could not find class location");
        e.printStackTrace();
    }
    return null;
}
