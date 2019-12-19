package de.hfkbremen.mesh.sandbox;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * add hair support for processing lines
 * - http://www.luxrender.net/wiki/Scene_file_format_dev#Hairfileshape
 * - http://www.cemyuksel.com/research/hairmodels/
 * <p>
 * <p>
 * HAIR File Format Specification
 * This is a binary file format for 3D hair models. The 3D hair model consists of strands, each one of which is represented by a number of line segments. A HAIR file begins with a 128-Byte long header followed by the following arrays (in presented order) that keep the geometry and topology data:
 * <p>
 * Segments array (unsigned short)
 * This array keeps the number of segments of each hair strand. Each entry is a 16-bit unsigned integer, therefore each hair strand can have up to 65,536 segments.
 * <p>
 * Points array (float)
 * This array keeps the 3D vertices each of hair strand point. These points are not shared by different hair strands; each point belongs to a particular hair strand only. Line segments of a hair strand connects consecutive points. The points in this array are ordered by strand and from root to tip; such that it begins with the root point of the first hair strand, continues with the next point of the first hair strand until the tip of the first hair strand, and then comes the points of the next hair strands. Each entry is a 32-bit floating point number, and each point is defined by 3 consecutive numbers that correspond to x, y, and z coordinates.
 * <p>
 * Thickness array (float)
 * This array keeps the thickness of hair strands at point locations, therefore the size of this array is equal to the number of points. Each entry is a 32-bit floating point number.
 * <p>
 * Transparency array (float)
 * This array keeps the transparency of hair strands at point locations, therefore the size of this array is equal to the number of points. Each entry is a 32-bit floating point number.
 * <p>
 * Color array (float)
 * This array keeps the color of hair strands at point locations, therefore the size of this array is three times the number of points. Each entry is a 32-bit floating point number, and each color is defined by 3 consecutive numbers that correspond to red, green, and blue components.
 * <p>
 * A HAIR file must have a points array, but all the other arrays are optional. When an array does not exist, corresponding default value from the file header is used instead of the missing array.
 * <p>
 * <p>
 * HAIR File Header (128 Bytes)
 * <p>
 * Bytes 0-3	Must be "HAIR" in ascii code (48 41 49 52)
 * Bytes 4-7	Number of hair strands as unsigned int
 * Bytes 8-11	Total number of points of all strands as unsigned int
 * Bytes 12-15	Bit array of data in the file
 * Bit-0 is 1 if the file has segments array.
 * Bit-1 is 1 if the file has points array (this bit must be 1).
 * Bit-2 is 1 if the file has thickness array.
 * Bit-3 is 1 if the file has transparency array.
 * Bit-4 is 1 if the file has color array.
 * Bit-5 to Bit-31 are reserved for future extension (must be 0).
 * Bytes 16-19	Default number of segments of hair strands as unsigned int
 * If the file does not have a segments array, this default value is used.
 * Bytes 20-23	Default thickness hair strands as float
 * If the file does not have a thickness array, this default value is used.
 * Bytes 24-27	Default transparency hair strands as float
 * If the file does not have a transparency array, this default value is used.
 * Bytes 28-39	Default color hair strands as float array of size 3
 * If the file does not have a thickness array, this default value is used.
 * Bytes 40-127	File information as char array of size 88 in ascii
 */

public class LuxRender {

    private static String LUX_RENDERER_BINARY_PATH = "/usr/local/bin/luxconsole";
    private static String OUTPUT_PATH = "/Users/dennisppaul/Desktop/foo1.png";

    public static void _main(String[] args) {
        try {
            /* assemble shell command */
            String myParameter = LUX_RENDERER_BINARY_PATH;
            String[] myExecString = new String[]{myParameter,
                                                 // this might make noise in animations more stable
                                                 "--fixedseed",
                                                 // output path
                                                 "--output",
                                                 OUTPUT_PATH,
                                                 "/Applications/LuxRender/examples/custom_render_scene/custom_render_scene.lxs"};
            Process myProcess = Runtime.getRuntime().exec(myExecString);
            BufferedReader br = new BufferedReader(new InputStreamReader(myProcess.getInputStream()));

            //            /* assemble query */
            //            OutputStream myOutputStream = myProcess.getOutputStream();
            //            myOutputStream.write(String.valueOf(pDimensions).getBytes());
            //            myOutputStream.write('\n');
            //            myOutputStream.write(String.valueOf(pPoints.length).getBytes());
            //            myOutputStream.write('\n');
            //            for (Vector3f pPoint : pPoints) {
            //                if (pDimensions == 3) {
            //                    String myVectorString = pPoint.x + " " + pPoint.y + " " + pPoint.z;
            //                    myOutputStream.write(myVectorString.getBytes());
            //                } else if (pDimensions == 2) {
            //                    String myVectorString = pPoint.x + " " + pPoint.y;
            //                    myOutputStream.write(myVectorString.getBytes());
            //                }
            //                myOutputStream.write('\n');
            //            }
            //            myOutputStream.close();

            //            BufferedWriter writer = new BufferedWriter(new FileWriter("/Applications/LuxRender/examples/custom_render_scene/out.raw"));
            //
            //            byte[] buffer = new byte[1000];
            //            int nRead;
            //            while((nRead = br.read()) != -1) {
            //                // Convert to String so we can display it.
            //                // Of course you wouldn't want to do this with
            //                // a 'real' binary file.
            ////                System.out.println(new String(buffer));
            //                writer.write(nRead);
            //            }
            //            writer.close();
            //            br.close();

            //            /* collect result */
            //            //            BufferedWriter writer = new BufferedWriter(new FileWriter("/Applications/LuxRender/examples/custom_render_scene/out.raw"));
            //            final StringBuilder myResult = new StringBuilder();
            //            String myLine;
            //            while ((myLine = br.readLine()) != null) {
            //                //                System.out.println("----------------------");
            //                myResult.append(myLine);
            //                myResult.append('\n');
            //                System.out.println(myLine);
            //                //                writer.write(myLine);
            //            }

            /* open  */

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    static class StreamGobbler extends Thread {

        InputStream is;
        String type;

        StreamGobbler(InputStream is, String type) {
            this.is = is;
            this.type = type;
        }

        public void run() {
            try {
                InputStreamReader isr = new InputStreamReader(is);
                BufferedReader br = new BufferedReader(isr);
                String line;
                while ((line = br.readLine()) != null) {
                    System.out.println(type + ">" + line);
                }
            } catch (IOException ioe) {
                ioe.printStackTrace();
            }
        }
    }

    public static void main(String args[]) {
        try {
            String osName = System.getProperty("os.name");
            System.out.println("+++ current OS: " + osName);
            String[] cmd = new String[5];
            if (osName.equals("Mac OS X")) {
                cmd[0] = LUX_RENDERER_BINARY_PATH;
                cmd[1] = "--output";
                cmd[2] = OUTPUT_PATH;
                cmd[3] = "--fixedseed";
                cmd[4] = "/Applications/LuxRender/examples/custom_render_scene/custom_render_scene.lxs";
            } else if (osName.startsWith("Win")) {
                cmd[0] = "cmd.exe";
                cmd[1] = "/C";
                cmd[2] = "dir *.java";
            }

            Runtime rt = Runtime.getRuntime();
            System.out.println("Execing " + cmd[0] + " " + cmd[1] + " " + cmd[2]);
            Process proc = rt.exec(cmd);

            StreamGobbler errorGobbler = new StreamGobbler(proc.getErrorStream(), "ERROR");
            StreamGobbler outputGobbler = new StreamGobbler(proc.getInputStream(), "OUTPUT");
            errorGobbler.start();
            outputGobbler.start();

            int exitVal = proc.waitFor();
            System.out.println("+++ ExitValue: " + exitVal);

            // open results
            if (osName.equals("Mac OS X")) {
                Runtime.getRuntime().exec(new String[]{"open", OUTPUT_PATH});
            }
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }
}
