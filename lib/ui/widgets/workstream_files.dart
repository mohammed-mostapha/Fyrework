// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:file_picker/file_picker.dart';

// class WorkstreamFiles extends StatefulWidget {
//   @override
//   _WorkstreamFilesState createState() => _WorkstreamFilesState();
// }

// class _WorkstreamFilesState extends State<WorkstreamFiles> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String _fileName;
//   List<PlatformFile> _paths;
//   String _directoryPath;
//   String _extension;
//   bool _loadingPath = false;
//   bool _multiPick = false;
//   FileType _pickingType = FileType.any;
//   TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(() => _extension = _controller.text);
//   }

//   void _openFileExplorer() async {
//     setState(() => _loadingPath = true);
//     try {
//       _directoryPath = null;
//       _paths = (await FilePicker.platform.pickFiles(
//         type: _pickingType,
//         allowMultiple: _multiPick,
//         allowedExtensions: (_extension?.isNotEmpty ?? false)
//             ? _extension?.replaceAll(' ', '')?.split(',')
//             : null,
//       ))
//           ?.files;
//     } on PlatformException catch (e) {
//       print("Unsupported operation" + e.toString());
//     } catch (ex) {
//       print(ex);
//     }
//     if (!mounted) return;
//     setState(() {
//       _loadingPath = false;
//       _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
//     });
//   }

//   void _clearCachedFiles() {
//     FilePicker.platform.clearTemporaryFiles().then((result) {
//       // ScaffoldMessenger.of(context).showSnackBar(
//       Scaffold.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: result ? Colors.green : Colors.red,
//           content: Text((result
//               ? 'Temporary files removed with success.'
//               : 'Failed to clean temporary files')),
//         ),
//       );
//     });
//   }

//   void _selectFolder() {
//     FilePicker.platform.getDirectoryPath().then((value) {
//       setState(() => _directoryPath = value);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
