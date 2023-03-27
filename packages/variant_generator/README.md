# Variant (Generator)

Allows to generate a set of variants for an application from a set of simple enums, and then to create adapted data classes for each one of these variant combinations. Each combination of variants is represented as a unique int value (a bit mask), which makes comparison really efficient.

## Setup

Add the required dependencies to your `pubspec.yaml` file :

```yaml
dependencies:
  variant: <version>
dev_dependencies:
  build_runner: ^2.3.3
  variant_generator: <version>
```

## Usage

### Defining variants

All variants must be located in a single file, and represented by an enumeration annotated with `@variant` :

```dart
import 'package:variant/variant.dart';

part '<filename>.g.dart';

@variant
enum Brightness {
  light,
  dark,
}

@variant
enum Animation {
  all,
  minimal,
  none,
}
```

To generate the `Variant` class, run the build runner from the CLI : 

```bash
> flutter pub run build_runner build
```

You can now create a global `Variant` instance, which is a combination of each one of your variants with `<variant>Flag` declinations.

```dart
final variant = Variant(
    brightness: Brightness.dark,
    animation: Animation.minimal,
);

if(variant.matchesAny({ AnimationFlag.all, AnimationFlag.minimal })) {
    print('Matches these variants!');
}

if(variant.matchesEvery({ BrightnessFlag.dark, AnimationFlag.minimal })) {
    print('Matches these variants!');
}
```

### Defining data classes

To create a class which properties are depdendent on a current `Variant`, create a class and annotate it with `@variantData`.

To declare a property with variants, add a getter which returns a `Variants<T>` instance. Its first argument is its default value, and its second one is a set of values associated to a combination of variants.

For example, here we are declaring a an `accent` property of type `Color`. We give it a default value of `Color.fromARGB(255, 85, 26, 235)`, and a variant value for `{Brightness.dark}` of `Color.fromARGB(255, 56, 98, 245)`.

```dart
import 'package:variant/variant.dart';

part '<filename>.g.dart';

@variantData
abstract class Colors {
  get accent => Variants<Color>(
        () => const Color.fromARGB(255, 85, 26, 235),
        {
          {Brightness.dark}: () => const Color.fromARGB(255, 56, 98, 245),
        },
      );
}
```

To generate the associated data class, run the build runner from the CLI : 

```bash
> flutter pub run build_runner build
```

You can now create a `<Name>Data` instance from a given `Variant` instance :

```dart
final variant = Variant(
    brightness: Brightness.dark,
    animation: Animation.minimal,
);
final colors = ColorsData.fromVariant(variant);
final accent = colors.accent; // Color.fromARGB(255, 56, 98, 245)
```

A great feature of data classes is also fine grained updates. By using the `update` method, a new instance will be created only if one of its dependencies changed.

```dart
var variant = Variant(
    brightness: Brightness.dark,
    animation: Animation.minimal,
);
var colors = ColorsData.fromVariant(variant);

variant = Variant(
    brightness: Brightness.dark,
    animation: Animation.all,
);

colors = colors.update(variant); /// Returned instance is the same since none of its properties depends on Animation.all or Animation.minimal.

variant = Variant(
    brightness: Brightness.light,
    animation: Animation.all,
);

colors = colors.update(variant); /// A new instance is created with `ColorsData.fromVariant(variant)` because `Brightness.dark` changed.


```

## Limitations

Since all combinations are represented as a single `int` value of `64` bits, the maximum total number of variant values allowed is `64`.

## Flutter theming example

To get a more complete example, and understand how the variants can be used in a Flutter context, take a look at [the example](https://github.com/aloisdeniel/variant/tree/main/packages/flutter_example).

## Q&A

> Why using it for theming instead of regular options like Material?

The main advantage of custom variants is that it is really specific to your usage. It means that it is a lot less generic than the Material theming, but it also means that it provides a better optimization. In fact, a theme data instance is associated to a variant, and a difference is a lot more efficient to calculate since a variant is represented as a single `int` (*instead of comparing the whole data tree to detect a difference*).

Another advantage is that data classes will be really adapted to you custom design system, by adoption the right naming conventions and properties. For example, your app might have more themes than just the `dark` and `light` modes. Also you might need only ten colors, and by using Material's theme you would bring a lot of confusion by exposing properties that must not be used. It also mean that you only instanciate what you need in memory, and not all the widget specific themes that you might never use in reality.
