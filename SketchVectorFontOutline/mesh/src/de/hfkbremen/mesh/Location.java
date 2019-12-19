package de.hfkbremen.mesh;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;

public class Location {

    public static String get() {
        try {
            return new File(Location.class.getProtectionDomain()
                                          .getCodeSource()
                                          .getLocation()
                                          .toURI()
                                          .resolve("")
                                          .getPath()).toString();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String get(String path) {
        try {
            return new File(Location.class.getProtectionDomain()
                                          .getCodeSource()
                                          .getLocation()
                                          .toURI()
                                          .resolve(path)
                                          .getPath()).toString();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static URL getURL() {
        try {
            return Location.class.getProtectionDomain().getCodeSource().getLocation();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static URL getURL(String path) {
        try {
            return new URL(Location.class.getProtectionDomain().getCodeSource().getLocation(), path);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean exists(String path) {
        return (new File(path).exists());
    }

    public static boolean exists(URL path) {
        try {
            return (new File(path.toURI()).exists());
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        System.out.println(get());
        System.out.println(get(".."));
        System.out.println(exists(get("..")));
        System.out.println(getURL(".."));
    }
}

