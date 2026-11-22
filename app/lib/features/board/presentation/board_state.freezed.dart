// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoardState {

 Category get category; Board? get board; bool get loading;/// 지금 보이는 board가 저장해 둔 것(새로 받기 전·실패)
 bool get fromCache; AppFailure? get failure;
/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardStateCopyWith<BoardState> get copyWith => _$BoardStateCopyWithImpl<BoardState>(this as BoardState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BoardState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardState&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.board, _this.board) || other.board == _this.board)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.fromCache, _this.fromCache) || other.fromCache == _this.fromCache)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as BoardState;
  return Object.hash(runtimeType,_this.category,_this.board,_this.loading,_this.fromCache,_this.failure);
}

@override
String toString() {
  final _this = this as BoardState;
  return 'BoardState(category: ${_this.category}, board: ${_this.board}, loading: ${_this.loading}, fromCache: ${_this.fromCache}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $BoardStateCopyWith<$Res>  {
  factory $BoardStateCopyWith(BoardState value, $Res Function(BoardState) _then) = _$BoardStateCopyWithImpl;
@useResult
$Res call({
 Category category, Board? board, bool loading, bool fromCache, AppFailure? failure
});


$BoardCopyWith<$Res>? get board;

}
/// @nodoc
class _$BoardStateCopyWithImpl<$Res>
    implements $BoardStateCopyWith<$Res> {
  _$BoardStateCopyWithImpl(this._self, this._then);

  final BoardState _self;
  final $Res Function(BoardState) _then;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? board = freezed,Object? loading = null,Object? fromCache = null,Object? failure = freezed,}) {
  return _then(BoardState(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,board: freezed == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as Board?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}
/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardCopyWith<$Res>? get board {
    if (_self.board == null) {
    return null;
  }

  return $BoardCopyWith<$Res>(_self.board!, (value) {
    return _then(_self.copyWith(board: value));
  });
}
}


/// Adds pattern-matching-related methods to [BoardState].
extension BoardStatePatterns on BoardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardState value)  $default,){
final _that = this;
switch (_that) {
case _BoardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardState value)?  $default,){
final _that = this;
switch (_that) {
case _BoardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Category category,  Board? board,  bool loading,  bool fromCache,  AppFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardState() when $default != null:
return $default(_that.category,_that.board,_that.loading,_that.fromCache,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Category category,  Board? board,  bool loading,  bool fromCache,  AppFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _BoardState():
return $default(_that.category,_that.board,_that.loading,_that.fromCache,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Category category,  Board? board,  bool loading,  bool fromCache,  AppFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _BoardState() when $default != null:
return $default(_that.category,_that.board,_that.loading,_that.fromCache,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _BoardState implements BoardState {
  const _BoardState({this.category = Category.gpu, this.board, this.loading = false, this.fromCache = false, this.failure});
  

@override@JsonKey() final  Category category;
@override final  Board? board;
@override@JsonKey() final  bool loading;
/// 지금 보이는 board가 저장해 둔 것(새로 받기 전·실패)
@override@JsonKey() final  bool fromCache;
@override final  AppFailure? failure;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardStateCopyWith<_BoardState> get copyWith => __$BoardStateCopyWithImpl<_BoardState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardState&&(identical(other.category, category) || other.category == category)&&(identical(other.board, board) || other.board == board)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,category,board,loading,fromCache,failure);
}

@override
String toString() {
    return 'BoardState(category: $category, board: $board, loading: $loading, fromCache: $fromCache, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$BoardStateCopyWith<$Res> implements $BoardStateCopyWith<$Res> {
  factory _$BoardStateCopyWith(_BoardState value, $Res Function(_BoardState) _then) = __$BoardStateCopyWithImpl;
@override @useResult
$Res call({
 Category category, Board? board, bool loading, bool fromCache, AppFailure? failure
});


@override $BoardCopyWith<$Res>? get board;

}
/// @nodoc
class __$BoardStateCopyWithImpl<$Res>
    implements _$BoardStateCopyWith<$Res> {
  __$BoardStateCopyWithImpl(this._self, this._then);

  final _BoardState _self;
  final $Res Function(_BoardState) _then;

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? board = freezed,Object? loading = null,Object? fromCache = null,Object? failure = freezed,}) {
  return _then(_BoardState(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,board: freezed == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as Board?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

/// Create a copy of BoardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardCopyWith<$Res>? get board {
    if (_self.board == null) {
    return null;
  }

  return $BoardCopyWith<$Res>(_self.board!, (value) {
    return _then(_self.copyWith(board: value));
  });
}
}

// dart format on
