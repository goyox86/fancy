class Mixin {
  def mixin_method {
    'mixed_in_found
  }
}

class ClassWithMixin {
  def normal_method {
    'normal_found
  }
}

class ClassWithNoMixin {
  read_slots: ['foo, 'bar, 'baz]
  write_slots: ['hello, 'world]
  read_write_slots: ['oh, 'noes]

  def normal_method {
    'new_normal_found
  }
}

class ClassWithPrivate {
  def public_method {
    "public!"
  }

  def protected protected_method {
    "protected!"
  }

  def private private_method {
    "private!"
  }
}

FancySpec describe: Class with: {
  it: "should NOT find the method when not mixed-in" for: 'responds_to?: when: {
    instance = ClassWithMixin new
    instance normal_method . should == 'normal_found
    instance responds_to?: 'normal_method . should == true
    instance responds_to?: 'mixin_method . should == false
  }

  it: "should find the method when mixed-in" for: 'include: when: {
    # => include Mixin into ClassWithMixin
    class ClassWithMixin {
      include: Mixin
    }

    instance = ClassWithMixin new
    instance responds_to?: 'normal_method . should == true
    instance responds_to?: 'mixin_method . should == true
    instance normal_method . should == 'normal_found
    instance mixin_method . should == 'mixed_in_found
  }

  it: "should rebind the old class name with ClassWithNoMixin and replace the old normal_method" when: {
    instance = ClassWithMixin new
    instance normal_method should == 'normal_found
    # rebind the class to the other class
    ClassWithMixin = ClassWithNoMixin
    instance = ClassWithMixin new
    instance normal_method should == 'new_normal_found
  }

  it: "should have dynamically generated getter methods" for: 'responds_to?: when: {
    instance = ClassWithNoMixin new
    instance responds_to?: 'foo . should == true
    instance responds_to?: 'bar . should == true
    instance responds_to?: 'baz . should == true
    instance responds_to?: "hello:" . should == true
    instance responds_to?: "world:" . should == true
    instance responds_to?: 'oh . should == true
    instance responds_to?: ":oh" . should == true
    instance responds_to?: 'noes . should == true
    instance responds_to?: "noes:" . should == true
  }

  it: "should find the instance variable correctly" when: {
    class AClass {
      def initialize: foo {
        @foo = foo
      }
      def foo {
        @foo
      }
    }

    str = "instance value"
    instance = AClass new: str
    instance foo should == str
    AClass new foo should == nil
  }

  it: "should find the class variable correctly" when: {
    class AClass {
      def foo: foo {
        @@foo = foo
      }
      def foo {
        @@foo
      }
    }

    instance1 = AClass new
    instance2 = AClass new
    str = "class value"
    instance1 foo: str
    instance1 foo should == str
    instance2 foo should == str
    instance2 foo should == (instance1 foo)

    str2 = "another value"
    instance2 foo: str2
    instance2 foo should == str2
    instance1 foo should == str2
  }

  it: "should have correct method overloading for method names with and without an argument" when: {
    class AClass {
      def foo {
        foo: "None!"
      }

      def foo: bar {
        "In AClass#foo: with bar = " ++ bar
      }
    }

    instance = AClass new
    instance foo should == "In AClass#foo: with bar = None!"
    instance foo: "Test!" . should == "In AClass#foo: with bar = Test!"
  }

  # it: "should call superclass method by calling super" when: {
  #   class SuperClass {
  #     read_slots: ['name]
  #     def initialize: name {
  #       @name = name
  #     }
  #   }
  #   class SubClass : SuperClass {
  #     read_slots: ['age]

  #     def initialize: age {
  #       super initialize: "SubClass"
  #       @age = age
  #     }
  #     def initialize {
  #       super initialize: "SubClass"
  #       @age = 0
  #     }
  #   }

  #   sub = SubClass new: 42
  #   sub name should == "SubClass"
  #   sub age should == 42

  #   sub2 = SubClass new
  #   sub2 name should == "SubClass"
  #   sub2 age should == 0
  # }

  it: "should return its superclass" when: {
    Fixnum superclass should == Integer
    Symbol superclass should == Object
    StdError superclass should == Exception
    Class superclass should == Module
    Object superclass should == nil

    IOError superclass should == StandardError
    NoMethodError superclass should == NameError
  }

  # it: "should create a new Class dynamically" when: {
  #   x = Class new
  #   x is_a?: Class . should == true
  #   x new is_a?: x . should == true
  #   x new is_a?: Object . should == true
  #   x new class should == x

  #   # Symbol as superclass
  #   y = Class new: Symbol
  #   y is_a?: Class . should == true
  #   y new is_a?: Symbol . should == true
  #   y new is_a?: Object . should == true
  # }

  it: "should only be able to call the public method from outside the Class" when: {
    x = ClassWithPrivate new
    x public_method should == "public!"
    try {
      x private_method should == nil # should fail
    } catch NoMethodError => e {
      e method_name should == "private_method"
    }
    try {
      x protected_method should == nil # should fail
    } catch NoMethodError => e {
      e method_name should == "protected_method"
    }
  }

  it: "should be a subclass of another Class" for: 'subclass?: when: {
    class Super {
    }
    class Sub : Super {
    }

    Super subclass?: Object . should == true
    Sub subclass?: Object . should == true
    Sub subclass?: Super . should == true
    Super subclass?: Sub . should == nil
  }

  # it: "should dynamically create a subclass of another class" for: 'is_a?: when: {
  #   subclass = String subclass: {
  #     def foo {
  #       "hello, world!"
  #     }
  #   }
  #   subclass is_a?: Class . should == true
  #   subclass subclass?: String . should == true
  #   subclass new is_a?: subclass . should == true
  #   subclass new foo should == "hello, world!"

  #   # now the same with Class##new:body:
  #   subclass2 = Class superclass: Symbol body: {
  #     def foo {
  #       "hello, world, again!"
  #     }
  #   }
  #   subclass2 is_a?: Class . should == true
  #   subclass2 subclass?: String . should == true
  #   subclass2 new is_a?: subclass2 . should == true
  #   subclass2 new foo should == "hello, world, again!"
  # }

  it: "should undefine an instance method" for: 'undefine_method: when: {
    class Foo {
      def instance_method {
        "instance method!"
      }
    }
    f = Foo new
    f instance_method should == "instance method!"
    Foo undefine_method: 'instance_method
    try {
      f instance_method should == nil # should not get here
    } catch NoMethodError => e {
      e method_name should == "instance_method"
    }
  }

  it: "should undefine a class method" for: 'undefine_class_method: when: {
    class Foo {
      def self class_method {
        "class method!"
      }
    }
    Foo class_method should == "class method!"

    try {
      Foo undefine_method: 'class_method
      true should == nil # should not happen
    } catch NameError {
      true should == true
    }

    Foo undefine_class_method: 'class_method

    try {
      Foo class_method should == nil # should not get here
    } catch NoMethodError => e {
      e method_name should == "class_method"
    }
  }

  # it: "should have nested classes" when: {
  #   class Outer {
  #     class Inner {
  #       class InnerMost {
  #         def foobar {
  #           "foobar!"
  #         }
  #       }
  #     }
  #   }
  #   Outer is_a?: Class . should == true
  #   Outer::Inner is_a?: Class . should == true
  #   Outer::Inner::InnerMost is_a?: Class . should == true
  #   obj = Outer::Inner::InnerMost new
  #   obj foobar should == "foobar!"

  #   # change InnerMost#foobar
  #   class Outer::Inner::InnerMost {
  #     def foobar {
  #       "oh no!"
  #     }
  #   }
  #   obj foobar . should == "oh no!"
  # }

  it: "should not override existing classes with the same name in a nested class" when: {
    StdArray = Array
    class NameSpace {
      class Array {
        def Array what_am_i {
          "not the same as the standard Array class"
        }
      }
    }

    NameSpace::Array what_am_i . should == "not the same as the standard Array class"
    NameSpace::Array should_not == Array
  }

  # it: "should return all nested classes of a class" for: 'nested_classes when: {
  #   class Outer {
  #   }
  #   Outer nested_classes should == []

  #   class Outer {
  #     class Inner1 {
  #     }
  #   }
  #   Outer nested_classes should == [Outer::Inner1]

  #   class Outer {
  #     class Inner2 {
  #     }
  #   }
  #   Outer nested_classes should == [Outer::Inner1, Outer::Inner2]
  # }

  it: "should find other nested classes in the same parent class" when: {
    class MyOuter {
      class Inner1 {
        def method1 {
          'method_1
        }
      }
      class Inner2 {
        include: Inner1
        def method2 {
          'method_2
        }
      }
    }

    MyOuter::Inner1 new method1 should == 'method_1
    MyOuter::Inner2 new method1 should == 'method_1
    MyOuter::Inner2 new method2 should == 'method_2
  }

  it: "should find itself in it's own methods, even if nested into another class" when: {
    class MyOuter {
      class MyInner1 {
        def method1 {
          MyInner1
        }
        def self class_method1 {
          MyInner1
        }
      }
      class MyInner2 {
        def method2 {
          [MyInner1, MyInner2]
        }
        def self class_method2 {
          [MyInner1, MyInner2]
        }
      }
    }

    MyOuter::MyInner1 new method1 should == MyOuter::MyInner1
    MyOuter::MyInner2 new method2 should == [MyOuter::MyInner1, MyOuter::MyInner2]
    MyOuter::MyInner1 class_method1 should == MyOuter::MyInner1
    MyOuter::MyInner2 class_method2 should == [MyOuter::MyInner1, MyOuter::MyInner2]
  }

  it: "should have an alias method as defined" for: 'alias_method:for: when: {
    class AClass {
      def foo {
        "in foo!"
      }

      alias_method: 'bar for: 'foo
    }

    obj = AClass new
    obj foo should == "in foo!"
    obj bar should == "in foo!"
  }
}
