FancySpec describe: Object with: |it| {
  it should: "dynamically evaluate a message-send with no arguments" when: {
    obj = 42;
    obj send: "to_s" . should_equal: "42"
  };

  it should: "dynamically evaluate a message-send with a list of arguments" when: {
    obj = "hello, world";
    obj send: "from:to:" params: [0,4] . should_equal: "hello"
  };

  it should: "dynamically define slotvalues" when: {
    obj = Object new;
    obj get_slot: :foo . should_equal: nil;
    obj set_slot: :foo value: "hello, world";
    obj get_slot: :foo . should_equal: "hello, world"
  };

  it should: "return its class" when: {
    nil _class should_equal: NilClass;
    true _class should_equal: TrueClass;
    "foo" _class should_equal: String;
    :bar _class should_equal: Symbol;
    { :a_block } _class should_equal: Block
  };

  it should: "call unkown_message:with_params: when calling an undefined method" when: {
    def class UnkownMessage {
      def unknown_message: message with_params: params {
        "Got: " ++ message ++ " " ++ params
      }
    };

    obj = UnkownMessage new;
    obj this_is_not_defined: "It's true!" . should_equal: "Got: this_is_not_defined: [It's true!]"
  }
}
