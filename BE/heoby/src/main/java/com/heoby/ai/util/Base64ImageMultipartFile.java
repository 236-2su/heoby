package com.heoby.ai.util;

import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class Base64ImageMultipartFile implements MultipartFile {

  private final byte[] content;
  private final String name;
  private final String originalFilename;
  private final String contentType;

  public Base64ImageMultipartFile(byte[] content,
      String name,
      String originalFilename,
      String contentType) {
    this.content = content;
    this.name = name;
    this.originalFilename = originalFilename;
    this.contentType = contentType;
  }

  @Override
  public String getName() {
    return this.name;
  }

  @Override
  public String getOriginalFilename() {
    return this.originalFilename;
  }

  @Override
  public String getContentType() {
    return this.contentType;
  }

  @Override
  public boolean isEmpty() {
    return this.content == null || this.content.length == 0;
  }

  @Override
  public long getSize() {
    return this.content.length;
  }

  @Override
  public byte[] getBytes() {
    return this.content;
  }

  @Override
  public InputStream getInputStream() {
    return new ByteArrayInputStream(this.content);
  }

  @Override
  public void transferTo(File dest) throws IOException, IllegalStateException {
    try (FileOutputStream fos = new FileOutputStream(dest)) {
      fos.write(this.content);
    }
  }
}
