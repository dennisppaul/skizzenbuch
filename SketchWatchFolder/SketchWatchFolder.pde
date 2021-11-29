
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardWatchEventKinds;
import java.nio.file.WatchEvent;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;

try {
    println(sketchPath() + "/data");
    Path faxFolder = Paths.get(sketchPath() + "/data");
    WatchService watchService = FileSystems.getDefault().newWatchService();
    faxFolder.register(watchService, StandardWatchEventKinds.ENTRY_CREATE);

    boolean valid = true;
    do {
        WatchKey watchKey = watchService.take();

        for (WatchEvent event : watchKey.pollEvents ()) {
            WatchEvent.Kind kind = event.kind();
            System.out.println("kind: " + kind);
            if (StandardWatchEventKinds.ENTRY_CREATE.equals(kind)) {
                String fileName = event.context().toString();
                System.out.println("File Created:" + fileName);
            }
            if (StandardWatchEventKinds.ENTRY_DELETE.equals(kind)) {
                String fileName = event.context().toString();
                System.out.println("File Deleted:" + fileName);
            }
            if (StandardWatchEventKinds.ENTRY_MODIFY.equals(kind)) {
                String fileName = event.context().toString();
                System.out.println("File Modified:" + fileName);
            }
        }
        valid = watchKey.reset();
    } while (valid);
} 
catch (Exception ex) {
    ex.printStackTrace();
}
