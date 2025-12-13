import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class CustomImagePickerService {
  static Future<File?> pick(BuildContext context) async {
    return await Navigator.push<File?>(
      context,
      MaterialPageRoute(builder: (_) => _CustomImagePickerScreen()),
    );
  }
}

class _CustomImagePickerScreen extends StatefulWidget {
  @override
  State<_CustomImagePickerScreen> createState() =>
      _CustomImagePickerScreenState();
}

class _CustomImagePickerScreenState extends State<_CustomImagePickerScreen> {
  final ImagePicker _picker = ImagePicker();

  List<AssetEntity> _recentImages = [];
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _selectedAlbum;

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  Future<void> _fetchAlbums() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      PhotoManager.openSetting();
      return;
    }

    List<AssetPathEntity> fetchedAlbums = [];
    try {
      fetchedAlbums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
    } catch (e) {
      print("Error fetching albums: $e");
    }

    // Filter out hidden or empty albums asynchronously
    List<AssetPathEntity> validAlbums = [];
    for (var album in fetchedAlbums) {
      try {
        final count = await album.assetCountAsync; // async getter
        if (count > 0 && !album.name.startsWith('.')) {
          validAlbums.add(album);
        }
      } catch (_) {}
    }

    _albums = validAlbums;

    if (_albums.isNotEmpty) {
      _selectedAlbum = _albums.first;
      _fetchImagesFromAlbum(_selectedAlbum!);
    }

    setState(() {});
  }


  Future<void> _fetchImagesFromAlbum(AssetPathEntity album) async {
    List<AssetEntity> images = [];
    try {
      images = await album.getAssetListPaged(page: 0, size: 50);
    } catch (e) {
      print("Error fetching images from ${album.name}: $e");
    }

    setState(() => _recentImages = images);
  }

  Future<void> _pickCamera() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (file != null) {
      Navigator.pop(context, File(file.path));
    }
  }

  Future<void> _selectImage(AssetEntity image) async {
    final file = await image.file;
    if (file == null) return;

    final fileSizeMB = await file.length() / (1024 * 1024);
    if (fileSizeMB > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Image too large (${fileSizeMB.toStringAsFixed(2)}MB). Select under 5MB."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context, file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          /// Album selector
          SizedBox(
            height: 55,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _albums.length,
              separatorBuilder: (_, __) => const SizedBox(width: 22),
              itemBuilder: (_, index) {
                final album = _albums[index];
                final bool isSelected = album == _selectedAlbum;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedAlbum = album);
                    _fetchImagesFromAlbum(album);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        album.name,
                        style: TextStyle(
                          color: isSelected ? Colors.orange : Colors.white,
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 3,
                          width: 28,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          /// Grid of images
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(6),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _recentImages.length + 1,
              itemBuilder: (_, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: _pickCamera,
                    child: Container(
                      color: Colors.grey[900],
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 30),
                    ),
                  );
                }

                final image = _recentImages[index - 1];

                return GestureDetector(
                  onTap: () => _selectImage(image),
                  child: FutureBuilder<Uint8List?>(
                    future: image.thumbnailDataWithSize(
                      const ThumbnailSize(200, 200),
                    ),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        );
                      }
                      return Container(color: Colors.grey[800]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
