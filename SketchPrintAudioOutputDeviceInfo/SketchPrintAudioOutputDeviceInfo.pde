import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;
import javax.sound.sampled.TargetDataLine;
import javax.sound.sampled.*;

void printAudioOutputDeviceInfo() {
    // get information about the available source lines ( soure line == output )
    Line.Info[] sourceLineInfos = AudioSystem.getSourceLineInfo(new DataLine.Info(SourceDataLine.class, null));
    for (Line.Info sourceLineInfo : sourceLineInfos) {
        try {
            println("------------------------------------------------------------------------------");

            println(sourceLineInfo);
            // create an instance of the source line
            SourceDataLine line = (SourceDataLine) AudioSystem.getLine(sourceLineInfo);

            // get the audio format of the line
            AudioFormat format = line.getFormat();
            println(format);
            System.out.println("    sample rate  : " + format.getSampleRate());
            System.out.println("    bit depth    : " + format.getSampleSizeInBits());
            System.out.println("    channels     : " + format.getChannels());

            DataLine.Info dl = (DataLine.Info)sourceLineInfo;
            AudioFormat[] af = dl.getFormats();
            println("FORMATS: ");
            for (int i=0; i<af.length; i++) {
                println("    " + i + " : " + af[i]);
            }

            println("------------------------------------------------------------------------------");
        }
        catch (LineUnavailableException e) {
            e.printStackTrace();
        }
    }
}

void setup() {
    printAudioOutputDeviceInfo();
    exit();
}

/*
 //// Convert 32-bit PCM samples to float
 //int pcmLeft = ((pcm[3] & 0xff) << 24) | ((pcm[2] & 0xff) << 16) | ((pcm[1] & 0xff) << 8) | (pcm[0] & 0xff);
 //int pcmRight = ((pcm[7] & 0xff) << 24) | ((pcm[6] & 0xff) << 16) | ((pcm[5] & 0xff) << 8) | (pcm[4] & 0xff);
 //samples[i][0] = Float.intBitsToFloat(pcmLeft);
 //samples[i][1] = Float.intBitsToFloat(pcmRight);
 
 // Convert float samples to 32-bit PCM
 int pcmLeft = Float.floatToIntBits(sample[0]);
 int pcmRight = Float.floatToIntBits(sample[1]);
 
 // Write PCM samples to audio output
 line.write(new byte[]{(byte) (pcmLeft & 0xff), (byte) ((pcmLeft >> 8) & 0xff), (byte) ((pcmLeft >> 16) & 0xff), (byte) ((pcmLeft >> 24) & 0xff)}, 0, 4);
 line.write(new byte[]{(byte) (pcmRight & 0xff), (byte) ((pcmRight >> 8) & 0xff), (byte) ((pcmRight >> 16) & 0xff), (byte) ((pcmRight >> 24) & 0xff)}, 0, 4);
 */

/*
static final int NUM_OF_CHANNELS = 2; // STEREO
static final int BYTES_PER_SAMPLE = 2; // 32-bit
static final int BITS_PER_SAMPLE  = BYTES_PER_SAMPLE * 8;
static final int BYTES_PER_FRAME  = BYTES_PER_SAMPLE * NUM_OF_CHANNELS;
static final int SAMPLE_RATE = 48000;

void convert_FLOAT32_to_PCM32(float pFLOAT32, byte[] pPCM32_as_bytes) {
 final int pcm = Float.floatToIntBits(pFLOAT32);
 pPCM32_as_bytes[0] = (byte) (pcm & 0xff);
 pPCM32_as_bytes[1] = (byte) ((pcm >> 8) & 0xff);
 pPCM32_as_bytes[2] = (byte) ((pcm >> 16) & 0xff);
 pPCM32_as_bytes[3] = (byte) ((pcm >> 24) & 0xff);
 }
 
 void writeSamples32(SourceDataLine line, float[][] samples) {
 // NUM_OF_CHANNELS * BYTES_PER_SAMPLE = NUM_OF_BYTES_PER_RAME
 // NUM_OF_BYTES_PER_RAME * SIZE_OF_CHANNEL_FLOAT_SAMPLE_BUFFER
 byte[] s = new byte[4];
 for (float[] sample : samples) {
 for (int i=0; i < sample.length; i++) {
 // Convert float samples to 32-bit PCM
 convert_FLOAT32_to_PCM32(sample[i], s);
 // Write PCM samples to audio output
 line.write(s, 0, 4);
 }
 }
 }
 
 SourceDataLine line;
 
 void startAudioOutput() {
 try {
 for (int i=0; i < AudioSystem.getMixerInfo().length; i++) {
 println("DEVICE ID   : " + i);
 println("       INFO : " + AudioSystem.getMixerInfo()[i]);
 println("       DESCR: " + AudioSystem.getMixerInfo()[i].getDescription());
 println("       --");
 Mixer m = AudioSystem.getMixer(AudioSystem.getMixerInfo()[i]);
 Line.Info[] l = m.getSourceLineInfo();
 for (int j = 0; j < l.length; j++) {
 println("       SOURCE LINE INFO: " + l[j]);
 }
 println("--------");
 }
 AudioFormat audioFormat = new AudioFormat(
 SAMPLE_RATE,
 BITS_PER_SAMPLE,
 NUM_OF_CHANNELS,
 true,
 false);
 line = AudioSystem.getSourceDataLine(audioFormat);
 line.open(audioFormat, SAMPLE_RATE * BYTES_PER_FRAME);
 println("ACTUAL DEVICE CAPABILITIES: " + line.getFormat());
 line.start();
 }
 catch (Exception e) {
 e.printStackTrace();
 }
 }
 
 void finishAudioOutput() {
 line.drain();
 line.close();
 }
 
 */
