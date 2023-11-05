import 'dart:async';

void debouncer(value){
  Timer? _debounce;
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(seconds: 1), () {
    if (value.isNotEmpty) {
      // cubit.keyword = value;
      // cubit.clearList();
      // cubit.getSatelliteOffice(
      //     keyword: value,
      //     location: widget.ctx?.read<NewPresenceCubit>().location,
      //     radius: widget.radius);
    }
  });
}