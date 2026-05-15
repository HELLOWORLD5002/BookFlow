import java.nio.file.*;
import java.nio.charset.*;
public class FixEmoji {
    public static void main(String[] args) throws Exception {
        String path = "web/pages/admin_dashboard.jsp";
        String content = new String(Files.readAllBytes(Paths.get(path)), StandardCharsets.UTF_8);
        content = content.replace("\u00f0\u009f\u0094\u008b", "&#128203;");
        content = content.replace("\u00f0\u009f\u0094\u009a", "&#128218;");
        content = content.replace("\u00f0\u009f\u0091\u00a5", "&#128101;");
        content = content.replace("\u00f0\u009f\u0092\u00b0", "&#128176;");
        content = content.replace("\u00f0\u009f\u0091\u00a4", "&#128100;");
        Files.write(Paths.get(path), content.getBytes(StandardCharsets.UTF_8));
        System.out.println("Done!");
    }
}
