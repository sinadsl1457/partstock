// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PriceAlert {

 int get id; String get tickerKey; String get tickerName; AlertDirection get direction; int get targetCents; DateTime get createdAt; DateTime? get firedAt; int? get firedCents;
/// Create a copy of PriceAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceAlertCopyWith<PriceAlert> get copyWith => _$PriceAlertCopyWithImpl<PriceAlert>(this as PriceAlert, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PriceAlert;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceAlert&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.tickerKey, _this.tickerKey) || other.tickerKey == _this.tickerKey)&&(identical(other.tickerName, _this.tickerName) || other.tickerName == _this.tickerName)&&(identical(other.direction, _this.direction) || other.direction == _this.direction)&&(identical(other.targetCents, _this.targetCents) || other.targetCents == _this.targetCents)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.firedAt, _this.firedAt) || other.firedAt == _this.firedAt)&&(identical(other.firedCents, _this.firedCents) || other.firedCents == _this.firedCents));
}


@override
int get hashCode {
  final _this = this as PriceAlert;
  return Object.hash(runtimeType,_this.id,_this.tickerKey,_this.tickerName,_this.direction,_this.targetCents,_this.createdAt,_this.firedAt,_this.firedCents);
}

@override
String toString() {
  final _this = this as PriceAlert;
  return 'PriceAlert(id: ${_this.id}, tickerKey: ${_this.tickerKey}, tickerName: ${_this.tickerName}, direction: ${_this.direction}, targetCents: ${_this.targetCents}, createdAt: ${_this.createdAt}, firedAt: ${_this.firedAt}, firedCents: ${_this.firedCents})';
}


}

/// @nodoc
abstract mixin class $PriceAlertCopyWith<$Res>  {
  factory $PriceAlertCopyWith(PriceAlert value, $Res Function(PriceAlert) _then) = _$PriceAlertCopyWithImpl;
@useResult
$Res call({
 int id, String tickerKey, String tickerName, AlertDirection direction, int targetCents, DateTime createdAt, DateTime? firedAt, int? firedCents
});




}
/// @nodoc
class _$PriceAlertCopyWithImpl<$Res>
    implements $PriceAlertCopyWith<$Res> {
  _$PriceAlertCopyWithImpl(this._self, this._then);

  final PriceAlert _self;
  final $Res Function(PriceAlert) _then;

/// Create a copy of PriceAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tickerKey = null,Object? tickerName = null,Object? direction = null,Object? targetCents = null,Object? createdAt = null,Object? firedAt = freezed,Object? firedCents = freezed,}) {
  return _then(PriceAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tickerKey: null == tickerKey ? _self.tickerKey : tickerKey // ignore: cast_nullable_to_non_nullable
as String,tickerName: null == tickerName ? _self.tickerName : tickerName // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as AlertDirection,targetCents: null == targetCents ? _self.targetCents : targetCents // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,firedAt: freezed == firedAt ? _self.firedAt : firedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,firedCents: freezed == firedCents ? _self.firedCents : firedCents // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceAlert].
extension PriceAlertPatterns on PriceAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceAlert value)  $default,){
final _that = this;
switch (_that) {
case _PriceAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceAlert value)?  $default,){
final _that = this;
switch (_that) {
case _PriceAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String tickerKey,  String tickerName,  AlertDirection direction,  int targetCents,  DateTime createdAt,  DateTime? firedAt,  int? firedCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceAlert() when $default != null:
return $default(_that.id,_that.tickerKey,_that.tickerName,_that.direction,_that.targetCents,_that.createdAt,_that.firedAt,_that.firedCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String tickerKey,  String tickerName,  AlertDirection direction,  int targetCents,  DateTime createdAt,  DateTime? firedAt,  int? firedCents)  $default,) {final _that = this;
switch (_that) {
case _PriceAlert():
return $default(_that.id,_that.tickerKey,_that.tickerName,_that.direction,_that.targetCents,_that.createdAt,_that.firedAt,_that.firedCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String tickerKey,  String tickerName,  AlertDirection direction,  int targetCents,  DateTime createdAt,  DateTime? firedAt,  int? firedCents)?  $default,) {final _that = this;
switch (_that) {
case _PriceAlert() when $default != null:
return $default(_that.id,_that.tickerKey,_that.tickerName,_that.direction,_that.targetCents,_that.createdAt,_that.firedAt,_that.firedCents);case _:
  return null;

}
}

}

/// @nodoc


class _PriceAlert extends PriceAlert {
  const _PriceAlert({required this.id, required this.tickerKey, required this.tickerName, required this.direction, required this.targetCents, required this.createdAt, this.firedAt, this.firedCents}): super._();
  

@override final  int id;
@override final  String tickerKey;
@override final  String tickerName;
@override final  AlertDirection direction;
@override final  int targetCents;
@override final  DateTime createdAt;
@override final  DateTime? firedAt;
@override final  int? firedCents;

/// Create a copy of PriceAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceAlertCopyWith<_PriceAlert> get copyWith => __$PriceAlertCopyWithImpl<_PriceAlert>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.tickerKey, tickerKey) || other.tickerKey == tickerKey)&&(identical(other.tickerName, tickerName) || other.tickerName == tickerName)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.targetCents, targetCents) || other.targetCents == targetCents)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.firedAt, firedAt) || other.firedAt == firedAt)&&(identical(other.firedCents, firedCents) || other.firedCents == firedCents));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,tickerKey,tickerName,direction,targetCents,createdAt,firedAt,firedCents);
}

@override
String toString() {
    return 'PriceAlert(id: $id, tickerKey: $tickerKey, tickerName: $tickerName, direction: $direction, targetCents: $targetCents, createdAt: $createdAt, firedAt: $firedAt, firedCents: $firedCents)';
}


}

/// @nodoc
abstract mixin class _$PriceAlertCopyWith<$Res> implements $PriceAlertCopyWith<$Res> {
  factory _$PriceAlertCopyWith(_PriceAlert value, $Res Function(_PriceAlert) _then) = __$PriceAlertCopyWithImpl;
@override @useResult
$Res call({
 int id, String tickerKey, String tickerName, AlertDirection direction, int targetCents, DateTime createdAt, DateTime? firedAt, int? firedCents
});




}
/// @nodoc
class __$PriceAlertCopyWithImpl<$Res>
    implements _$PriceAlertCopyWith<$Res> {
  __$PriceAlertCopyWithImpl(this._self, this._then);

  final _PriceAlert _self;
  final $Res Function(_PriceAlert) _then;

/// Create a copy of PriceAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tickerKey = null,Object? tickerName = null,Object? direction = null,Object? targetCents = null,Object? createdAt = null,Object? firedAt = freezed,Object? firedCents = freezed,}) {
  return _then(_PriceAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tickerKey: null == tickerKey ? _self.tickerKey : tickerKey // ignore: cast_nullable_to_non_nullable
as String,tickerName: null == tickerName ? _self.tickerName : tickerName // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as AlertDirection,targetCents: null == targetCents ? _self.targetCents : targetCents // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,firedAt: freezed == firedAt ? _self.firedAt : firedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,firedCents: freezed == firedCents ? _self.firedCents : firedCents // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
