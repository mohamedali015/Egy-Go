import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:egy_go/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraCallScreen extends StatefulWidget {
  const AgoraCallScreen({
    super.key,
    required this.appId,
    required this.channelName,
    required this.token,
    required this.uid,
    required this.callId,
    required this.tripId,
  });

  final String appId;
  final String channelName;
  final String token;
  final int uid;
  final String callId;
  final String tripId;

  static const String routeName = "agoraCall";

  @override
  State<AgoraCallScreen> createState() => _AgoraCallScreenState();
}

class _AgoraCallScreenState extends State<AgoraCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _isMuted = false;
  bool _isCameraOff = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // Request permissions
    await [Permission.microphone, Permission.camera].request();

    // Create Agora engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: widget.appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("Remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: widget.uid,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  void _onToggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine.muteLocalAudioStream(_isMuted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onToggleCamera() {
    setState(() {
      _isCameraOff = !_isCameraOff;
    });
    _engine.muteLocalVideoStream(_isCameraOff);
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video Call',
          style: AppTextStyles.semiBold20,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _onCallEnd(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: _localUserJoined
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                ),
              ),
            ),
            _toolbar(),
          ],
        ),
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 100,
              color: Colors.white54,
            ),
            SizedBox(height: 20),
            Text(
              'Waiting for guide to join...',
              style: AppTextStyles.medium16.copyWith(color: Colors.white),
            ),
          ],
        ),
      );
    }
  }

  Widget _toolbar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RawMaterialButton(
              onPressed: _onToggleMute,
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: _isMuted ? Colors.blueAccent : Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                _isMuted ? Icons.mic_off : Icons.mic,
                color: _isMuted ? Colors.white : Colors.blueAccent,
                size: 20.0,
              ),
            ),
            RawMaterialButton(
              onPressed: () => _onCallEnd(context),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.redAccent,
              padding: const EdgeInsets.all(15.0),
              child: Icon(
                Icons.call_end,
                color: Colors.white,
                size: 35.0,
              ),
            ),
            RawMaterialButton(
              onPressed: _onToggleCamera,
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: _isCameraOff ? Colors.blueAccent : Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                _isCameraOff ? Icons.videocam_off : Icons.videocam,
                color: _isCameraOff ? Colors.white : Colors.blueAccent,
                size: 20.0,
              ),
            ),
            RawMaterialButton(
              onPressed: _onSwitchCamera,
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.switch_camera,
                color: Colors.blueAccent,
                size: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
