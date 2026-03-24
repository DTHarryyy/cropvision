import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme/app_colors.dart';
import 'processing_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestPermissionAndInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _requestPermissionAndInit() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    if (status.isGranted) {
      await _initCamera();
    } else if (status.isPermanentlyDenied) {
      setState(() => _errorMessage = 'Camera permission permanently denied. Please enable it in Settings.');
    } else {
      setState(() => _errorMessage = 'Camera permission denied.');
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = 'No camera found on this device.');
        return;
      }
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _cameraController!.initialize();
      if (mounted) setState(() => _isCameraInitialized = true);
    } catch (e) {
      if (mounted) setState(() => _errorMessage = 'Failed to initialize camera: $e');
    }
  }

  Future<void> _capture() async {
    if (_isCapturing || !_isCameraInitialized || _cameraController == null) return;
    setState(() => _isCapturing = true);
    try {
      final file = await _cameraController!.takePicture();
      if (mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => ProcessingScreen(imagePath: file.path)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Capture failed: $e'), backgroundColor: AppColors.errorColor),
        );
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => ProcessingScreen(imagePath: image.path)));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera / State layer
          if (_isCameraInitialized && _cameraController != null)
            Positioned.fill(child: CameraPreview(_cameraController!))
          else
            Positioned.fill(child: _buildStateLayer()),

          // Overlay UI
          _buildOverlay(context),
        ],
      ),
    );
  }

  Widget _buildStateLayer() {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 72),
              const SizedBox(height: 20),
              Text(_errorMessage!,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _errorMessage!.contains('Settings')
                    ? openAppSettings
                    : _requestPermissionAndInit,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(_errorMessage!.contains('Settings') ? 'Open Settings' : 'Retry'),
              ),
            ],
          ),
        ),
      );
    }
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text('Starting camera...', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _CircleIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.maybePop(context),
                ),
                const Spacer(),
                const Text('Scan Plant',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                const Spacer(),
                _CircleIconButton(
                  icon: Icons.flash_auto_rounded,
                  onTap: () {
                    if (_isCameraInitialized) {
                      final mode = _cameraController!.value.flashMode == FlashMode.off
                          ? FlashMode.torch
                          : FlashMode.off;
                      _cameraController!.setFlashMode(mode);
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),

          // Scanning frame
          Expanded(
            child: Center(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor, width: 2.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    _Corner(Alignment.topLeft),
                    _Corner(Alignment.topRight),
                    _Corner(Alignment.bottomLeft),
                    _Corner(Alignment.bottomRight),
                    const Center(
                      child: Text('Point at a leaf',
                          style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom controls
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery
                _CircleIconButton(
                  icon: Icons.photo_library_rounded,
                  size: 52,
                  onTap: _pickFromGallery,
                ),
                // Capture
                GestureDetector(
                  onTap: _capture,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      color: _isCapturing ? Colors.white38 : Colors.white24,
                    ),
                    child: _isCapturing
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 32),
                  ),
                ),
                // Flip camera (placeholder)
                _CircleIconButton(
                  icon: Icons.flip_camera_android_rounded,
                  size: 52,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _CircleIconButton({required this.icon, required this.onTap, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final Alignment alignment;
  const _Corner(this.alignment);

  @override
  Widget build(BuildContext context) {
    final isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    return Align(
      alignment: alignment,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? const BorderSide(color: AppColors.primaryColor, width: 3) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: AppColors.primaryColor, width: 3) : BorderSide.none,
            left: isLeft ? const BorderSide(color: AppColors.primaryColor, width: 3) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: AppColors.primaryColor, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
