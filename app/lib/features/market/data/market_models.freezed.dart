// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Fx {

 String get day; double get usdKrw;
/// Create a copy of Fx
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FxCopyWith<Fx> get copyWith => _$FxCopyWithImpl<Fx>(this as Fx, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Fx;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Fx&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.usdKrw, _this.usdKrw) || other.usdKrw == _this.usdKrw));
}


@override
int get hashCode {
  final _this = this as Fx;
  return Object.hash(runtimeType,_this.day,_this.usdKrw);
}

@override
String toString() {
  final _this = this as Fx;
  return 'Fx(day: ${_this.day}, usdKrw: ${_this.usdKrw})';
}


}

/// @nodoc
abstract mixin class $FxCopyWith<$Res>  {
  factory $FxCopyWith(Fx value, $Res Function(Fx) _then) = _$FxCopyWithImpl;
@useResult
$Res call({
 String day, double usdKrw
});




}
/// @nodoc
class _$FxCopyWithImpl<$Res>
    implements $FxCopyWith<$Res> {
  _$FxCopyWithImpl(this._self, this._then);

  final Fx _self;
  final $Res Function(Fx) _then;

/// Create a copy of Fx
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? usdKrw = null,}) {
  return _then(Fx(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,usdKrw: null == usdKrw ? _self.usdKrw : usdKrw // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Fx].
extension FxPatterns on Fx {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Fx value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Fx() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Fx value)  $default,){
final _that = this;
switch (_that) {
case _Fx():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Fx value)?  $default,){
final _that = this;
switch (_that) {
case _Fx() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String day,  double usdKrw)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Fx() when $default != null:
return $default(_that.day,_that.usdKrw);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String day,  double usdKrw)  $default,) {final _that = this;
switch (_that) {
case _Fx():
return $default(_that.day,_that.usdKrw);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String day,  double usdKrw)?  $default,) {final _that = this;
switch (_that) {
case _Fx() when $default != null:
return $default(_that.day,_that.usdKrw);case _:
  return null;

}
}

}

/// @nodoc


class _Fx implements Fx {
  const _Fx({required this.day, required this.usdKrw});
  

@override final  String day;
@override final  double usdKrw;

/// Create a copy of Fx
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FxCopyWith<_Fx> get copyWith => __$FxCopyWithImpl<_Fx>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Fx&&(identical(other.day, day) || other.day == day)&&(identical(other.usdKrw, usdKrw) || other.usdKrw == usdKrw));
}


@override
int get hashCode {
    return Object.hash(runtimeType,day,usdKrw);
}

@override
String toString() {
    return 'Fx(day: $day, usdKrw: $usdKrw)';
}


}

/// @nodoc
abstract mixin class _$FxCopyWith<$Res> implements $FxCopyWith<$Res> {
  factory _$FxCopyWith(_Fx value, $Res Function(_Fx) _then) = __$FxCopyWithImpl;
@override @useResult
$Res call({
 String day, double usdKrw
});




}
/// @nodoc
class __$FxCopyWithImpl<$Res>
    implements _$FxCopyWith<$Res> {
  __$FxCopyWithImpl(this._self, this._then);

  final _Fx _self;
  final $Res Function(_Fx) _then;

/// Create a copy of Fx
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? usdKrw = null,}) {
  return _then(_Fx(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,usdKrw: null == usdKrw ? _self.usdKrw : usdKrw // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$Price {

 int get p25Cents; int get medianCents; int get p75Cents; int get listingCount;
/// Create a copy of Price
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceCopyWith<Price> get copyWith => _$PriceCopyWithImpl<Price>(this as Price, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Price;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Price&&(identical(other.p25Cents, _this.p25Cents) || other.p25Cents == _this.p25Cents)&&(identical(other.medianCents, _this.medianCents) || other.medianCents == _this.medianCents)&&(identical(other.p75Cents, _this.p75Cents) || other.p75Cents == _this.p75Cents)&&(identical(other.listingCount, _this.listingCount) || other.listingCount == _this.listingCount));
}


@override
int get hashCode {
  final _this = this as Price;
  return Object.hash(runtimeType,_this.p25Cents,_this.medianCents,_this.p75Cents,_this.listingCount);
}

@override
String toString() {
  final _this = this as Price;
  return 'Price(p25Cents: ${_this.p25Cents}, medianCents: ${_this.medianCents}, p75Cents: ${_this.p75Cents}, listingCount: ${_this.listingCount})';
}


}

/// @nodoc
abstract mixin class $PriceCopyWith<$Res>  {
  factory $PriceCopyWith(Price value, $Res Function(Price) _then) = _$PriceCopyWithImpl;
@useResult
$Res call({
 int p25Cents, int medianCents, int p75Cents, int listingCount
});




}
/// @nodoc
class _$PriceCopyWithImpl<$Res>
    implements $PriceCopyWith<$Res> {
  _$PriceCopyWithImpl(this._self, this._then);

  final Price _self;
  final $Res Function(Price) _then;

/// Create a copy of Price
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? p25Cents = null,Object? medianCents = null,Object? p75Cents = null,Object? listingCount = null,}) {
  return _then(Price(
p25Cents: null == p25Cents ? _self.p25Cents : p25Cents // ignore: cast_nullable_to_non_nullable
as int,medianCents: null == medianCents ? _self.medianCents : medianCents // ignore: cast_nullable_to_non_nullable
as int,p75Cents: null == p75Cents ? _self.p75Cents : p75Cents // ignore: cast_nullable_to_non_nullable
as int,listingCount: null == listingCount ? _self.listingCount : listingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Price].
extension PricePatterns on Price {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Price value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Price() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Price value)  $default,){
final _that = this;
switch (_that) {
case _Price():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Price value)?  $default,){
final _that = this;
switch (_that) {
case _Price() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int p25Cents,  int medianCents,  int p75Cents,  int listingCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Price() when $default != null:
return $default(_that.p25Cents,_that.medianCents,_that.p75Cents,_that.listingCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int p25Cents,  int medianCents,  int p75Cents,  int listingCount)  $default,) {final _that = this;
switch (_that) {
case _Price():
return $default(_that.p25Cents,_that.medianCents,_that.p75Cents,_that.listingCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int p25Cents,  int medianCents,  int p75Cents,  int listingCount)?  $default,) {final _that = this;
switch (_that) {
case _Price() when $default != null:
return $default(_that.p25Cents,_that.medianCents,_that.p75Cents,_that.listingCount);case _:
  return null;

}
}

}

/// @nodoc


class _Price implements Price {
  const _Price({required this.p25Cents, required this.medianCents, required this.p75Cents, required this.listingCount});
  

@override final  int p25Cents;
@override final  int medianCents;
@override final  int p75Cents;
@override final  int listingCount;

/// Create a copy of Price
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceCopyWith<_Price> get copyWith => __$PriceCopyWithImpl<_Price>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Price&&(identical(other.p25Cents, p25Cents) || other.p25Cents == p25Cents)&&(identical(other.medianCents, medianCents) || other.medianCents == medianCents)&&(identical(other.p75Cents, p75Cents) || other.p75Cents == p75Cents)&&(identical(other.listingCount, listingCount) || other.listingCount == listingCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,p25Cents,medianCents,p75Cents,listingCount);
}

@override
String toString() {
    return 'Price(p25Cents: $p25Cents, medianCents: $medianCents, p75Cents: $p75Cents, listingCount: $listingCount)';
}


}

/// @nodoc
abstract mixin class _$PriceCopyWith<$Res> implements $PriceCopyWith<$Res> {
  factory _$PriceCopyWith(_Price value, $Res Function(_Price) _then) = __$PriceCopyWithImpl;
@override @useResult
$Res call({
 int p25Cents, int medianCents, int p75Cents, int listingCount
});




}
/// @nodoc
class __$PriceCopyWithImpl<$Res>
    implements _$PriceCopyWith<$Res> {
  __$PriceCopyWithImpl(this._self, this._then);

  final _Price _self;
  final $Res Function(_Price) _then;

/// Create a copy of Price
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? p25Cents = null,Object? medianCents = null,Object? p75Cents = null,Object? listingCount = null,}) {
  return _then(_Price(
p25Cents: null == p25Cents ? _self.p25Cents : p25Cents // ignore: cast_nullable_to_non_nullable
as int,medianCents: null == medianCents ? _self.medianCents : medianCents // ignore: cast_nullable_to_non_nullable
as int,p75Cents: null == p75Cents ? _self.p75Cents : p75Cents // ignore: cast_nullable_to_non_nullable
as int,listingCount: null == listingCount ? _self.listingCount : listingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Change {

 DateTime get prevAt; int get prevP25Cents; double get pct;
/// Create a copy of Change
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeCopyWith<Change> get copyWith => _$ChangeCopyWithImpl<Change>(this as Change, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Change;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Change&&(identical(other.prevAt, _this.prevAt) || other.prevAt == _this.prevAt)&&(identical(other.prevP25Cents, _this.prevP25Cents) || other.prevP25Cents == _this.prevP25Cents)&&(identical(other.pct, _this.pct) || other.pct == _this.pct));
}


@override
int get hashCode {
  final _this = this as Change;
  return Object.hash(runtimeType,_this.prevAt,_this.prevP25Cents,_this.pct);
}

@override
String toString() {
  final _this = this as Change;
  return 'Change(prevAt: ${_this.prevAt}, prevP25Cents: ${_this.prevP25Cents}, pct: ${_this.pct})';
}


}

/// @nodoc
abstract mixin class $ChangeCopyWith<$Res>  {
  factory $ChangeCopyWith(Change value, $Res Function(Change) _then) = _$ChangeCopyWithImpl;
@useResult
$Res call({
 DateTime prevAt, int prevP25Cents, double pct
});




}
/// @nodoc
class _$ChangeCopyWithImpl<$Res>
    implements $ChangeCopyWith<$Res> {
  _$ChangeCopyWithImpl(this._self, this._then);

  final Change _self;
  final $Res Function(Change) _then;

/// Create a copy of Change
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prevAt = null,Object? prevP25Cents = null,Object? pct = null,}) {
  return _then(Change(
prevAt: null == prevAt ? _self.prevAt : prevAt // ignore: cast_nullable_to_non_nullable
as DateTime,prevP25Cents: null == prevP25Cents ? _self.prevP25Cents : prevP25Cents // ignore: cast_nullable_to_non_nullable
as int,pct: null == pct ? _self.pct : pct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Change].
extension ChangePatterns on Change {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Change value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Change() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Change value)  $default,){
final _that = this;
switch (_that) {
case _Change():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Change value)?  $default,){
final _that = this;
switch (_that) {
case _Change() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime prevAt,  int prevP25Cents,  double pct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Change() when $default != null:
return $default(_that.prevAt,_that.prevP25Cents,_that.pct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime prevAt,  int prevP25Cents,  double pct)  $default,) {final _that = this;
switch (_that) {
case _Change():
return $default(_that.prevAt,_that.prevP25Cents,_that.pct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime prevAt,  int prevP25Cents,  double pct)?  $default,) {final _that = this;
switch (_that) {
case _Change() when $default != null:
return $default(_that.prevAt,_that.prevP25Cents,_that.pct);case _:
  return null;

}
}

}

/// @nodoc


class _Change implements Change {
  const _Change({required this.prevAt, required this.prevP25Cents, required this.pct});
  

@override final  DateTime prevAt;
@override final  int prevP25Cents;
@override final  double pct;

/// Create a copy of Change
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeCopyWith<_Change> get copyWith => __$ChangeCopyWithImpl<_Change>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Change&&(identical(other.prevAt, prevAt) || other.prevAt == prevAt)&&(identical(other.prevP25Cents, prevP25Cents) || other.prevP25Cents == prevP25Cents)&&(identical(other.pct, pct) || other.pct == pct));
}


@override
int get hashCode {
    return Object.hash(runtimeType,prevAt,prevP25Cents,pct);
}

@override
String toString() {
    return 'Change(prevAt: $prevAt, prevP25Cents: $prevP25Cents, pct: $pct)';
}


}

/// @nodoc
abstract mixin class _$ChangeCopyWith<$Res> implements $ChangeCopyWith<$Res> {
  factory _$ChangeCopyWith(_Change value, $Res Function(_Change) _then) = __$ChangeCopyWithImpl;
@override @useResult
$Res call({
 DateTime prevAt, int prevP25Cents, double pct
});




}
/// @nodoc
class __$ChangeCopyWithImpl<$Res>
    implements _$ChangeCopyWith<$Res> {
  __$ChangeCopyWithImpl(this._self, this._then);

  final _Change _self;
  final $Res Function(_Change) _then;

/// Create a copy of Change
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prevAt = null,Object? prevP25Cents = null,Object? pct = null,}) {
  return _then(_Change(
prevAt: null == prevAt ? _self.prevAt : prevAt // ignore: cast_nullable_to_non_nullable
as DateTime,prevP25Cents: null == prevP25Cents ? _self.prevP25Cents : prevP25Cents // ignore: cast_nullable_to_non_nullable
as int,pct: null == pct ? _self.pct : pct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$Links {

 String get ebay; String get danawa;
/// Create a copy of Links
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinksCopyWith<Links> get copyWith => _$LinksCopyWithImpl<Links>(this as Links, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Links;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Links&&(identical(other.ebay, _this.ebay) || other.ebay == _this.ebay)&&(identical(other.danawa, _this.danawa) || other.danawa == _this.danawa));
}


@override
int get hashCode {
  final _this = this as Links;
  return Object.hash(runtimeType,_this.ebay,_this.danawa);
}

@override
String toString() {
  final _this = this as Links;
  return 'Links(ebay: ${_this.ebay}, danawa: ${_this.danawa})';
}


}

/// @nodoc
abstract mixin class $LinksCopyWith<$Res>  {
  factory $LinksCopyWith(Links value, $Res Function(Links) _then) = _$LinksCopyWithImpl;
@useResult
$Res call({
 String ebay, String danawa
});




}
/// @nodoc
class _$LinksCopyWithImpl<$Res>
    implements $LinksCopyWith<$Res> {
  _$LinksCopyWithImpl(this._self, this._then);

  final Links _self;
  final $Res Function(Links) _then;

/// Create a copy of Links
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ebay = null,Object? danawa = null,}) {
  return _then(Links(
ebay: null == ebay ? _self.ebay : ebay // ignore: cast_nullable_to_non_nullable
as String,danawa: null == danawa ? _self.danawa : danawa // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Links].
extension LinksPatterns on Links {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Links value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Links() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Links value)  $default,){
final _that = this;
switch (_that) {
case _Links():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Links value)?  $default,){
final _that = this;
switch (_that) {
case _Links() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ebay,  String danawa)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Links() when $default != null:
return $default(_that.ebay,_that.danawa);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ebay,  String danawa)  $default,) {final _that = this;
switch (_that) {
case _Links():
return $default(_that.ebay,_that.danawa);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ebay,  String danawa)?  $default,) {final _that = this;
switch (_that) {
case _Links() when $default != null:
return $default(_that.ebay,_that.danawa);case _:
  return null;

}
}

}

/// @nodoc


class _Links implements Links {
  const _Links({required this.ebay, required this.danawa});
  

@override final  String ebay;
@override final  String danawa;

/// Create a copy of Links
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LinksCopyWith<_Links> get copyWith => __$LinksCopyWithImpl<_Links>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Links&&(identical(other.ebay, ebay) || other.ebay == ebay)&&(identical(other.danawa, danawa) || other.danawa == danawa));
}


@override
int get hashCode {
    return Object.hash(runtimeType,ebay,danawa);
}

@override
String toString() {
    return 'Links(ebay: $ebay, danawa: $danawa)';
}


}

/// @nodoc
abstract mixin class _$LinksCopyWith<$Res> implements $LinksCopyWith<$Res> {
  factory _$LinksCopyWith(_Links value, $Res Function(_Links) _then) = __$LinksCopyWithImpl;
@override @useResult
$Res call({
 String ebay, String danawa
});




}
/// @nodoc
class __$LinksCopyWithImpl<$Res>
    implements _$LinksCopyWith<$Res> {
  __$LinksCopyWithImpl(this._self, this._then);

  final _Links _self;
  final $Res Function(_Links) _then;

/// Create a copy of Links
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ebay = null,Object? danawa = null,}) {
  return _then(_Links(
ebay: null == ebay ? _self.ebay : ebay // ignore: cast_nullable_to_non_nullable
as String,danawa: null == danawa ? _self.danawa : danawa // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SparkPoint {

 DateTime get t; int get p25Cents;
/// Create a copy of SparkPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SparkPointCopyWith<SparkPoint> get copyWith => _$SparkPointCopyWithImpl<SparkPoint>(this as SparkPoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SparkPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SparkPoint&&(identical(other.t, _this.t) || other.t == _this.t)&&(identical(other.p25Cents, _this.p25Cents) || other.p25Cents == _this.p25Cents));
}


@override
int get hashCode {
  final _this = this as SparkPoint;
  return Object.hash(runtimeType,_this.t,_this.p25Cents);
}

@override
String toString() {
  final _this = this as SparkPoint;
  return 'SparkPoint(t: ${_this.t}, p25Cents: ${_this.p25Cents})';
}


}

/// @nodoc
abstract mixin class $SparkPointCopyWith<$Res>  {
  factory $SparkPointCopyWith(SparkPoint value, $Res Function(SparkPoint) _then) = _$SparkPointCopyWithImpl;
@useResult
$Res call({
 DateTime t, int p25Cents
});




}
/// @nodoc
class _$SparkPointCopyWithImpl<$Res>
    implements $SparkPointCopyWith<$Res> {
  _$SparkPointCopyWithImpl(this._self, this._then);

  final SparkPoint _self;
  final $Res Function(SparkPoint) _then;

/// Create a copy of SparkPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? t = null,Object? p25Cents = null,}) {
  return _then(SparkPoint(
t: null == t ? _self.t : t // ignore: cast_nullable_to_non_nullable
as DateTime,p25Cents: null == p25Cents ? _self.p25Cents : p25Cents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SparkPoint].
extension SparkPointPatterns on SparkPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SparkPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SparkPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SparkPoint value)  $default,){
final _that = this;
switch (_that) {
case _SparkPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SparkPoint value)?  $default,){
final _that = this;
switch (_that) {
case _SparkPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime t,  int p25Cents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SparkPoint() when $default != null:
return $default(_that.t,_that.p25Cents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime t,  int p25Cents)  $default,) {final _that = this;
switch (_that) {
case _SparkPoint():
return $default(_that.t,_that.p25Cents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime t,  int p25Cents)?  $default,) {final _that = this;
switch (_that) {
case _SparkPoint() when $default != null:
return $default(_that.t,_that.p25Cents);case _:
  return null;

}
}

}

/// @nodoc


class _SparkPoint implements SparkPoint {
  const _SparkPoint({required this.t, required this.p25Cents});
  

@override final  DateTime t;
@override final  int p25Cents;

/// Create a copy of SparkPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SparkPointCopyWith<_SparkPoint> get copyWith => __$SparkPointCopyWithImpl<_SparkPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SparkPoint&&(identical(other.t, t) || other.t == t)&&(identical(other.p25Cents, p25Cents) || other.p25Cents == p25Cents));
}


@override
int get hashCode {
    return Object.hash(runtimeType,t,p25Cents);
}

@override
String toString() {
    return 'SparkPoint(t: $t, p25Cents: $p25Cents)';
}


}

/// @nodoc
abstract mixin class _$SparkPointCopyWith<$Res> implements $SparkPointCopyWith<$Res> {
  factory _$SparkPointCopyWith(_SparkPoint value, $Res Function(_SparkPoint) _then) = __$SparkPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime t, int p25Cents
});




}
/// @nodoc
class __$SparkPointCopyWithImpl<$Res>
    implements _$SparkPointCopyWith<$Res> {
  __$SparkPointCopyWithImpl(this._self, this._then);

  final _SparkPoint _self;
  final $Res Function(_SparkPoint) _then;

/// Create a copy of SparkPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? t = null,Object? p25Cents = null,}) {
  return _then(_SparkPoint(
t: null == t ? _self.t : t // ignore: cast_nullable_to_non_nullable
as DateTime,p25Cents: null == p25Cents ? _self.p25Cents : p25Cents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$BoardItem {

 String get key; String get name;/// NVIDIA | AMD | DESKTOP (화면 글자는 앱이 번역)
 String get vendor; Price? get price; Change? get change; List<SparkPoint> get spark; Links get links;
/// Create a copy of BoardItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardItemCopyWith<BoardItem> get copyWith => _$BoardItemCopyWithImpl<BoardItem>(this as BoardItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BoardItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardItem&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.vendor, _this.vendor) || other.vendor == _this.vendor)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.change, _this.change) || other.change == _this.change)&&const DeepCollectionEquality().equals(other.spark, _this.spark)&&(identical(other.links, _this.links) || other.links == _this.links));
}


@override
int get hashCode {
  final _this = this as BoardItem;
  return Object.hash(runtimeType,_this.key,_this.name,_this.vendor,_this.price,_this.change,const DeepCollectionEquality().hash(_this.spark),_this.links);
}

@override
String toString() {
  final _this = this as BoardItem;
  return 'BoardItem(key: ${_this.key}, name: ${_this.name}, vendor: ${_this.vendor}, price: ${_this.price}, change: ${_this.change}, spark: ${_this.spark}, links: ${_this.links})';
}


}

/// @nodoc
abstract mixin class $BoardItemCopyWith<$Res>  {
  factory $BoardItemCopyWith(BoardItem value, $Res Function(BoardItem) _then) = _$BoardItemCopyWithImpl;
@useResult
$Res call({
 String key, String name, String vendor, Price? price, Change? change, List<SparkPoint> spark, Links links
});


$PriceCopyWith<$Res>? get price;$ChangeCopyWith<$Res>? get change;$LinksCopyWith<$Res> get links;

}
/// @nodoc
class _$BoardItemCopyWithImpl<$Res>
    implements $BoardItemCopyWith<$Res> {
  _$BoardItemCopyWithImpl(this._self, this._then);

  final BoardItem _self;
  final $Res Function(BoardItem) _then;

/// Create a copy of BoardItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? vendor = null,Object? price = freezed,Object? change = freezed,Object? spark = null,Object? links = null,}) {
  return _then(BoardItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Price?,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as Change?,spark: null == spark ? _self.spark : spark // ignore: cast_nullable_to_non_nullable
as List<SparkPoint>,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as Links,
  ));
}
/// Create a copy of BoardItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $PriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}/// Create a copy of BoardItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangeCopyWith<$Res>? get change {
    if (_self.change == null) {
    return null;
  }

  return $ChangeCopyWith<$Res>(_self.change!, (value) {
    return _then(_self.copyWith(change: value));
  });
}/// Create a copy of BoardItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LinksCopyWith<$Res> get links {
  
  return $LinksCopyWith<$Res>(_self.links, (value) {
    return _then(_self.copyWith(links: value));
  });
}
}


/// Adds pattern-matching-related methods to [BoardItem].
extension BoardItemPatterns on BoardItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardItem value)  $default,){
final _that = this;
switch (_that) {
case _BoardItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardItem value)?  $default,){
final _that = this;
switch (_that) {
case _BoardItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name,  String vendor,  Price? price,  Change? change,  List<SparkPoint> spark,  Links links)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardItem() when $default != null:
return $default(_that.key,_that.name,_that.vendor,_that.price,_that.change,_that.spark,_that.links);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name,  String vendor,  Price? price,  Change? change,  List<SparkPoint> spark,  Links links)  $default,) {final _that = this;
switch (_that) {
case _BoardItem():
return $default(_that.key,_that.name,_that.vendor,_that.price,_that.change,_that.spark,_that.links);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name,  String vendor,  Price? price,  Change? change,  List<SparkPoint> spark,  Links links)?  $default,) {final _that = this;
switch (_that) {
case _BoardItem() when $default != null:
return $default(_that.key,_that.name,_that.vendor,_that.price,_that.change,_that.spark,_that.links);case _:
  return null;

}
}

}

/// @nodoc


class _BoardItem implements BoardItem {
  const _BoardItem({required this.key, required this.name, required this.vendor, this.price, this.change, required  List<SparkPoint> spark, required this.links}): _spark = spark;
  

@override final  String key;
@override final  String name;
/// NVIDIA | AMD | DESKTOP (화면 글자는 앱이 번역)
@override final  String vendor;
@override final  Price? price;
@override final  Change? change;
 final  List<SparkPoint> _spark;
@override List<SparkPoint> get spark {
  if (_spark is EqualUnmodifiableListView) return _spark;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_spark);
}

@override final  Links links;

/// Create a copy of BoardItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardItemCopyWith<_BoardItem> get copyWith => __$BoardItemCopyWithImpl<_BoardItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardItem&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.price, price) || other.price == price)&&(identical(other.change, change) || other.change == change)&&const DeepCollectionEquality().equals(other.spark, _spark)&&(identical(other.links, links) || other.links == links));
}


@override
int get hashCode {
    return Object.hash(runtimeType,key,name,vendor,price,change,const DeepCollectionEquality().hash(_spark),links);
}

@override
String toString() {
    return 'BoardItem(key: $key, name: $name, vendor: $vendor, price: $price, change: $change, spark: $spark, links: $links)';
}


}

/// @nodoc
abstract mixin class _$BoardItemCopyWith<$Res> implements $BoardItemCopyWith<$Res> {
  factory _$BoardItemCopyWith(_BoardItem value, $Res Function(_BoardItem) _then) = __$BoardItemCopyWithImpl;
@override @useResult
$Res call({
 String key, String name, String vendor, Price? price, Change? change, List<SparkPoint> spark, Links links
});


@override $PriceCopyWith<$Res>? get price;@override $ChangeCopyWith<$Res>? get change;@override $LinksCopyWith<$Res> get links;

}
/// @nodoc
class __$BoardItemCopyWithImpl<$Res>
    implements _$BoardItemCopyWith<$Res> {
  __$BoardItemCopyWithImpl(this._self, this._then);

  final _BoardItem _self;
  final $Res Function(_BoardItem) _then;

/// Create a copy of BoardItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? vendor = null,Object? price = freezed,Object? change = freezed,Object? spark = null,Object? links = null,}) {
  return _then(_BoardItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Price?,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as Change?,spark: null == spark ? _self._spark : spark // ignore: cast_nullable_to_non_nullable
as List<SparkPoint>,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as Links,
  ));
}

/// Create a copy of BoardItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $PriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}/// Create a copy of BoardItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangeCopyWith<$Res>? get change {
    if (_self.change == null) {
    return null;
  }

  return $ChangeCopyWith<$Res>(_self.change!, (value) {
    return _then(_self.copyWith(change: value));
  });
}/// Create a copy of BoardItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LinksCopyWith<$Res> get links {
  
  return $LinksCopyWith<$Res>(_self.links, (value) {
    return _then(_self.copyWith(links: value));
  });
}
}

/// @nodoc
mixin _$Board {

 String get category; DateTime? get updatedAt; Fx? get fx; List<BoardItem> get items;
/// Create a copy of Board
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardCopyWith<Board> get copyWith => _$BoardCopyWithImpl<Board>(this as Board, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Board;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Board&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.fx, _this.fx) || other.fx == _this.fx)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as Board;
  return Object.hash(runtimeType,_this.category,_this.updatedAt,_this.fx,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as Board;
  return 'Board(category: ${_this.category}, updatedAt: ${_this.updatedAt}, fx: ${_this.fx}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $BoardCopyWith<$Res>  {
  factory $BoardCopyWith(Board value, $Res Function(Board) _then) = _$BoardCopyWithImpl;
@useResult
$Res call({
 String category, DateTime? updatedAt, Fx? fx, List<BoardItem> items
});


$FxCopyWith<$Res>? get fx;

}
/// @nodoc
class _$BoardCopyWithImpl<$Res>
    implements $BoardCopyWith<$Res> {
  _$BoardCopyWithImpl(this._self, this._then);

  final Board _self;
  final $Res Function(Board) _then;

/// Create a copy of Board
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? updatedAt = freezed,Object? fx = freezed,Object? items = null,}) {
  return _then(Board(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fx: freezed == fx ? _self.fx : fx // ignore: cast_nullable_to_non_nullable
as Fx?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BoardItem>,
  ));
}
/// Create a copy of Board
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FxCopyWith<$Res>? get fx {
    if (_self.fx == null) {
    return null;
  }

  return $FxCopyWith<$Res>(_self.fx!, (value) {
    return _then(_self.copyWith(fx: value));
  });
}
}


/// Adds pattern-matching-related methods to [Board].
extension BoardPatterns on Board {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Board value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Board() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Board value)  $default,){
final _that = this;
switch (_that) {
case _Board():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Board value)?  $default,){
final _that = this;
switch (_that) {
case _Board() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String category,  DateTime? updatedAt,  Fx? fx,  List<BoardItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Board() when $default != null:
return $default(_that.category,_that.updatedAt,_that.fx,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String category,  DateTime? updatedAt,  Fx? fx,  List<BoardItem> items)  $default,) {final _that = this;
switch (_that) {
case _Board():
return $default(_that.category,_that.updatedAt,_that.fx,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String category,  DateTime? updatedAt,  Fx? fx,  List<BoardItem> items)?  $default,) {final _that = this;
switch (_that) {
case _Board() when $default != null:
return $default(_that.category,_that.updatedAt,_that.fx,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _Board implements Board {
  const _Board({required this.category, this.updatedAt, this.fx, required  List<BoardItem> items}): _items = items;
  

@override final  String category;
@override final  DateTime? updatedAt;
@override final  Fx? fx;
 final  List<BoardItem> _items;
@override List<BoardItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Board
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardCopyWith<_Board> get copyWith => __$BoardCopyWithImpl<_Board>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Board&&(identical(other.category, category) || other.category == category)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.fx, fx) || other.fx == fx)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,category,updatedAt,fx,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'Board(category: $category, updatedAt: $updatedAt, fx: $fx, items: $items)';
}


}

/// @nodoc
abstract mixin class _$BoardCopyWith<$Res> implements $BoardCopyWith<$Res> {
  factory _$BoardCopyWith(_Board value, $Res Function(_Board) _then) = __$BoardCopyWithImpl;
@override @useResult
$Res call({
 String category, DateTime? updatedAt, Fx? fx, List<BoardItem> items
});


@override $FxCopyWith<$Res>? get fx;

}
/// @nodoc
class __$BoardCopyWithImpl<$Res>
    implements _$BoardCopyWith<$Res> {
  __$BoardCopyWithImpl(this._self, this._then);

  final _Board _self;
  final $Res Function(_Board) _then;

/// Create a copy of Board
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? updatedAt = freezed,Object? fx = freezed,Object? items = null,}) {
  return _then(_Board(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fx: freezed == fx ? _self.fx : fx // ignore: cast_nullable_to_non_nullable
as Fx?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BoardItem>,
  ));
}

/// Create a copy of Board
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FxCopyWith<$Res>? get fx {
    if (_self.fx == null) {
    return null;
  }

  return $FxCopyWith<$Res>(_self.fx!, (value) {
    return _then(_self.copyWith(fx: value));
  });
}
}

/// @nodoc
mixin _$TickerInfo {

 String get key;/// CHIPSET | MAKER | MODEL
 String get level; String get category; String get name; String get chipsetName; String? get makerName; String? get seriesName;
/// Create a copy of TickerInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TickerInfoCopyWith<TickerInfo> get copyWith => _$TickerInfoCopyWithImpl<TickerInfo>(this as TickerInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TickerInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TickerInfo&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.chipsetName, _this.chipsetName) || other.chipsetName == _this.chipsetName)&&(identical(other.makerName, _this.makerName) || other.makerName == _this.makerName)&&(identical(other.seriesName, _this.seriesName) || other.seriesName == _this.seriesName));
}


@override
int get hashCode {
  final _this = this as TickerInfo;
  return Object.hash(runtimeType,_this.key,_this.level,_this.category,_this.name,_this.chipsetName,_this.makerName,_this.seriesName);
}

@override
String toString() {
  final _this = this as TickerInfo;
  return 'TickerInfo(key: ${_this.key}, level: ${_this.level}, category: ${_this.category}, name: ${_this.name}, chipsetName: ${_this.chipsetName}, makerName: ${_this.makerName}, seriesName: ${_this.seriesName})';
}


}

/// @nodoc
abstract mixin class $TickerInfoCopyWith<$Res>  {
  factory $TickerInfoCopyWith(TickerInfo value, $Res Function(TickerInfo) _then) = _$TickerInfoCopyWithImpl;
@useResult
$Res call({
 String key, String level, String category, String name, String chipsetName, String? makerName, String? seriesName
});




}
/// @nodoc
class _$TickerInfoCopyWithImpl<$Res>
    implements $TickerInfoCopyWith<$Res> {
  _$TickerInfoCopyWithImpl(this._self, this._then);

  final TickerInfo _self;
  final $Res Function(TickerInfo) _then;

/// Create a copy of TickerInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? level = null,Object? category = null,Object? name = null,Object? chipsetName = null,Object? makerName = freezed,Object? seriesName = freezed,}) {
  return _then(TickerInfo(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,chipsetName: null == chipsetName ? _self.chipsetName : chipsetName // ignore: cast_nullable_to_non_nullable
as String,makerName: freezed == makerName ? _self.makerName : makerName // ignore: cast_nullable_to_non_nullable
as String?,seriesName: freezed == seriesName ? _self.seriesName : seriesName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TickerInfo].
extension TickerInfoPatterns on TickerInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TickerInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TickerInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TickerInfo value)  $default,){
final _that = this;
switch (_that) {
case _TickerInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TickerInfo value)?  $default,){
final _that = this;
switch (_that) {
case _TickerInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String level,  String category,  String name,  String chipsetName,  String? makerName,  String? seriesName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TickerInfo() when $default != null:
return $default(_that.key,_that.level,_that.category,_that.name,_that.chipsetName,_that.makerName,_that.seriesName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String level,  String category,  String name,  String chipsetName,  String? makerName,  String? seriesName)  $default,) {final _that = this;
switch (_that) {
case _TickerInfo():
return $default(_that.key,_that.level,_that.category,_that.name,_that.chipsetName,_that.makerName,_that.seriesName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String level,  String category,  String name,  String chipsetName,  String? makerName,  String? seriesName)?  $default,) {final _that = this;
switch (_that) {
case _TickerInfo() when $default != null:
return $default(_that.key,_that.level,_that.category,_that.name,_that.chipsetName,_that.makerName,_that.seriesName);case _:
  return null;

}
}

}

/// @nodoc


class _TickerInfo implements TickerInfo {
  const _TickerInfo({required this.key, required this.level, required this.category, required this.name, required this.chipsetName, this.makerName, this.seriesName});
  

@override final  String key;
/// CHIPSET | MAKER | MODEL
@override final  String level;
@override final  String category;
@override final  String name;
@override final  String chipsetName;
@override final  String? makerName;
@override final  String? seriesName;

/// Create a copy of TickerInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TickerInfoCopyWith<_TickerInfo> get copyWith => __$TickerInfoCopyWithImpl<_TickerInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TickerInfo&&(identical(other.key, key) || other.key == key)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.name, name) || other.name == name)&&(identical(other.chipsetName, chipsetName) || other.chipsetName == chipsetName)&&(identical(other.makerName, makerName) || other.makerName == makerName)&&(identical(other.seriesName, seriesName) || other.seriesName == seriesName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,key,level,category,name,chipsetName,makerName,seriesName);
}

@override
String toString() {
    return 'TickerInfo(key: $key, level: $level, category: $category, name: $name, chipsetName: $chipsetName, makerName: $makerName, seriesName: $seriesName)';
}


}

/// @nodoc
abstract mixin class _$TickerInfoCopyWith<$Res> implements $TickerInfoCopyWith<$Res> {
  factory _$TickerInfoCopyWith(_TickerInfo value, $Res Function(_TickerInfo) _then) = __$TickerInfoCopyWithImpl;
@override @useResult
$Res call({
 String key, String level, String category, String name, String chipsetName, String? makerName, String? seriesName
});




}
/// @nodoc
class __$TickerInfoCopyWithImpl<$Res>
    implements _$TickerInfoCopyWith<$Res> {
  __$TickerInfoCopyWithImpl(this._self, this._then);

  final _TickerInfo _self;
  final $Res Function(_TickerInfo) _then;

/// Create a copy of TickerInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? level = null,Object? category = null,Object? name = null,Object? chipsetName = null,Object? makerName = freezed,Object? seriesName = freezed,}) {
  return _then(_TickerInfo(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,chipsetName: null == chipsetName ? _self.chipsetName : chipsetName // ignore: cast_nullable_to_non_nullable
as String,makerName: freezed == makerName ? _self.makerName : makerName // ignore: cast_nullable_to_non_nullable
as String?,seriesName: freezed == seriesName ? _self.seriesName : seriesName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$Child {

 String get key; String get level; String get name; Price? get price; Change? get change; Links get links;
/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildCopyWith<Child> get copyWith => _$ChildCopyWithImpl<Child>(this as Child, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Child;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Child&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.change, _this.change) || other.change == _this.change)&&(identical(other.links, _this.links) || other.links == _this.links));
}


@override
int get hashCode {
  final _this = this as Child;
  return Object.hash(runtimeType,_this.key,_this.level,_this.name,_this.price,_this.change,_this.links);
}

@override
String toString() {
  final _this = this as Child;
  return 'Child(key: ${_this.key}, level: ${_this.level}, name: ${_this.name}, price: ${_this.price}, change: ${_this.change}, links: ${_this.links})';
}


}

/// @nodoc
abstract mixin class $ChildCopyWith<$Res>  {
  factory $ChildCopyWith(Child value, $Res Function(Child) _then) = _$ChildCopyWithImpl;
@useResult
$Res call({
 String key, String level, String name, Price? price, Change? change, Links links
});


$PriceCopyWith<$Res>? get price;$ChangeCopyWith<$Res>? get change;$LinksCopyWith<$Res> get links;

}
/// @nodoc
class _$ChildCopyWithImpl<$Res>
    implements $ChildCopyWith<$Res> {
  _$ChildCopyWithImpl(this._self, this._then);

  final Child _self;
  final $Res Function(Child) _then;

/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? level = null,Object? name = null,Object? price = freezed,Object? change = freezed,Object? links = null,}) {
  return _then(Child(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Price?,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as Change?,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as Links,
  ));
}
/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $PriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangeCopyWith<$Res>? get change {
    if (_self.change == null) {
    return null;
  }

  return $ChangeCopyWith<$Res>(_self.change!, (value) {
    return _then(_self.copyWith(change: value));
  });
}/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LinksCopyWith<$Res> get links {
  
  return $LinksCopyWith<$Res>(_self.links, (value) {
    return _then(_self.copyWith(links: value));
  });
}
}


/// Adds pattern-matching-related methods to [Child].
extension ChildPatterns on Child {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Child value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Child() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Child value)  $default,){
final _that = this;
switch (_that) {
case _Child():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Child value)?  $default,){
final _that = this;
switch (_that) {
case _Child() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String level,  String name,  Price? price,  Change? change,  Links links)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Child() when $default != null:
return $default(_that.key,_that.level,_that.name,_that.price,_that.change,_that.links);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String level,  String name,  Price? price,  Change? change,  Links links)  $default,) {final _that = this;
switch (_that) {
case _Child():
return $default(_that.key,_that.level,_that.name,_that.price,_that.change,_that.links);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String level,  String name,  Price? price,  Change? change,  Links links)?  $default,) {final _that = this;
switch (_that) {
case _Child() when $default != null:
return $default(_that.key,_that.level,_that.name,_that.price,_that.change,_that.links);case _:
  return null;

}
}

}

/// @nodoc


class _Child implements Child {
  const _Child({required this.key, required this.level, required this.name, this.price, this.change, required this.links});
  

@override final  String key;
@override final  String level;
@override final  String name;
@override final  Price? price;
@override final  Change? change;
@override final  Links links;

/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildCopyWith<_Child> get copyWith => __$ChildCopyWithImpl<_Child>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Child&&(identical(other.key, key) || other.key == key)&&(identical(other.level, level) || other.level == level)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.change, change) || other.change == change)&&(identical(other.links, links) || other.links == links));
}


@override
int get hashCode {
    return Object.hash(runtimeType,key,level,name,price,change,links);
}

@override
String toString() {
    return 'Child(key: $key, level: $level, name: $name, price: $price, change: $change, links: $links)';
}


}

/// @nodoc
abstract mixin class _$ChildCopyWith<$Res> implements $ChildCopyWith<$Res> {
  factory _$ChildCopyWith(_Child value, $Res Function(_Child) _then) = __$ChildCopyWithImpl;
@override @useResult
$Res call({
 String key, String level, String name, Price? price, Change? change, Links links
});


@override $PriceCopyWith<$Res>? get price;@override $ChangeCopyWith<$Res>? get change;@override $LinksCopyWith<$Res> get links;

}
/// @nodoc
class __$ChildCopyWithImpl<$Res>
    implements _$ChildCopyWith<$Res> {
  __$ChildCopyWithImpl(this._self, this._then);

  final _Child _self;
  final $Res Function(_Child) _then;

/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? level = null,Object? name = null,Object? price = freezed,Object? change = freezed,Object? links = null,}) {
  return _then(_Child(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Price?,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as Change?,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as Links,
  ));
}

/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $PriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangeCopyWith<$Res>? get change {
    if (_self.change == null) {
    return null;
  }

  return $ChangeCopyWith<$Res>(_self.change!, (value) {
    return _then(_self.copyWith(change: value));
  });
}/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LinksCopyWith<$Res> get links {
  
  return $LinksCopyWith<$Res>(_self.links, (value) {
    return _then(_self.copyWith(links: value));
  });
}
}

/// @nodoc
mixin _$TickerDetail {

 TickerInfo get ticker; DateTime? get updatedAt; Fx? get fx; Price? get price; Change? get change; List<Child> get makers; List<Child> get models; Links get links;
/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TickerDetailCopyWith<TickerDetail> get copyWith => _$TickerDetailCopyWithImpl<TickerDetail>(this as TickerDetail, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TickerDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TickerDetail&&(identical(other.ticker, _this.ticker) || other.ticker == _this.ticker)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.fx, _this.fx) || other.fx == _this.fx)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.change, _this.change) || other.change == _this.change)&&const DeepCollectionEquality().equals(other.makers, _this.makers)&&const DeepCollectionEquality().equals(other.models, _this.models)&&(identical(other.links, _this.links) || other.links == _this.links));
}


@override
int get hashCode {
  final _this = this as TickerDetail;
  return Object.hash(runtimeType,_this.ticker,_this.updatedAt,_this.fx,_this.price,_this.change,const DeepCollectionEquality().hash(_this.makers),const DeepCollectionEquality().hash(_this.models),_this.links);
}

@override
String toString() {
  final _this = this as TickerDetail;
  return 'TickerDetail(ticker: ${_this.ticker}, updatedAt: ${_this.updatedAt}, fx: ${_this.fx}, price: ${_this.price}, change: ${_this.change}, makers: ${_this.makers}, models: ${_this.models}, links: ${_this.links})';
}


}

/// @nodoc
abstract mixin class $TickerDetailCopyWith<$Res>  {
  factory $TickerDetailCopyWith(TickerDetail value, $Res Function(TickerDetail) _then) = _$TickerDetailCopyWithImpl;
@useResult
$Res call({
 TickerInfo ticker, DateTime? updatedAt, Fx? fx, Price? price, Change? change, List<Child> makers, List<Child> models, Links links
});


$TickerInfoCopyWith<$Res> get ticker;$FxCopyWith<$Res>? get fx;$PriceCopyWith<$Res>? get price;$ChangeCopyWith<$Res>? get change;$LinksCopyWith<$Res> get links;

}
/// @nodoc
class _$TickerDetailCopyWithImpl<$Res>
    implements $TickerDetailCopyWith<$Res> {
  _$TickerDetailCopyWithImpl(this._self, this._then);

  final TickerDetail _self;
  final $Res Function(TickerDetail) _then;

/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ticker = null,Object? updatedAt = freezed,Object? fx = freezed,Object? price = freezed,Object? change = freezed,Object? makers = null,Object? models = null,Object? links = null,}) {
  return _then(TickerDetail(
ticker: null == ticker ? _self.ticker : ticker // ignore: cast_nullable_to_non_nullable
as TickerInfo,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fx: freezed == fx ? _self.fx : fx // ignore: cast_nullable_to_non_nullable
as Fx?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Price?,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as Change?,makers: null == makers ? _self.makers : makers // ignore: cast_nullable_to_non_nullable
as List<Child>,models: null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<Child>,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as Links,
  ));
}
/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TickerInfoCopyWith<$Res> get ticker {
  
  return $TickerInfoCopyWith<$Res>(_self.ticker, (value) {
    return _then(_self.copyWith(ticker: value));
  });
}/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FxCopyWith<$Res>? get fx {
    if (_self.fx == null) {
    return null;
  }

  return $FxCopyWith<$Res>(_self.fx!, (value) {
    return _then(_self.copyWith(fx: value));
  });
}/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $PriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangeCopyWith<$Res>? get change {
    if (_self.change == null) {
    return null;
  }

  return $ChangeCopyWith<$Res>(_self.change!, (value) {
    return _then(_self.copyWith(change: value));
  });
}/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LinksCopyWith<$Res> get links {
  
  return $LinksCopyWith<$Res>(_self.links, (value) {
    return _then(_self.copyWith(links: value));
  });
}
}


/// Adds pattern-matching-related methods to [TickerDetail].
extension TickerDetailPatterns on TickerDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TickerDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TickerDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TickerDetail value)  $default,){
final _that = this;
switch (_that) {
case _TickerDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TickerDetail value)?  $default,){
final _that = this;
switch (_that) {
case _TickerDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TickerInfo ticker,  DateTime? updatedAt,  Fx? fx,  Price? price,  Change? change,  List<Child> makers,  List<Child> models,  Links links)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TickerDetail() when $default != null:
return $default(_that.ticker,_that.updatedAt,_that.fx,_that.price,_that.change,_that.makers,_that.models,_that.links);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TickerInfo ticker,  DateTime? updatedAt,  Fx? fx,  Price? price,  Change? change,  List<Child> makers,  List<Child> models,  Links links)  $default,) {final _that = this;
switch (_that) {
case _TickerDetail():
return $default(_that.ticker,_that.updatedAt,_that.fx,_that.price,_that.change,_that.makers,_that.models,_that.links);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TickerInfo ticker,  DateTime? updatedAt,  Fx? fx,  Price? price,  Change? change,  List<Child> makers,  List<Child> models,  Links links)?  $default,) {final _that = this;
switch (_that) {
case _TickerDetail() when $default != null:
return $default(_that.ticker,_that.updatedAt,_that.fx,_that.price,_that.change,_that.makers,_that.models,_that.links);case _:
  return null;

}
}

}

/// @nodoc


class _TickerDetail implements TickerDetail {
  const _TickerDetail({required this.ticker, this.updatedAt, this.fx, this.price, this.change, required  List<Child> makers, required  List<Child> models, required this.links}): _makers = makers,_models = models;
  

@override final  TickerInfo ticker;
@override final  DateTime? updatedAt;
@override final  Fx? fx;
@override final  Price? price;
@override final  Change? change;
 final  List<Child> _makers;
@override List<Child> get makers {
  if (_makers is EqualUnmodifiableListView) return _makers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_makers);
}

 final  List<Child> _models;
@override List<Child> get models {
  if (_models is EqualUnmodifiableListView) return _models;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_models);
}

@override final  Links links;

/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TickerDetailCopyWith<_TickerDetail> get copyWith => __$TickerDetailCopyWithImpl<_TickerDetail>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TickerDetail&&(identical(other.ticker, ticker) || other.ticker == ticker)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.fx, fx) || other.fx == fx)&&(identical(other.price, price) || other.price == price)&&(identical(other.change, change) || other.change == change)&&const DeepCollectionEquality().equals(other.makers, _makers)&&const DeepCollectionEquality().equals(other.models, _models)&&(identical(other.links, links) || other.links == links));
}


@override
int get hashCode {
    return Object.hash(runtimeType,ticker,updatedAt,fx,price,change,const DeepCollectionEquality().hash(_makers),const DeepCollectionEquality().hash(_models),links);
}

@override
String toString() {
    return 'TickerDetail(ticker: $ticker, updatedAt: $updatedAt, fx: $fx, price: $price, change: $change, makers: $makers, models: $models, links: $links)';
}


}

/// @nodoc
abstract mixin class _$TickerDetailCopyWith<$Res> implements $TickerDetailCopyWith<$Res> {
  factory _$TickerDetailCopyWith(_TickerDetail value, $Res Function(_TickerDetail) _then) = __$TickerDetailCopyWithImpl;
@override @useResult
$Res call({
 TickerInfo ticker, DateTime? updatedAt, Fx? fx, Price? price, Change? change, List<Child> makers, List<Child> models, Links links
});


@override $TickerInfoCopyWith<$Res> get ticker;@override $FxCopyWith<$Res>? get fx;@override $PriceCopyWith<$Res>? get price;@override $ChangeCopyWith<$Res>? get change;@override $LinksCopyWith<$Res> get links;

}
/// @nodoc
class __$TickerDetailCopyWithImpl<$Res>
    implements _$TickerDetailCopyWith<$Res> {
  __$TickerDetailCopyWithImpl(this._self, this._then);

  final _TickerDetail _self;
  final $Res Function(_TickerDetail) _then;

/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ticker = null,Object? updatedAt = freezed,Object? fx = freezed,Object? price = freezed,Object? change = freezed,Object? makers = null,Object? models = null,Object? links = null,}) {
  return _then(_TickerDetail(
ticker: null == ticker ? _self.ticker : ticker // ignore: cast_nullable_to_non_nullable
as TickerInfo,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fx: freezed == fx ? _self.fx : fx // ignore: cast_nullable_to_non_nullable
as Fx?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Price?,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as Change?,makers: null == makers ? _self._makers : makers // ignore: cast_nullable_to_non_nullable
as List<Child>,models: null == models ? _self._models : models // ignore: cast_nullable_to_non_nullable
as List<Child>,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as Links,
  ));
}

/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TickerInfoCopyWith<$Res> get ticker {
  
  return $TickerInfoCopyWith<$Res>(_self.ticker, (value) {
    return _then(_self.copyWith(ticker: value));
  });
}/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FxCopyWith<$Res>? get fx {
    if (_self.fx == null) {
    return null;
  }

  return $FxCopyWith<$Res>(_self.fx!, (value) {
    return _then(_self.copyWith(fx: value));
  });
}/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $PriceCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangeCopyWith<$Res>? get change {
    if (_self.change == null) {
    return null;
  }

  return $ChangeCopyWith<$Res>(_self.change!, (value) {
    return _then(_self.copyWith(change: value));
  });
}/// Create a copy of TickerDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LinksCopyWith<$Res> get links {
  
  return $LinksCopyWith<$Res>(_self.links, (value) {
    return _then(_self.copyWith(links: value));
  });
}
}

/// @nodoc
mixin _$Bar {

 DateTime get t; int get openCents; int get highCents; int get lowCents; int get closeCents; int get medianCents; int get samples;
/// Create a copy of Bar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BarCopyWith<Bar> get copyWith => _$BarCopyWithImpl<Bar>(this as Bar, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Bar;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bar&&(identical(other.t, _this.t) || other.t == _this.t)&&(identical(other.openCents, _this.openCents) || other.openCents == _this.openCents)&&(identical(other.highCents, _this.highCents) || other.highCents == _this.highCents)&&(identical(other.lowCents, _this.lowCents) || other.lowCents == _this.lowCents)&&(identical(other.closeCents, _this.closeCents) || other.closeCents == _this.closeCents)&&(identical(other.medianCents, _this.medianCents) || other.medianCents == _this.medianCents)&&(identical(other.samples, _this.samples) || other.samples == _this.samples));
}


@override
int get hashCode {
  final _this = this as Bar;
  return Object.hash(runtimeType,_this.t,_this.openCents,_this.highCents,_this.lowCents,_this.closeCents,_this.medianCents,_this.samples);
}

@override
String toString() {
  final _this = this as Bar;
  return 'Bar(t: ${_this.t}, openCents: ${_this.openCents}, highCents: ${_this.highCents}, lowCents: ${_this.lowCents}, closeCents: ${_this.closeCents}, medianCents: ${_this.medianCents}, samples: ${_this.samples})';
}


}

/// @nodoc
abstract mixin class $BarCopyWith<$Res>  {
  factory $BarCopyWith(Bar value, $Res Function(Bar) _then) = _$BarCopyWithImpl;
@useResult
$Res call({
 DateTime t, int openCents, int highCents, int lowCents, int closeCents, int medianCents, int samples
});




}
/// @nodoc
class _$BarCopyWithImpl<$Res>
    implements $BarCopyWith<$Res> {
  _$BarCopyWithImpl(this._self, this._then);

  final Bar _self;
  final $Res Function(Bar) _then;

/// Create a copy of Bar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? t = null,Object? openCents = null,Object? highCents = null,Object? lowCents = null,Object? closeCents = null,Object? medianCents = null,Object? samples = null,}) {
  return _then(Bar(
t: null == t ? _self.t : t // ignore: cast_nullable_to_non_nullable
as DateTime,openCents: null == openCents ? _self.openCents : openCents // ignore: cast_nullable_to_non_nullable
as int,highCents: null == highCents ? _self.highCents : highCents // ignore: cast_nullable_to_non_nullable
as int,lowCents: null == lowCents ? _self.lowCents : lowCents // ignore: cast_nullable_to_non_nullable
as int,closeCents: null == closeCents ? _self.closeCents : closeCents // ignore: cast_nullable_to_non_nullable
as int,medianCents: null == medianCents ? _self.medianCents : medianCents // ignore: cast_nullable_to_non_nullable
as int,samples: null == samples ? _self.samples : samples // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Bar].
extension BarPatterns on Bar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bar value)  $default,){
final _that = this;
switch (_that) {
case _Bar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bar value)?  $default,){
final _that = this;
switch (_that) {
case _Bar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime t,  int openCents,  int highCents,  int lowCents,  int closeCents,  int medianCents,  int samples)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bar() when $default != null:
return $default(_that.t,_that.openCents,_that.highCents,_that.lowCents,_that.closeCents,_that.medianCents,_that.samples);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime t,  int openCents,  int highCents,  int lowCents,  int closeCents,  int medianCents,  int samples)  $default,) {final _that = this;
switch (_that) {
case _Bar():
return $default(_that.t,_that.openCents,_that.highCents,_that.lowCents,_that.closeCents,_that.medianCents,_that.samples);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime t,  int openCents,  int highCents,  int lowCents,  int closeCents,  int medianCents,  int samples)?  $default,) {final _that = this;
switch (_that) {
case _Bar() when $default != null:
return $default(_that.t,_that.openCents,_that.highCents,_that.lowCents,_that.closeCents,_that.medianCents,_that.samples);case _:
  return null;

}
}

}

/// @nodoc


class _Bar implements Bar {
  const _Bar({required this.t, required this.openCents, required this.highCents, required this.lowCents, required this.closeCents, required this.medianCents, required this.samples});
  

@override final  DateTime t;
@override final  int openCents;
@override final  int highCents;
@override final  int lowCents;
@override final  int closeCents;
@override final  int medianCents;
@override final  int samples;

/// Create a copy of Bar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BarCopyWith<_Bar> get copyWith => __$BarCopyWithImpl<_Bar>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bar&&(identical(other.t, t) || other.t == t)&&(identical(other.openCents, openCents) || other.openCents == openCents)&&(identical(other.highCents, highCents) || other.highCents == highCents)&&(identical(other.lowCents, lowCents) || other.lowCents == lowCents)&&(identical(other.closeCents, closeCents) || other.closeCents == closeCents)&&(identical(other.medianCents, medianCents) || other.medianCents == medianCents)&&(identical(other.samples, samples) || other.samples == samples));
}


@override
int get hashCode {
    return Object.hash(runtimeType,t,openCents,highCents,lowCents,closeCents,medianCents,samples);
}

@override
String toString() {
    return 'Bar(t: $t, openCents: $openCents, highCents: $highCents, lowCents: $lowCents, closeCents: $closeCents, medianCents: $medianCents, samples: $samples)';
}


}

/// @nodoc
abstract mixin class _$BarCopyWith<$Res> implements $BarCopyWith<$Res> {
  factory _$BarCopyWith(_Bar value, $Res Function(_Bar) _then) = __$BarCopyWithImpl;
@override @useResult
$Res call({
 DateTime t, int openCents, int highCents, int lowCents, int closeCents, int medianCents, int samples
});




}
/// @nodoc
class __$BarCopyWithImpl<$Res>
    implements _$BarCopyWith<$Res> {
  __$BarCopyWithImpl(this._self, this._then);

  final _Bar _self;
  final $Res Function(_Bar) _then;

/// Create a copy of Bar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? t = null,Object? openCents = null,Object? highCents = null,Object? lowCents = null,Object? closeCents = null,Object? medianCents = null,Object? samples = null,}) {
  return _then(_Bar(
t: null == t ? _self.t : t // ignore: cast_nullable_to_non_nullable
as DateTime,openCents: null == openCents ? _self.openCents : openCents // ignore: cast_nullable_to_non_nullable
as int,highCents: null == highCents ? _self.highCents : highCents // ignore: cast_nullable_to_non_nullable
as int,lowCents: null == lowCents ? _self.lowCents : lowCents // ignore: cast_nullable_to_non_nullable
as int,closeCents: null == closeCents ? _self.closeCents : closeCents // ignore: cast_nullable_to_non_nullable
as int,medianCents: null == medianCents ? _self.medianCents : medianCents // ignore: cast_nullable_to_non_nullable
as int,samples: null == samples ? _self.samples : samples // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ChartData {

 String get key; ChartRange get range;/// '1 hour' | '4 hours' | '1 day' | '7 days'
 String get bucket; List<Bar> get bars; double? get rangePct;/// 처음 수집한 시각, 쌓인 매시간 시세 수
 DateTime? get since; int get points;
/// Create a copy of ChartData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChartDataCopyWith<ChartData> get copyWith => _$ChartDataCopyWithImpl<ChartData>(this as ChartData, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChartData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChartData&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.bucket, _this.bucket) || other.bucket == _this.bucket)&&const DeepCollectionEquality().equals(other.bars, _this.bars)&&(identical(other.rangePct, _this.rangePct) || other.rangePct == _this.rangePct)&&(identical(other.since, _this.since) || other.since == _this.since)&&(identical(other.points, _this.points) || other.points == _this.points));
}


@override
int get hashCode {
  final _this = this as ChartData;
  return Object.hash(runtimeType,_this.key,_this.range,_this.bucket,const DeepCollectionEquality().hash(_this.bars),_this.rangePct,_this.since,_this.points);
}

@override
String toString() {
  final _this = this as ChartData;
  return 'ChartData(key: ${_this.key}, range: ${_this.range}, bucket: ${_this.bucket}, bars: ${_this.bars}, rangePct: ${_this.rangePct}, since: ${_this.since}, points: ${_this.points})';
}


}

/// @nodoc
abstract mixin class $ChartDataCopyWith<$Res>  {
  factory $ChartDataCopyWith(ChartData value, $Res Function(ChartData) _then) = _$ChartDataCopyWithImpl;
@useResult
$Res call({
 String key, ChartRange range, String bucket, List<Bar> bars, double? rangePct, DateTime? since, int points
});




}
/// @nodoc
class _$ChartDataCopyWithImpl<$Res>
    implements $ChartDataCopyWith<$Res> {
  _$ChartDataCopyWithImpl(this._self, this._then);

  final ChartData _self;
  final $Res Function(ChartData) _then;

/// Create a copy of ChartData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? range = null,Object? bucket = null,Object? bars = null,Object? rangePct = freezed,Object? since = freezed,Object? points = null,}) {
  return _then(ChartData(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ChartRange,bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as String,bars: null == bars ? _self.bars : bars // ignore: cast_nullable_to_non_nullable
as List<Bar>,rangePct: freezed == rangePct ? _self.rangePct : rangePct // ignore: cast_nullable_to_non_nullable
as double?,since: freezed == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as DateTime?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChartData].
extension ChartDataPatterns on ChartData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChartData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChartData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChartData value)  $default,){
final _that = this;
switch (_that) {
case _ChartData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChartData value)?  $default,){
final _that = this;
switch (_that) {
case _ChartData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  ChartRange range,  String bucket,  List<Bar> bars,  double? rangePct,  DateTime? since,  int points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChartData() when $default != null:
return $default(_that.key,_that.range,_that.bucket,_that.bars,_that.rangePct,_that.since,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  ChartRange range,  String bucket,  List<Bar> bars,  double? rangePct,  DateTime? since,  int points)  $default,) {final _that = this;
switch (_that) {
case _ChartData():
return $default(_that.key,_that.range,_that.bucket,_that.bars,_that.rangePct,_that.since,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  ChartRange range,  String bucket,  List<Bar> bars,  double? rangePct,  DateTime? since,  int points)?  $default,) {final _that = this;
switch (_that) {
case _ChartData() when $default != null:
return $default(_that.key,_that.range,_that.bucket,_that.bars,_that.rangePct,_that.since,_that.points);case _:
  return null;

}
}

}

/// @nodoc


class _ChartData implements ChartData {
  const _ChartData({required this.key, required this.range, required this.bucket, required  List<Bar> bars, this.rangePct, this.since, required this.points}): _bars = bars;
  

@override final  String key;
@override final  ChartRange range;
/// '1 hour' | '4 hours' | '1 day' | '7 days'
@override final  String bucket;
 final  List<Bar> _bars;
@override List<Bar> get bars {
  if (_bars is EqualUnmodifiableListView) return _bars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bars);
}

@override final  double? rangePct;
/// 처음 수집한 시각, 쌓인 매시간 시세 수
@override final  DateTime? since;
@override final  int points;

/// Create a copy of ChartData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChartDataCopyWith<_ChartData> get copyWith => __$ChartDataCopyWithImpl<_ChartData>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChartData&&(identical(other.key, key) || other.key == key)&&(identical(other.range, range) || other.range == range)&&(identical(other.bucket, bucket) || other.bucket == bucket)&&const DeepCollectionEquality().equals(other.bars, _bars)&&(identical(other.rangePct, rangePct) || other.rangePct == rangePct)&&(identical(other.since, since) || other.since == since)&&(identical(other.points, points) || other.points == points));
}


@override
int get hashCode {
    return Object.hash(runtimeType,key,range,bucket,const DeepCollectionEquality().hash(_bars),rangePct,since,points);
}

@override
String toString() {
    return 'ChartData(key: $key, range: $range, bucket: $bucket, bars: $bars, rangePct: $rangePct, since: $since, points: $points)';
}


}

/// @nodoc
abstract mixin class _$ChartDataCopyWith<$Res> implements $ChartDataCopyWith<$Res> {
  factory _$ChartDataCopyWith(_ChartData value, $Res Function(_ChartData) _then) = __$ChartDataCopyWithImpl;
@override @useResult
$Res call({
 String key, ChartRange range, String bucket, List<Bar> bars, double? rangePct, DateTime? since, int points
});




}
/// @nodoc
class __$ChartDataCopyWithImpl<$Res>
    implements _$ChartDataCopyWith<$Res> {
  __$ChartDataCopyWithImpl(this._self, this._then);

  final _ChartData _self;
  final $Res Function(_ChartData) _then;

/// Create a copy of ChartData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? range = null,Object? bucket = null,Object? bars = null,Object? rangePct = freezed,Object? since = freezed,Object? points = null,}) {
  return _then(_ChartData(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ChartRange,bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as String,bars: null == bars ? _self._bars : bars // ignore: cast_nullable_to_non_nullable
as List<Bar>,rangePct: freezed == rangePct ? _self.rangePct : rangePct // ignore: cast_nullable_to_non_nullable
as double?,since: freezed == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as DateTime?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
