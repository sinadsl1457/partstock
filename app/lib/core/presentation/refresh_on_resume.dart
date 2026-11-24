// 앱이 백그라운드에서 돌아와 다시 보이면 onResume을 부른다(시세 목록·종목 차트·관심 화면이 씀).
// 알림창을 내리는 것처럼 잠깐 가려지는 것(inactive)은 세지 않고, 화면에서 사라졌다가(hidden) 돌아올 때만.
import 'package:flutter/widgets.dart';

class RefreshOnResume extends StatefulWidget {
  const RefreshOnResume({super.key, required this.onResume, required this.child});

  final VoidCallback onResume;
  final Widget child;

  @override
  State<RefreshOnResume> createState() => _RefreshOnResumeState();
}

class _RefreshOnResumeState extends State<RefreshOnResume> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onShow: () => widget.onResume());
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
