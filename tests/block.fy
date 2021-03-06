FancySpec describe: Block with: {
  it: "should return the value of the last expression" when: {
    block = {
      a = "a"
      empty = " "
      str = "String!"
      a ++ empty ++ str
    }
    block call should == "a String!"
  }

  it: "should close over a value and change it internally" when: {
    x = 0
    { x < 10 } while_true: {
      x should be: |x| { x < 10 }
      x = x + 1
    }
    x should == 10
  }

  it: "should return the argument count" for: 'argcount when: {
    { } argcount . should == 0
    |x| { } argcount . should == 1
    |x y z| { } argcount . should == 3
  }

  it: "should call a block while another is true" for: 'while_true: when: {
    i = 0
    {i < 10} while_true: {
      i = i + 1
    }
    i should be: { i >= 10 }
  }

  it: "should call a block while another is not true (boolean false)" for: 'while_false: when: {
    i = 0
    {i == 10} while_false: {
      i = i + 1
    }
    i should == 10
  }

  # again for while_nil
  it: "should call a block while another is nil" for: 'while_nil: when: {
    i = 0
    {i == 10} while_nil: {
      i = i + 1
    }
    i should == 10
  }

  it: "should call a block while another one is true-ish" for: 'while_do: when: {
    x = 0
    { x < 10 } while_do: |val| {
      val should == true
      x = x + 1
    }
  }

  it: "should call itself only when the argument is nil" for: 'unless: when: {
    try {
      { StdError new: "got_run!" . raise! } unless: nil
      StdError new: "didnt_run!" . raise!
    } catch StdError => e {
      e message should == "got_run!"
    }
  }

  it: "should call itself only when the argument is true" for: 'if: when: {
    try {
      { StdError new: "got_run!" . raise! } if: true
      StdError new: "didnt_run!" . raise!
    } catch StdError => e {
      e message should == "got_run!"
    }
  }

  it: "should also be able to take arguments seperated by comma" for: 'call: when: {
    block = |x, y| { x + y }
    block call: [1,2] . should == 3
  }

  it: "should evaluate the blocks in a short-circuiting manner" for: '&& when: {
    { false } && { false } should == false
    { true } && { false } should == false
    { false } && { true } should == false
    { true } && { true } should == true

    { false } || { false } should == false
    { false } || { true } should == true
    { true } || { false } should == true
    { true } || { true } should == true

    # TODO: Add more useful tests here...
  }
}
