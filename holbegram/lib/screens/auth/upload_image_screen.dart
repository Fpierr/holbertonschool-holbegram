import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:image_picker/image_picker.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

  void selectImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List img = await image.readAsBytes();
      setState(() {
        _image = img;
      });
    }
  }

  void selectImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Uint8List img = await image.readAsBytes();

      setState(() {
        _image = img;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Holbegram',
              style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
            ),
            const SizedBox(height: 10),
            Image.asset('assets/images/logo.png', height: 80),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Hello, ${widget.username} welcome to \n Holbegram.',
                style: const TextStyle(
                  fontFamily: 'InstagramSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Text('Choose an image from your galery or take a new one.',
                style: TextStyle(fontFamily: 'InstagramSans')),
            const SizedBox(height: 40),
            _image != null
                ? CircleAvatar(
                    radius: 100, backgroundImage: MemoryImage(_image!))
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 100,
                    child: Image.asset('assets/images/Sample_User_Icon.png')),
            const SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: selectImageFromGallery,
                  icon: const Icon(Icons.image,
                      color: Color.fromARGB(218, 226, 37, 24), size: 40),
                ),
                const SizedBox(width: 70),
                IconButton(
                  onPressed: selectImageFromCamera,
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Color.fromARGB(218, 226, 37, 24),
                    size: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(218, 226, 37, 24),
                  fixedSize: const Size(150, 50)),
              onPressed: () async {
                String res = (await AuthMethode().signUpUser(
                  email: widget.email,
                  password: widget.password,
                  username: widget.username,
                  file: _image,
                ));

                if (res == "success") {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Success")),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res)),
                  );
                }
              },
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
