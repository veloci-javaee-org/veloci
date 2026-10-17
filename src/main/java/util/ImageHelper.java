package util;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

public class ImageHelper {
 
	private static final long MAX_BYTES = 5 * 1024 * 1024; // 5 MB
	private static final String[] ALLOWED = { "image/jpeg", "image/png", "image/webp", "image/gif" };

	public static String save(Part part, String uploadDirAbsPath) throws IOException {
		if (part == null || part.getSize() == 0)
			return null;
		if (uploadDirAbsPath == null || uploadDirAbsPath.isBlank())
			throw new IOException("The product image directory is not available.");

		String ct = part.getContentType();
		boolean allowed = false;
		for (String a : ALLOWED)
			if (a.equalsIgnoreCase(ct)) {
				allowed = true;
				break;
			}
		if (!allowed)
			throw new IllegalArgumentException("Only JPG, PNG, WEBP or GIF images are allowed.");
		if (part.getSize() > MAX_BYTES)
			throw new IllegalArgumentException("Image must be smaller than 5 MB.");

		String original = getFileName(part);
		String ext = (original != null && original.contains(".")) ? original.substring(original.lastIndexOf('.'))
				: extensionFor(ct);
		if (!ext.matches("\\.[A-Za-z0-9]{1,10}"))
			ext = extensionFor(ct);
		String unique = UUID.randomUUID() + ext;

		Path dir = new File(uploadDirAbsPath).toPath();
		Files.createDirectories(dir);
		Path destination = dir.resolve(unique);

		try (InputStream input = part.getInputStream()) {
			Files.copy(input, destination, StandardCopyOption.REPLACE_EXISTING);
		} catch (IOException e) {
			Files.deleteIfExists(destination);
			throw e;
		}
		return "images/products/" + unique;
	}

	public static void delete(String relativePath, String webappRoot) {
		if (relativePath == null || relativePath.isBlank())
			return;
		File f = new File(webappRoot + File.separator + relativePath);
		if (f.exists())
			f.delete();
	}

	private static String getFileName(Part part) {
		String cd = part.getHeader("content-disposition");
		if (cd == null)
			return null;
		for (String t : cd.split(";")) {
			t = t.trim();
			if (t.startsWith("filename"))
				return t.substring(t.indexOf('=') + 1).trim().replace("\"", "");
		}
		return null;
	}

	private static String extensionFor(String contentType) {
		if ("image/png".equalsIgnoreCase(contentType))
			return ".png";
		if ("image/webp".equalsIgnoreCase(contentType))
			return ".webp";
		if ("image/gif".equalsIgnoreCase(contentType))
			return ".gif";
		return ".jpg";
	}
}