// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alerts_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlertsState {

 AlertsStatus get status; String? get token; List<PriceAlert> get alerts; AppFailure? get failure;
/// Create a copy of AlertsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertsStateCopyWith<AlertsState> get copyWith => _$AlertsStateCopyWithImpl<AlertsState>(this as AlertsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AlertsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertsState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.token, _this.token) || other.token == _this.token)&&const DeepCollectionEquality().equals(other.alerts, _this.alerts)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as AlertsState;
  return Object.hash(runtimeType,_this.status,_this.token,const DeepCollectionEquality().hash(_this.alerts),_this.failure);
}

@override
String toString() {
  final _this = this as AlertsState;
  return 'AlertsState(status: ${_this.status}, token: ${_this.token}, alerts: ${_this.alerts}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $AlertsStateCopyWith<$Res>  {
  factory $AlertsStateCopyWith(AlertsState value, $Res Function(AlertsState) _then) = _$AlertsStateCopyWithImpl;
@useResult
$Res call({
 AlertsStatus status, String? token, List<PriceAlert> alerts, AppFailure? failure
});




}
/// @nodoc
class _$AlertsStateCopyWithImpl<$Res>
    implements $AlertsStateCopyWith<$Res> {
  _$AlertsStateCopyWithImpl(this._self, this._then);

  final AlertsState _self;
  final $Res Function(AlertsState) _then;

/// Create a copy of AlertsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? token = freezed,Object? alerts = null,Object? failure = freezed,}) {
  return _then(AlertsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlertsStatus,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<PriceAlert>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertsState].
extension AlertsStatePatterns on AlertsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertsState value)  $default,){
final _that = this;
switch (_that) {
case _AlertsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertsState value)?  $default,){
final _that = this;
switch (_that) {
case _AlertsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AlertsStatus status,  String? token,  List<PriceAlert> alerts,  AppFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertsState() when $default != null:
return $default(_that.status,_that.token,_that.alerts,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AlertsStatus status,  String? token,  List<PriceAlert> alerts,  AppFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _AlertsState():
return $default(_that.status,_that.token,_that.alerts,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AlertsStatus status,  String? token,  List<PriceAlert> alerts,  AppFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AlertsState() when $default != null:
return $default(_that.status,_that.token,_that.alerts,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AlertsState extends AlertsState {
  const _AlertsState({this.status = AlertsStatus.starting, this.token,  List<PriceAlert> alerts = const [], this.failure}): _alerts = alerts,super._();
  

@override@JsonKey() final  AlertsStatus status;
@override final  String? token;
 final  List<PriceAlert> _alerts;
@override@JsonKey() List<PriceAlert> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}

@override final  AppFailure? failure;

/// Create a copy of AlertsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertsStateCopyWith<_AlertsState> get copyWith => __$AlertsStateCopyWithImpl<_AlertsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertsState&&(identical(other.status, status) || other.status == status)&&(identical(other.token, token) || other.token == token)&&const DeepCollectionEquality().equals(other.alerts, _alerts)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,token,const DeepCollectionEquality().hash(_alerts),failure);
}

@override
String toString() {
    return 'AlertsState(status: $status, token: $token, alerts: $alerts, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AlertsStateCopyWith<$Res> implements $AlertsStateCopyWith<$Res> {
  factory _$AlertsStateCopyWith(_AlertsState value, $Res Function(_AlertsState) _then) = __$AlertsStateCopyWithImpl;
@override @useResult
$Res call({
 AlertsStatus status, String? token, List<PriceAlert> alerts, AppFailure? failure
});




}
/// @nodoc
class __$AlertsStateCopyWithImpl<$Res>
    implements _$AlertsStateCopyWith<$Res> {
  __$AlertsStateCopyWithImpl(this._self, this._then);

  final _AlertsState _self;
  final $Res Function(_AlertsState) _then;

/// Create a copy of AlertsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? token = freezed,Object? alerts = null,Object? failure = freezed,}) {
  return _then(_AlertsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlertsStatus,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<PriceAlert>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}


}

// dart format on
