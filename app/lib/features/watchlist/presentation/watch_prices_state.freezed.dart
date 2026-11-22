// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_prices_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WatchPricesState {

 Map<String, TickerDetail> get details; bool get loading; AppFailure? get failure;
/// Create a copy of WatchPricesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchPricesStateCopyWith<WatchPricesState> get copyWith => _$WatchPricesStateCopyWithImpl<WatchPricesState>(this as WatchPricesState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WatchPricesState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchPricesState&&const DeepCollectionEquality().equals(other.details, _this.details)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as WatchPricesState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.details),_this.loading,_this.failure);
}

@override
String toString() {
  final _this = this as WatchPricesState;
  return 'WatchPricesState(details: ${_this.details}, loading: ${_this.loading}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $WatchPricesStateCopyWith<$Res>  {
  factory $WatchPricesStateCopyWith(WatchPricesState value, $Res Function(WatchPricesState) _then) = _$WatchPricesStateCopyWithImpl;
@useResult
$Res call({
 Map<String, TickerDetail> details, bool loading, AppFailure? failure
});




}
/// @nodoc
class _$WatchPricesStateCopyWithImpl<$Res>
    implements $WatchPricesStateCopyWith<$Res> {
  _$WatchPricesStateCopyWithImpl(this._self, this._then);

  final WatchPricesState _self;
  final $Res Function(WatchPricesState) _then;

/// Create a copy of WatchPricesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? details = null,Object? loading = null,Object? failure = freezed,}) {
  return _then(WatchPricesState(
details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as Map<String, TickerDetail>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchPricesState].
extension WatchPricesStatePatterns on WatchPricesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchPricesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchPricesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchPricesState value)  $default,){
final _that = this;
switch (_that) {
case _WatchPricesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchPricesState value)?  $default,){
final _that = this;
switch (_that) {
case _WatchPricesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, TickerDetail> details,  bool loading,  AppFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchPricesState() when $default != null:
return $default(_that.details,_that.loading,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, TickerDetail> details,  bool loading,  AppFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _WatchPricesState():
return $default(_that.details,_that.loading,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, TickerDetail> details,  bool loading,  AppFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _WatchPricesState() when $default != null:
return $default(_that.details,_that.loading,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _WatchPricesState implements WatchPricesState {
  const _WatchPricesState({ Map<String, TickerDetail> details = const {}, this.loading = false, this.failure}): _details = details;
  

 final  Map<String, TickerDetail> _details;
@override@JsonKey() Map<String, TickerDetail> get details {
  if (_details is EqualUnmodifiableMapView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_details);
}

@override@JsonKey() final  bool loading;
@override final  AppFailure? failure;

/// Create a copy of WatchPricesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchPricesStateCopyWith<_WatchPricesState> get copyWith => __$WatchPricesStateCopyWithImpl<_WatchPricesState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchPricesState&&const DeepCollectionEquality().equals(other.details, _details)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_details),loading,failure);
}

@override
String toString() {
    return 'WatchPricesState(details: $details, loading: $loading, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$WatchPricesStateCopyWith<$Res> implements $WatchPricesStateCopyWith<$Res> {
  factory _$WatchPricesStateCopyWith(_WatchPricesState value, $Res Function(_WatchPricesState) _then) = __$WatchPricesStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, TickerDetail> details, bool loading, AppFailure? failure
});




}
/// @nodoc
class __$WatchPricesStateCopyWithImpl<$Res>
    implements _$WatchPricesStateCopyWith<$Res> {
  __$WatchPricesStateCopyWithImpl(this._self, this._then);

  final _WatchPricesState _self;
  final $Res Function(_WatchPricesState) _then;

/// Create a copy of WatchPricesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? details = null,Object? loading = null,Object? failure = freezed,}) {
  return _then(_WatchPricesState(
details: null == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as Map<String, TickerDetail>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}


}

// dart format on
