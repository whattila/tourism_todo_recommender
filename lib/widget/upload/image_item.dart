import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents an image which can come from different sources (e.g. network or file).
/// Through this base class, these images can be treated homogeneously in a collection.
/// The derivative classes determine the source.
/// Extends Equatable as a best practice.
abstract class ImageItem extends Equatable {
  const ImageItem();

  @override
  List<Object> get props => [];

  Widget createWidget();
}

class NetworkImageItem extends ImageItem {
  const NetworkImageItem(this.url);

  final String url;

  @override
  List<Object> get props => [url];

  @override
  Widget createWidget() => CachedNetworkImage(
    imageUrl: url,
    placeholder: (context, url)
    => Container(
      transform: Matrix4.diagonal3Values(0.5, 0.5, 1),
      child: const CircularProgressIndicator(),
    ),
    errorWidget: (context, url, error)
    => Container(
      transform: Matrix4.diagonal3Values(0.5, 0.5, 1),
      child: const Icon(Icons.error),
    ),
  );
}

class MemoryImageItem extends ImageItem {
  const MemoryImageItem(this.bytes);

  final Uint8List bytes;

  @override
  List<Object> get props => [bytes];

  @override
  Widget createWidget() => Image.memory(bytes);
}