// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movers_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MoversState {

 Movers? get movers; bool get loading; AppFailure? get failure;
/// Create a copy of MoversState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoversStateCopyWith<MoversState> get copyWith => _$MoversStateCopyWithImpl<MoversState>(this as MoversState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MoversState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoversState&&(identical(other.movers, _this.movers) || other.movers == _this.movers)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as MoversState;
  return Object.hash(runtimeType,_this.movers,_this.loading,_this.failure);
}

@override
String toString() {
  final _this = this as MoversState;
  return 'MoversState(movers: ${_this.movers}, loading: ${_this.loading}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $MoversStateCopyWith<$Res>  {
  factory $MoversStateCopyWith(MoversState value, $Res Function(MoversState) _then) = _$MoversStateCopyWithImpl;
@useResult
$Res call({
 Movers? movers, bool loading, AppFailure? failure
});


$MoversCopyWith<$Res>? get movers;

}
/// @nodoc
class _$MoversStateCopyWithImpl<$Res>
    implements $MoversStateCopyWith<$Res> {
  _$MoversStateCopyWithImpl(this._self, this._then);

  final MoversState _self;
  final $Res Function(MoversState) _then;

/// Create a copy of MoversState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movers = freezed,Object? loading = null,Object? failure = freezed,}) {
  return _then(MoversState(
movers: freezed == movers ? _self.movers : movers // ignore: cast_nullable_to_non_nullable
as Movers?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}
/// Create a copy of MoversState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoversCopyWith<$Res>? get movers {
    if (_self.movers == null) {
    return null;
  }

  return $MoversCopyWith<$Res>(_self.movers!, (value) {
    return _then(_self.copyWith(movers: value));
  });
}
}


/// Adds pattern-matching-related methods to [MoversState].
extension MoversStatePatterns on MoversState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoversState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoversState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoversState value)  $default,){
final _that = this;
switch (_that) {
case _MoversState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoversState value)?  $default,){
final _that = this;
switch (_that) {
case _MoversState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Movers? movers,  bool loading,  AppFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoversState() when $default != null:
return $default(_that.movers,_that.loading,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Movers? movers,  bool loading,  AppFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _MoversState():
return $default(_that.movers,_that.loading,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Movers? movers,  bool loading,  AppFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _MoversState() when $default != null:
return $default(_that.movers,_that.loading,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _MoversState implements MoversState {
  const _MoversState({this.movers, this.loading = false, this.failure});
  

@override final  Movers? movers;
@override@JsonKey() final  bool loading;
@override final  AppFailure? failure;

/// Create a copy of MoversState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoversStateCopyWith<_MoversState> get copyWith => __$MoversStateCopyWithImpl<_MoversState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoversState&&(identical(other.movers, movers) || other.movers == movers)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,movers,loading,failure);
}

@override
String toString() {
    return 'MoversState(movers: $movers, loading: $loading, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$MoversStateCopyWith<$Res> implements $MoversStateCopyWith<$Res> {
  factory _$MoversStateCopyWith(_MoversState value, $Res Function(_MoversState) _then) = __$MoversStateCopyWithImpl;
@override @useResult
$Res call({
 Movers? movers, bool loading, AppFailure? failure
});


@override $MoversCopyWith<$Res>? get movers;

}
/// @nodoc
class __$MoversStateCopyWithImpl<$Res>
    implements _$MoversStateCopyWith<$Res> {
  __$MoversStateCopyWithImpl(this._self, this._then);

  final _MoversState _self;
  final $Res Function(_MoversState) _then;

/// Create a copy of MoversState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movers = freezed,Object? loading = null,Object? failure = freezed,}) {
  return _then(_MoversState(
movers: freezed == movers ? _self.movers : movers // ignore: cast_nullable_to_non_nullable
as Movers?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

/// Create a copy of MoversState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoversCopyWith<$Res>? get movers {
    if (_self.movers == null) {
    return null;
  }

  return $MoversCopyWith<$Res>(_self.movers!, (value) {
    return _then(_self.copyWith(movers: value));
  });
}
}

// dart format on
