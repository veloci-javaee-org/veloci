package util;

import jakarta.servlet.http.Part;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.SequenceInputStream;
import java.text.Normalizer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.nio.file.InvalidPathException;
import java.util.Arrays;
import java.util.Locale;
import java.util.UUID;

public class ImageHelper {

	private static final long MAX_BYTES = 5 * 1024 * 1024; // 5 MB
	private static final String[] ALLOWED = { "image/jpeg", "image/png", "image/webp", "image/gif" };

	public static String save(Part part, String uploadDirAbsPath) throws IOException {
		return save(part, uploadDirAbsPath, null);
	}

	public static String save(Part part, String uploadDirAbsPath, String productName) throws IOException {
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
		if (!isAllowedImageContent(part, ct))
			throw new IllegalArgumentException("The uploaded file content does not match a supported image type.");

		String ext = extensionFor(ct);
		String slug = toFileSlug(productName);
		String unique = slug + "-" + UUID.randomUUID() + ext;

		Path dir = new File(uploadDirAbsPath).toPath();
		Files.createDirectories(dir);
		Path destination = dir.resolve(unique);

		try (InputStream source = part.getInputStream()) {
			byte[] header = source.readNBytes(12);
			if (!hasImageSignature(header, ct)) {
				throw new IllegalArgumentException("The uploaded file content does not match its image type.");
			}
			try (InputStream input = new SequenceInputStream(new ByteArrayInputStream(header), source)) {
				Files.copy(input, destination, StandardCopyOption.REPLACE_EXISTING);
			}
		} catch (IOException e) {
			Files.deleteIfExists(destination);
			throw e;
		} catch (IllegalArgumentException e) {
			Files.deleteIfExists(destination);
			throw e;
		}
		return "images/products/" + unique;
	}

	public static void delete(String relativePath, String webappRoot) throws IOException {
		if (relativePath == null || relativePath.isBlank())
			return;
		if (webappRoot == null || webappRoot.isBlank())
			throw new IOException("The web application image directory is not available.");
		Path root = new File(webappRoot).toPath().toAbsolutePath().normalize();
		Path image;
		try {
			image = root.resolve(relativePath).normalize();
		} catch (InvalidPathException e) {
			throw new IOException("The stored image path is invalid.", e);
		}
		if (!image.startsWith(root))
			throw new IOException("The stored image path is outside the web application.");
		Files.deleteIfExists(image);
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

	private static boolean isAllowedImageContent(Part part, String contentType) throws IOException {
		try (InputStream input = part.getInputStream()) {
			return hasImageSignature(input.readNBytes(12), contentType);
		}
	}

	private static boolean hasImageSignature(byte[] header, String contentType) {
		if ("image/jpeg".equalsIgnoreCase(contentType))
			return header.length >= 3 && (header[0] & 0xff) == 0xff && (header[1] & 0xff) == 0xd8
					&& (header[2] & 0xff) == 0xff;
		if ("image/png".equalsIgnoreCase(contentType))
			return header.length >= 8 && Arrays.equals(Arrays.copyOf(header, 8),
					new byte[] { (byte) 0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a });
		if ("image/gif".equalsIgnoreCase(contentType))
			return header.length >= 6
					&& ("GIF87a".equals(new String(header, 0, 6, java.nio.charset.StandardCharsets.US_ASCII))
							|| "GIF89a".equals(new String(header, 0, 6, java.nio.charset.StandardCharsets.US_ASCII)));
		return "image/webp".equalsIgnoreCase(contentType) && header.length >= 12
				&& "RIFF".equals(new String(header, 0, 4, java.nio.charset.StandardCharsets.US_ASCII))
				&& "WEBP".equals(new String(header, 8, 4, java.nio.charset.StandardCharsets.US_ASCII));
	}

	private static String toFileSlug(String value) {
		if (value == null || value.isBlank())
			return "product-image";
		String normalized = Normalizer.normalize(value, Normalizer.Form.NFD).replaceAll("\\p{M}", "")
				.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9]+", "-").replaceAll("(^-|-$)", "");
		return normalized.isEmpty() ? "product-image" : normalized;
	}
}