import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:mirrors';
import 'dart:typed_data';

abstract class IdxList implements List<int> {
  int operator [](int i) {
    return i;
  }
}

abstract class SinList implements List<double> {
  List<num> base = [];

  @override
  double operator [](int i) {
    return sin(base[i]);
  }

  @override
  void operator []=(int i, double val) {
    base[i] = asin(val);
  }
}

abstract class DivList implements List<double> {
  List<num> base = [];
  List<num> div = [];

  @override
  double operator [](int i) {
    return base[i] / div[i];
  }

  @override
  void operator []=(int i, double val) {
    base[i] = val * div[i];
  }
}

class Simlab {
  void welcome() {
    stdout.writeln("Welcome to Simlab 1.0");
  }

  Iterable<num> rand() sync* {
    Random random = Random.secure();
    while (true) yield random.nextDouble();
  }

  Iterable<int> idx() sync* {
    int i = 0;
    while (true) yield i++;
  }

  int ix(int i) {
    return i;
  }

  int transidx(int i, int c, int r) {
    int cc = i % c;
    int rr = i ~/ c;

    return cc * r + rr;
  }

  Iterable<int> fibo() sync* {
    int one = 0;
    yield one;
    int two = 1;
    yield two;
    int three = one + two;
    yield three;
    while (true) {
      one = two;
      two = three;
      three = one + two;
      yield three;
    }
  }

  int fib(int n) {
    var sqrt5 = sqrt(5);
    return (pow(1 + sqrt5, n) - pow(1 - sqrt5, n)) ~/ (pow(2, n) * sqrt5);
  }

  void print(Iterable<num> it, int c) {
    it.take(c).forEach((element) {
      stdout.writeln(element.toString());
    });
  }

  Int32List int32List(int len) {
    return Int32List(len);
  }

  Int32List int32Idx(int len) {
    return Int32List.fromList(List.generate(len, (index) => index));
  }
}

var varmap = Map<String, Iterable<num>>();
Iterable<num> current = Iterable.empty();

void main(List<String> arguments) {
  var sl = Simlab();
  var slr = reflect(sl);

  String? line = stdin.readLineSync();
  while (line != null) {
    List<String> split = line.split(" ");
    String cmd = split[0];
    if (cmd == "quit") {
      exit(0);
    }
    List<dynamic> args = split
        .sublist(1, split.length)
        .map((arg) => int.tryParse(arg) ?? arg)
        .toList();
    //stdout.writeln(line);
    try {
      current = slr.invoke(Symbol(cmd), args).reflectee as Iterable<num>;
    } catch (e) {
      print(e);
    }
    line = stdin.readLineSync();
  }
}
