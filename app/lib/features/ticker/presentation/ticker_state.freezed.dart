// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticker_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TickerState {

 String get key; TickerDetail? get detail; Map<ChartRange, ChartData> get charts; ChartRange get range; ChartKind get kind; bool get loading; AppFailure? get failure;
/// Create a copy of TickerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TickerStateCopyWith<TickerState> get copyWith => _$TickerStateCopyWithImpl<TickerState>(this as TickerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TickerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TickerState&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.detail, _this.detail) || other.detail == _this.detail)&&const DeepCollectionEquality().equals(other.charts, _this.charts)&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as TickerState;
  return Object.hash(runtimeType,_this.key,_this.detail,const DeepCollectionEquality().hash(_this.charts),_this.range,_this.kind,_this.loading,_this.failure);
}

@override
String toString() {
  final _this = this as TickerState;
  return 'TickerState(key: ${_this.key}, detail: ${_this.detail}, charts: ${_this.charts}, range: ${_this.range}, kind: ${_this.kind}, loading: ${_this.loading}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $TickerStateCopyWith<$Res>  {
  factory $TickerStateCopyWith(TickerState value, $Res Function(TickerState) _then) = _$TickerStateCopyWithImpl;
@useResult
$Res call({
 String key, TickerDetail? detail, Map<ChartRange, ChartData> charts, ChartRange range, ChartKind kind, bool loading, AppFailure? failure
});


$TickerDetailCopyWith<$Res>? get detail;

}
/// @nodoc
class _$TickerStateCopyWithImpl<$Res>
    implements $TickerStateCopyWith<$Res> {
  _$TickerStateCopyWithImpl(this._self, this._then);

  final TickerState _self;
  final $Res Function(TickerState) _then;

/// Create a copy of TickerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? detail = freezed,Object? charts = null,Object? range = null,Object? kind = null,Object? loading = null,Object? failure = freezed,}) {
  return _then(TickerState(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as TickerDetail?,charts: null == charts ? _self.charts : charts // ignore: cast_nullable_to_non_nullable
as Map<ChartRange, ChartData>,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ChartRange,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChartKind,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}
/// Create a copy of TickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TickerDetailCopyWith<$Res>? get detail {
    if (_self.detail == null) {
    return null;
  }

  return $TickerDetailCopyWith<$Res>(_self.detail!, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}


/// Adds pattern-matching-related methods to [TickerState].
extension TickerStatePatterns on TickerState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TickerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TickerState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TickerState value)  $default,){
final _that = this;
switch (_that) {
case _TickerState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TickerState value)?  $default,){
final _that = this;
switch (_that) {
case _TickerState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  TickerDetail? detail,  Map<ChartRange, ChartData> charts,  ChartRange range,  ChartKind kind,  bool loading,  AppFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TickerState() when $default != null:
return $default(_that.key,_that.detail,_that.charts,_that.range,_that.kind,_that.loading,_that.failure);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  TickerDetail? detail,  Map<ChartRange, ChartData> charts,  ChartRange range,  ChartKind kind,  bool loading,  AppFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _TickerState():
return $default(_that.key,_that.detail,_that.charts,_that.range,_that.kind,_that.loading,_that.failure);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  TickerDetail? detail,  Map<ChartRange, ChartData> charts,  ChartRange range,  ChartKind kind,  bool loading,  AppFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _TickerState() when $default != null:
return $default(_that.key,_that.detail,_that.charts,_that.range,_that.kind,_that.loading,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _TickerState extends TickerState {
  const _TickerState({required this.key, this.detail,  Map<ChartRange, ChartData> charts = const {}, this.range = ChartRange.d1, this.kind = ChartKind.line, this.loading = true, this.failure}): _charts = charts,super._();
  

@override final  String key;
@override final  TickerDetail? detail;
 final  Map<ChartRange, ChartData> _charts;
@override@JsonKey() Map<ChartRange, ChartData> get charts {
  if (_charts is EqualUnmodifiableMapView) return _charts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_charts);
}

@override@JsonKey() final  ChartRange range;
@override@JsonKey() final  ChartKind kind;
@override@JsonKey() final  bool loading;
@override final  AppFailure? failure;

/// Create a copy of TickerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TickerStateCopyWith<_TickerState> get copyWith => __$TickerStateCopyWithImpl<_TickerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TickerState&&(identical(other.key, key) || other.key == key)&&(identical(other.detail, detail) || other.detail == detail)&&const DeepCollectionEquality().equals(other.charts, _charts)&&(identical(other.range, range) || other.range == range)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,key,detail,const DeepCollectionEquality().hash(_charts),range,kind,loading,failure);
}

@override
String toString() {
    return 'TickerState(key: $key, detail: $detail, charts: $charts, range: $range, kind: $kind, loading: $loading, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$TickerStateCopyWith<$Res> implements $TickerStateCopyWith<$Res> {
  factory _$TickerStateCopyWith(_TickerState value, $Res Function(_TickerState) _then) = __$TickerStateCopyWithImpl;
@override @useResult
$Res call({
 String key, TickerDetail? detail, Map<ChartRange, ChartData> charts, ChartRange range, ChartKind kind, bool loading, AppFailure? failure
});


@override $TickerDetailCopyWith<$Res>? get detail;

}
/// @nodoc
class __$TickerStateCopyWithImpl<$Res>
    implements _$TickerStateCopyWith<$Res> {
  __$TickerStateCopyWithImpl(this._self, this._then);

  final _TickerState _self;
  final $Res Function(_TickerState) _then;

/// Create a copy of TickerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? detail = freezed,Object? charts = null,Object? range = null,Object? kind = null,Object? loading = null,Object? failure = freezed,}) {
  return _then(_TickerState(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as TickerDetail?,charts: null == charts ? _self._charts : charts // ignore: cast_nullable_to_non_nullable
as Map<ChartRange, ChartData>,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ChartRange,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChartKind,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

/// Create a copy of TickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TickerDetailCopyWith<$Res>? get detail {
    if (_self.detail == null) {
    return null;
  }

  return $TickerDetailCopyWith<$Res>(_self.detail!, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}

// dart format on
