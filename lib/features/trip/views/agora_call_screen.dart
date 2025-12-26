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
  bool _isSpeakerOn = true;
  bool _isEngineInitialized = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    try {
      print('═══════════════════════════════════════════');
      print('[AgoraCall] INITIALIZING AGORA CALL');
      print('═══════════════════════════════════════════');
      print('[AgoraCall] App ID: ${widget.appId}');
      print('[AgoraCall] Channel Name: ${widget.channelName}');
      print('[AgoraCall] UID: ${widget.uid}');
      print('[AgoraCall] Token Length: ${widget.token.length}');
      print(
          '[AgoraCall] Token Preview: ${widget.token.substring(0, widget.token.length > 20 ? 20 : widget.token.length)}...');
      print('[AgoraCall] Call ID: ${widget.callId}');
      print('[AgoraCall] Trip ID: ${widget.tripId}');
      print(
          '[AgoraCall] 🔍 CRITICAL: Channel name is: "${widget.channelName}"');
      print(
          '[AgoraCall] 🔍 CRITICAL: Make sure guide receives same channel name!');
      print('═══════════════════════════════════════════');

      // Request permissions
      final micStatus = await Permission.microphone.request();
      final cameraStatus = await Permission.camera.request();

      print('[AgoraCall] Microphone permission: $micStatus');
      print('[AgoraCall] Camera permission: $cameraStatus');

      if (!micStatus.isGranted || !cameraStatus.isGranted) {
        print('[AgoraCall] ⚠️ WARNING: Permissions not granted!');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Camera and microphone permissions are required'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      // Create Agora engine as a single persistent instance
      _engine = createAgoraRtcEngine();
      await _engine.initialize(RtcEngineContext(
        appId: widget.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

      print('[AgoraCall] ✅ Engine initialized');

      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print('═══════════════════════════════════════════');
            print('[AgoraCall] ✅ LOCAL USER JOINED SUCCESSFULLY!');
            print('[AgoraCall] ✅ My UID: ${connection.localUid}');
            print('[AgoraCall] ✅ Channel: ${connection.channelId}');
            print('[AgoraCall] ✅ Time taken: ${elapsed}ms');
            print('[AgoraCall] 👀 Waiting for remote user to join...');
            print('═══════════════════════════════════════════');
            setState(() {
              _localUserJoined = true;
            });

            // ✅ NOW we can safely enable speakerphone after joining
            _engine.setEnableSpeakerphone(_isSpeakerOn).then((_) {
              print('[AgoraCall] 🔊 Speakerphone enabled: $_isSpeakerOn');
            }).catchError((e) {
              print('[AgoraCall] ⚠️ Failed to enable speakerphone: $e');
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            print('═══════════════════════════════════════════');
            print('[AgoraCall] 🎉🎉🎉 REMOTE USER JOINED! 🎉🎉🎉');
            print('[AgoraCall] 🎉 Remote UID: $remoteUid');
            print('[AgoraCall] 🎉 Channel: ${connection.channelId}');
            print('[AgoraCall] 🎉 Time taken: ${elapsed}ms');
            print('[AgoraCall] 🎉 Call is now CONNECTED!');
            print('═══════════════════════════════════════════');
            setState(() {
              _remoteUid = remoteUid;
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            print('═══════════════════════════════════════════');
            print('[AgoraCall] ❌ REMOTE USER LEFT');
            print('[AgoraCall] ❌ Remote UID: $remoteUid');
            print('[AgoraCall] ❌ Reason: $reason');
            print('═══════════════════════════════════════════');
            setState(() {
              _remoteUid = null;
            });
          },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            print('[AgoraCall] ⚠️ Token will expire soon - need to renew!');
          },
          onError: (ErrorCodeType err, String msg) {
            print('═══════════════════════════════════════════');
            print('[AgoraCall] ❌❌❌ AGORA ERROR! ❌❌❌');
            print('[AgoraCall] ❌ Error Code: $err');
            print('[AgoraCall] ❌ Error Message: $msg');
            print('═══════════════════════════════════════════');
          },
          onConnectionStateChanged: (RtcConnection connection,
              ConnectionStateType state, ConnectionChangedReasonType reason) {
            print('[AgoraCall] 🔌 Connection state: $state, reason: $reason');

            if (state == ConnectionStateType.connectionStateFailed) {
              print('[AgoraCall] ❌ CONNECTION FAILED!');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Connection failed: $reason'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          onRejoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print('[AgoraCall] ✅ Rejoined channel successfully');
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            print('[AgoraCall] 👋 Left channel');
          },
        ),
      );

      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine.enableVideo();
      await _engine.startPreview();

      print('[AgoraCall] ✅ Video enabled, preview started');

      // Set engine initialized after preview starts
      setState(() {
        _isEngineInitialized = true;
      });

      print('[AgoraCall] 📞 JOINING CHANNEL NOW...');
      print('[AgoraCall] 📞 Channel: "${widget.channelName}"');
      print('[AgoraCall] 📞 UID: ${widget.uid}');
      print('[AgoraCall] 📞 Token valid: ${widget.token.isNotEmpty}');

      await _engine.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: widget.uid,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
        ),
      );

      print('[AgoraCall] ✅ Join channel request sent successfully');
      print('[AgoraCall] ⏳ Waiting for onJoinChannelSuccess callback...');
    } catch (e, stackTrace) {
      print('═══════════════════════════════════════════');
      print('[AgoraCall] ❌❌❌ INITIALIZATION FAILED! ❌❌❌');
      print('[AgoraCall] ❌ Error: $e');
      print('[AgoraCall] ❌ Stack trace: $stackTrace');
      print('═══════════════════════════════════════════');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize call: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    try {
      if (_isEngineInitialized) {
        await _engine.leaveChannel();
        await _engine.release();
      }
    } catch (e) {
      debugPrint("Error disposing Agora: $e");
    }
  }

  // Bind to real Agora method: muteLocalAudioStream
  Future<void> _onToggleMute() async {
    setState(() {
      _isMuted = !_isMuted;
    });
    await _engine.muteLocalAudioStream(_isMuted);
  }

  // Bind to real Agora method: switchCamera
  Future<void> _onSwitchCamera() async {
    await _engine.switchCamera();
  }

  Future<void> _onToggleCamera() async {
    setState(() {
      _isCameraOff = !_isCameraOff;
    });
    // Use enableLocalVideo instead of muteLocalVideoStream for better control
    await _engine.enableLocalVideo(!_isCameraOff);
  }

  // Bind to real Agora method: enableSpeakerphone
  Future<void> _onToggleSpeaker() async {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
    await _engine.setEnableSpeakerphone(_isSpeakerOn);
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Mute/Unmute button - bound to muteLocalAudioStream
              RawMaterialButton(
                onPressed: _onToggleMute,
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: _isMuted ? Colors.blueAccent : Colors.white,
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  _isMuted ? Icons.mic_off : Icons.mic,
                  color: _isMuted ? Colors.white : Colors.blueAccent,
                  size: 18.0,
                ),
              ),
              SizedBox(width: 8),
              // End call button
              RawMaterialButton(
                onPressed: () => _onCallEnd(context),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.redAccent,
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 28.0,
                ),
              ),
              SizedBox(width: 8),
              // Camera on/off button
              RawMaterialButton(
                onPressed: _onToggleCamera,
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: _isCameraOff ? Colors.blueAccent : Colors.white,
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  _isCameraOff ? Icons.videocam_off : Icons.videocam,
                  color: _isCameraOff ? Colors.white : Colors.blueAccent,
                  size: 18.0,
                ),
              ),
              SizedBox(width: 8),
              // Switch camera button - bound to switchCamera
              RawMaterialButton(
                onPressed: _onSwitchCamera,
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.switch_camera,
                  color: Colors.blueAccent,
                  size: 18.0,
                ),
              ),
              SizedBox(width: 8),
              // Speaker on/off button - bound to enableSpeakerphone
              RawMaterialButton(
                onPressed: _onToggleSpeaker,
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: _isSpeakerOn ? Colors.white : Colors.blueAccent,
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                  color: _isSpeakerOn ? Colors.blueAccent : Colors.white,
                  size: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// DONE: Agora controls fixed
