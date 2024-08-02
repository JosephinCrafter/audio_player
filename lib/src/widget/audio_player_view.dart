part of '../../audio_player.dart';

class AudioPlayerView extends StatefulWidget {
  const AudioPlayerView({
    super.key,
    required this.url,
    this.color,
    this.buttonColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.title,
    this.titleTheme,
    this.iconSize,
  });

  final String url;
  final Color? color;
  final Color? buttonColor;
  final Color? inactiveColor;
  final Color? secondaryActiveColor;
  final Widget? title;
  final TextStyle? titleTheme;
  final double? iconSize;
  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  AudioPlayer audioPlayer = AudioPlayer();
  late Duration? duration = Duration.zero;
  late double progress;

  bool isPlaying = false;
  late double upperBound;

  @override
  void initState() {
    progress = 0;
    upperBound = 10000;

    init().then((duration) {
      if (duration != null) {
        setState(() {
          upperBound = duration.inMilliseconds.toDouble();
        });
      }
    });
    audioPlayer.positionStream.listen(updateProgressFromAudio);
    audioPlayer.playingStream.listen(updatePlaying);
    super.initState();
  }

  Future<Duration?> init() async {
    return duration = await audioPlayer.setUrl(widget.url);
  }

  void updateProgressFromAudio(Duration value) {
    double newProgress = value.inMilliseconds.toDouble();
    updateProgress(newProgress);
  }

  void updateProgress(double value) {
    setState(
      () {
        progress = value;
      },
    );
  }

  void updatePlaying(bool newIsPlaying) {
    isPlaying = newIsPlaying;
  }

  void _onTap() {
    log("[$runtimeType] : onTap called.");
    if (isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void play() {
    audioPlayer.play();
    updatePlaying(true);
  }

  void pause() {
    audioPlayer.pause();
    updatePlaying(false);
  }

  bool currentStatus = false;
  void onChangeStart(_) {
    currentStatus = isPlaying;

    audioPlayer.pause();
  }

  void onChangeEnd(double value) {
    audioPlayer.seek(Duration(milliseconds: value.toInt()));
    if (currentStatus) {
      audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints.loose(const Size.fromHeight(100)),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   margin: EdgeInsets.only(
                  //       bottom:
                  //           (widget.iconSize != null) ? widget.iconSize! : 48),
                  //   child:
                  Align(
                    alignment: const Alignment(0, -1),
                    child: AnimatedPlayPause(
                      color: widget.buttonColor,
                      size: widget.iconSize,
                      isPlayingStream: audioPlayer.playingStream,
                      onTap: _onTap,
                      url: widget.url,
                    ),
                  ),

                  // ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: Slider.adaptive(
                            secondaryTrackValue: audioPlayer
                                .bufferedPosition.inMilliseconds
                                .toDouble(),
                            secondaryActiveColor: widget.secondaryActiveColor,
                            inactiveColor: widget.inactiveColor,
                            activeColor: widget.color,
                            onChangeStart: onChangeStart,
                            onChangeEnd: onChangeEnd,
                            min: .0,
                            max: upperBound,
                            value: progress,
                            allowedInteraction: SliderInteraction.slideOnly,
                            onChanged: updateProgress,
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    audioPlayer.position.toStringCompact(),
                                  ),
                                ),
                                Flexible(
                                  child:
                                      Text(duration?.toStringCompact() ?? ""),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.title != null)
            Flexible(
              child: DefaultTextStyle(
                child: widget.title!,
                style: widget.titleTheme ??
                    Theme.of(context).textTheme.labelLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
              ),
            ),
        ],
      ),
    );
  }
}

class AnimatedPlayPause extends StatefulWidget {
  const AnimatedPlayPause({
    super.key,
    this.color,
    required this.url,
    required this.onTap,
    this.onChanged,
    this.isPlayingStream,
    this.size,
  });

  final Color? color;

  final String url;
  final VoidCallback onTap;
  final Function(bool)? onChanged;
  final double? size;
  final Stream<bool>? isPlayingStream;

  @override
  State<AnimatedPlayPause> createState() => _AnimatedPlayPauseState();
}

class _AnimatedPlayPauseState extends State<AnimatedPlayPause>
    with SingleTickerProviderStateMixin {
  late Animation<double> _progress;
  late AnimationController _controller;

  // late AudioPlayer audioController;

  bool _isPlaying = false;
  double currentProgression = 0;
  // final StreamController<bool> _isPlayingStreamController =
  //     StreamController<bool>();
  // late Stream<bool> isPlayingStream;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Durations.medium2,
    );
    _progress = Tween<double>(begin: 1, end: 0).animate(_controller);

    widget.isPlayingStream?.listen(updateIsPlaying);

    /// Binding [widget.onChanged] to the stream;
    // isPlayingStream = _isPlayingStreamController.stream
    //   ..listen(widget.onChanged);

    super.initState();

    // audioController = AudioPlayer();
    // audioController.setUrl(widget.url);
    // audioController.bufferedPositionStream.listen(updateProgress);
  }

  void play() {
    // audioController.play();
    _controller.forward();
  }

  void pause() {
    _controller.reverse();
    // audioController.pause();
  }

  void _onTap() {
    updateIsPlaying(!_isPlaying);
    widget.onTap();
  }

  void updateProgress(Duration value) {
    setState(() {
      currentProgression = value.inMilliseconds.toDouble();
    });
  }

  void updateIsPlaying(bool newIsPlaying) {
    setState(
      () {
        _isPlaying = newIsPlaying;

        if (newIsPlaying) {
          play();
        } else {
          pause();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // audioController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      borderOnForeground: true,
      child: SizedBox.square(
        dimension: widget.size ?? 48,
        child: InkWell(
          onTap: _onTap,
          child: AnimatedIcon(
            size: widget.size ?? 48,
            icon: AnimatedIcons.pause_play,
            color: widget.color ?? Theme.of(context).primaryColor,
            progress: _progress,
          ),
        ),
      ),
    );
  }
}

extension on Duration {
  String toStringCompact() {
    var microseconds = inMicroseconds;
    var sign = "";
    var negative = microseconds < 0;

    var hours = microseconds ~/ Duration.microsecondsPerHour;
    microseconds = microseconds.remainder(Duration.microsecondsPerHour);

    // Correcting for being negative after first division, instead of before,
    // to avoid negating min-int, -(2^31-1), of a native int64.
    if (negative) {
      hours = 0 - hours; // Not using `-hours` to avoid creating -0.0 on web.
      microseconds = 0 - microseconds;
      sign = "-";
    }

    var minutes = microseconds ~/ Duration.microsecondsPerMinute;
    microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

    var minutesPadding = minutes < 10 ? "0" : "";

    var seconds = microseconds ~/ Duration.microsecondsPerSecond;
    microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

    var secondsPadding = seconds < 10 ? "0" : "";

    // Padding up to six digits for microseconds.
    var microsecondsText = microseconds.toString().padLeft(6, "0");

    return /*"$sign$hours:"*/
        "$minutesPadding$minutes:"
            "$secondsPadding$seconds" /*"$microsecondsText"*/;
  }
}
